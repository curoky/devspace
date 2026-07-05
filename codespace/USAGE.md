# Codespace 使用说明

本文档面向使用者，说明如何部署 agent，并通过本地 Web GUI 创建、查看、删除远程开发容器。架构与
协议细节见 [`DESIGN.md`](./DESIGN.md)，Web GUI 设计见 [`WEBGUI_DESIGN.md`](./WEBGUI_DESIGN.md)。

## 1. 组件与前置条件

| 组件 | 运行位置 | 前置条件 |
| --- | --- | --- |
| **agent** | Linux 宿主机 | rootful Podman、可被 client 访问的 HTTP 端口 |
| **client / Web GUI** | 本地机器 | Python 3.13+、`uv`、`ssh`、`ssh-keygen` |
| **dev 镜像** | agent 拉起 | sshd 支持 `SSHD_PORT`、默认用户 `x`、`/workspace` 可写、包含 git/ssh |

GitHub / GitLab token 只在 client 本地进程中读取，用于注册和吊销 deploy key；token 不会发送给
agent，也不会返回给浏览器。

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

github:
  token_env: GITHUB_TOKEN

gitlab:
  token_env: GITLAB_TOKEN
  api_url: https://gitlab.com
  ssh_host: gitlab.com

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
    git_ssh_host: gitlab.example.com
```

注意：

- `token_env` 必须写环境变量名，不要写 token 明文。
- `defaults.agent` 必须存在于 `agents`。
- template 的 `agent` 如设置，也必须存在于 `agents`。
- template 的 `repo` 使用 `owner/name` 或 `group/project` 形式。
- `ssh_proxy=true` 时必须配置 `ssh_proxy_host`。

## 5. 准备 token

按配置中的 env 名称导出 token：

```bash
export GITHUB_TOKEN=github_pat_xxx
export GITLAB_TOKEN=glpat-xxx
```

权限要求：

- token 对目标 repo 需要有管理 deploy key 的权限；
- 创建时 client 会注册 deploy key；
- 删除时 client 会按 title `codespace-<id>` 查找并删除 deploy key。

如果某个 provider token 缺失，对应 provider 的创建会被 Web API 拒绝；删除仍会尽量删除远端容器，
但会返回“跳过 deploy key 吊销”的 warning。

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

不要把 Web GUI 暴露到不可信网络。Web GUI 进程可以访问本地 token、SSH key 和 `~/.ssh/config`。

## 7. 在 Web GUI 中创建 codespace

1. 打开 Web GUI。
2. 选择一个 template，或点击 Create 使用空白表单。
3. 确认 agent、provider、repo、image。
4. 填写 instance，例如 `default`、`debug`、`feature-x`。
5. 如需要代理等非敏感配置，在 Environment variables 中填写每行 `KEY=VALUE`。
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

### 7.1 容器环境变量

创建表单的 Environment variables 用于传递非敏感运行环境，例如：

```text
HTTP_PROXY=http://proxy.example.com:7890
HTTPS_PROXY=http://proxy.example.com:7890
NO_PROXY=localhost,127.0.0.1
```

规则：

- 每行一个 `KEY=VALUE`；
- 空行和 `#` 开头的注释行会被忽略；
- 变量名必须是合法 shell 风格 env 名称；
- `SSHD_PORT` 是系统保留变量，不能覆盖；
- 不要填写 token、password、private key 等敏感信息。

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

如果 token 缺失，容器仍可删除，但 deploy key 吊销会被跳过并显示 warning。

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

- 确认配置中的 `github.token_env` / `gitlab.token_env` 是环境变量名。
- 确认启动 Web GUI 的同一个 shell 中已 `export` 对应 token。
- 不要把 token 明文写进 YAML。

### 创建失败：deploy key 注册失败

- 确认 token 对目标 repo 有 deploy key 管理权限。
- 检查 repo 路径是否正确。
- 检查目标 repo 是否已经存在同 title 的异常 deploy key；必要时手动清理 `codespace-<id>` key。

### 创建失败：clone 失败

- 通常说明 deploy key 尚未生效、repo 路径错误或 Git SSH host 配置错误。
- 检查 template 的 `provider` 和 `git_ssh_host`。
- GitLab 自建实例需要正确配置 `gitlab.api_url` 与 `gitlab.ssh_host`。

### `ssh <alias>` 连不上

- 检查 `~/.ssh/config` 中对应 Host 是否存在。
- 检查 agent profile 的 `ssh_host` 是否是本地可达的宿主机地址。
- 检查宿主机防火墙是否允许访问容器 sshd 随机端口。
- 尝试页面展示的 raw SSH 命令。

### 删除后 workspace 仍在

这是默认行为。只有选择 purge 才会删除 workspace 目录。

## 13. 安全边界

- agent 不持有 GitHub / GitLab token。
- Web GUI 进程可访问本地 token、SSH key 和 `~/.ssh/config`，默认只监听 localhost。
- 不要把 Web GUI 暴露到不可信网络。
- deploy key 粒度限制在单个 repo。
- 删除 codespace 时由 client 负责吊销 deploy key。
