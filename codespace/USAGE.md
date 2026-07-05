# Codespace 使用说明

本文档面向使用者，说明如何部署 agent，并通过本地 Web GUI 创建、查看、删除远程开发容器。架构与
协议细节见 [`DESIGN.md`](./DESIGN.md)，Web GUI 设计见 [`WEBGUI_DESIGN.md`](./WEBGUI_DESIGN.md)。

## 1. 组件与前置条件

| 组件 | 运行位置 | 前置条件 |
| --- | --- | --- |
| **agent** | Linux 宿主机 | rootful Podman、可被 client 访问的 HTTP 端口 |
| **client / Web GUI** | 本地机器 | Python 3.13+、`uv`、`ssh`、`ssh-keygen` |
| **dev 镜像** | agent 拉起 | sshd 支持 `SSHD_PORT`、默认用户 `x`、`/workspace` 可写、包含 git/ssh |

GitHub / GitLab token 在 Web GUI 页面中填写后保存到本地 Python Web GUI service 的进程内存中，
用于注册和吊销 deploy key；token 不会发送给 agent，也不会写入 YAML 配置或浏览器持久化存储。

## 2. 构建或拉取镜像

### 2.1 参考开发镜像

```bash
podman build -t codespace/dev:latest -f codespace/image/Dockerfile .
```

也可以使用项目发布的参考镜像，例如：

```text
ghcr.io/curoky/devspace:codespace-debian12
```

### 2.2 agent 镜像

```bash
podman build -t codespace/agent:latest -f codespace/agent/Dockerfile .
```

如果已有发布镜像，可直接拉取：

```bash
podman pull ghcr.io/curoky/devspace:codespace-agent
```

## 3. 启动 agent

### 3.1 使用参考脚本

```bash
ADVERTISE_HOST=10.0.0.5 \
WORKSPACE_ROOT_HOST=/var/lib/codespace-workspaces \
bash codespace/agent/run-agent.sh
```

### 3.2 直接 podman run

```bash
podman run --rm --name codespace-agent \
  --network host \
  -v /run/podman/podman.sock:/run/podman/podman.sock \
  ghcr.io/curoky/devspace:codespace-agent \
  serve \
  --workspace-root-host /var/lib/codespace-workspaces \
  --podman-uri unix:///run/podman/podman.sock \
  --host 0.0.0.0 --port 8001
```

参数说明：

| 参数 | 必填 | 说明 |
| --- | --- | --- |
| `--workspace-root-host` | 是 | 宿主机 workspace 根目录。该路径由宿主机 podman service 解释。 |
| `--podman-uri` | 是 | podman service socket URI。 |
| `--host` | 否 | agent HTTP 监听地址，默认 `0.0.0.0`。 |
| `--port` | 否 | agent HTTP 监听端口，默认 `8001`。 |

验证：

```bash
curl http://10.0.0.5:8001/codespaces
```

正常情况下返回 `[]`。

## 4. 配置 client Web GUI

默认配置文件：

```text
~/.config/codespace/config.yaml
```

可用环境变量覆盖：

```bash
export CODESPACE_CONFIG=/path/to/config.yaml
```

完整示例：

```yaml
defaults:
  agent: home
  image: ghcr.io/curoky/devspace:codespace-debian12

agents:
  home:
    agent_url: http://10.0.0.5:8001
    ssh_host: 10.0.0.5

  office:
    agent_url: http://127.0.0.1:8001
    ssh_host: dev-host
    ssh_proxy: true
    ssh_proxy_host: office-bastion

templates:
  devspace:
    description: devspace 主仓库默认开发环境
    agent: home
    provider: github
    repo: curoky/devspace
    image: ghcr.io/curoky/devspace:codespace-debian12

  service-api:
    description: GitLab API 服务
    agent: office
    provider: gitlab
    repo: group/service-api
```

注意：

- `defaults.agent` 必须存在于 `agents`。
- template 的 `agent` 如设置，也必须存在于 `agents`。
- template 的 `repo` 使用 `owner/name` 或 `group/project` 形式。
- `ssh_proxy=true` 时必须配置 `ssh_proxy_host`。

## 5. 准备 token

在 Web GUI 页面顶部填写 GitHub / GitLab token，并点击对应的 Save 按钮。token 会保存到本地
Python Web GUI service 的进程内存中；刷新页面或重启浏览器后，页面会重新读取“是否已保存”的状态，
不需要重复填写。重启 Python Web GUI service 后，内存 token 会丢失，需要重新保存。

权限要求：

- token 对目标 repo 需要有管理 deploy key 的权限；
- 创建时 Web GUI 会用 service 内存中对应 provider 的 token 注册 deploy key；
- 删除时 Web GUI 会用 service 内存中对应 provider 的 token 按 title `codespace-<id>` 查找并删除 deploy key。

如果某个 provider token 未保存，对应 provider 的创建会被后端拒绝；删除仍会尽量删除远端容器，但会
返回“跳过 deploy key 吊销”的 warning。

## 6. 启动 Web GUI

```bash
uv run python -m codespace.client
```

默认监听：

```text
127.0.0.1:8765
```

自定义监听地址和端口：

```bash
CODESPACE_WEB_HOST=127.0.0.1 CODESPACE_WEB_PORT=8765 uv run python -m codespace.client
```

不要把 Web GUI 暴露到不可信网络。Web GUI 可操作本地 SSH key、`~/.ssh/config`，并会在进程内存中
保存 provider token。

## 7. 在 Web GUI 中创建 codespace

1. 打开 Web GUI。
2. 在页面顶部填写目标 provider 的 token，并点击 Save 保存到 Python service 内存。
3. 在顶部 template select 中选择一个 template，或在 template 行点击 `New instance`。
4. 确认弹窗中的 agent、provider、repo、image。
5. 填写 instance，例如 `default`、`debug`、`feature-x`。
6. 提交创建。
7. 在 operation timeline 中观察进度。

系统自动生成本地 SSH alias：

```text
<agent>-<template>-<instance>
```

例如：

```text
home-devspace-default
office-service-api-debug
```

创建阶段说明：

| 阶段 | 含义 |
| --- | --- |
| `preparing login key` | client 生成或复用本地登录 keypair。 |
| `requesting agent creation` | client 请求 agent 创建容器。 |
| `agent: ...` | agent 正在准备 workspace、拉镜像、建容器、注入密钥。 |
| `registering deploy key` | client 在 Git provider 注册 deploy key。 |
| `cloning repo into workspace` | agent 在容器 workspace 中 clone 主 repo。 |
| `writing ssh config` | client 写入本地 SSH config 托管块。 |
| `ready` | 创建完成。 |

## 8. 登录和使用

创建成功后，可以直接：

```bash
ssh home-devspace-default
```

Web GUI 也会展示 raw SSH 命令：

```bash
ssh x@10.0.0.5 -p 49207
```

如果本地 alias 存在，优先使用 `ssh <alias>`；如果 alias 缺失，Dashboard 仍会展示 raw SSH 命令。

也可以点击 Trae Remote-SSH deep link 打开 `/workspace/<repo-name>`。

## 9. 删除 codespace

在 Dashboard 中选择实例删除：

- **Delete**：删除容器，保留宿主机 workspace。
- **Delete + Purge**：删除容器并删除宿主机 workspace。

删除会尝试执行：

1. 吊销 Git provider deploy key；
2. 删除 agent 上的容器；
3. 删除本地 `~/.ssh/config` 托管块；
4. 删除本地登录 keypair。

如果对应 provider token 未保存，容器仍可删除，但 deploy key 吊销会被跳过并显示 warning。

## 10. SSH proxy agent

当本地无法直接访问 agent HTTP API，但可以通过 SSH bastion 访问时，可启用 SSH proxy：

```yaml
agents:
  office:
    agent_url: http://127.0.0.1:8001
    ssh_host: dev-host
    ssh_proxy: true
    ssh_proxy_host: office-bastion
```

client 会自动建立本地 SSH HTTP tunnel 访问 agent API。最终登录 codespace 时仍使用 `ssh_host`。

常见用法：

- `ssh_proxy_host` 是你本地 `ssh office-bastion` 能访问的 host alias；
- `agent_url` 可以写 bastion 能访问的 agent 地址；
- 若 agent 只在远端 localhost 监听，可用 `http://127.0.0.1:8001` 配合 SSH tunnel。

## 11. 本地文件位置

| 路径 | 说明 |
| --- | --- |
| `~/.config/codespace/config.yaml` | 默认 Web GUI 配置。 |
| `~/.ssh/codespace/<alias>` | 本地登录私钥。 |
| `~/.ssh/codespace/<alias>.pub` | 本地登录公钥。 |
| `~/.ssh/codespace/known_hosts` | codespace SSH known hosts。 |
| `~/.ssh/config` | Web GUI 写入 codespace 托管块。 |

SSH config 托管块示例：

```sshconfig
# >>> codespace home-devspace-default >>>
# codespace-id: abc123
# codespace-repos: curoky/devspace
# codespace-provider: github
# codespace-agent: home
# codespace-repo: curoky/devspace
Host home-devspace-default
    HostName 10.0.0.5
    Port 49207
    User x
    IdentityFile ~/.ssh/codespace/home-devspace-default
    IdentitiesOnly yes
    HostKeyAlgorithms ssh-ed25519
    StrictHostKeyChecking accept-new
    UserKnownHostsFile ~/.ssh/codespace/known_hosts
    UpdateHostKeys no
# <<< codespace home-devspace-default <<<
```

## 12. 常见问题

### Dashboard 显示 agent offline

- 检查 agent 是否运行：`curl http://<agent>:8001/codespaces`。
- 检查本地是否能访问 `agent_url`。
- 如果使用 SSH proxy，检查 `ssh_proxy_host` 是否能登录。
- 检查 agent 启动参数中的 `--host` / `--port`。

### 创建失败：token missing

- 确认已在 Web GUI 页面顶部填写并保存目标 provider 的 token。
- token 只保存在 Python Web GUI service 进程内存中；如果刚重启过 service，需要重新保存。

### 创建失败：deploy key 注册失败

- 确认 token 对目标 repo 有 deploy key 管理权限。
- 检查 repo 路径是否正确。
- 检查目标 repo 是否已经存在同 title 的异常 deploy key；必要时手动清理 `codespace-<id>` key。

### 创建失败：clone 失败

- 通常说明 deploy key 尚未生效、repo 路径错误或 Git SSH host 不匹配。
- 检查 template 的 `provider`。
- GitLab provider 只支持官方 `gitlab.com` API 和默认 SSH host；如需自建 GitLab 实例，需要重新引入 API/SSH host 配置。

### `ssh <alias>` 连不上

- 检查 `~/.ssh/config` 中对应 Host 是否存在。
- 检查 agent profile 的 `ssh_host` 是否是本地可达的宿主机地址。
- 检查宿主机防火墙是否允许访问容器 sshd 随机端口。
- 尝试页面展示的 raw SSH 命令。

### 删除后 workspace 仍在

这是默认行为。只有选择 purge 才会删除 workspace 目录。

## 13. 安全边界

- agent 不持有 GitHub / GitLab token。
- provider token 只保存在本地 Python Web GUI service 进程内存中，不写入 YAML 或浏览器持久化存储。
- Web GUI 进程可访问本地 SSH key 和 `~/.ssh/config`，默认只监听 localhost。
- 不要把 Web GUI 暴露到不可信网络。
- deploy key 粒度限制在单个 repo。
- 删除 codespace 时由 client 负责吊销 deploy key。
