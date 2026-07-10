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
podman build -t codespace/dev:latest -f codespace/images/dev/Dockerfile .
```

也可以使用项目发布的参考镜像，例如：

```text
ghcr.io/curoky/devspace:codespace-debian12
```

### 2.2 agent 镜像

```bash
podman build -t codespace/agent:latest -f codespace/images/agent/Dockerfile .
```

如果已有发布镜像，可直接拉取：

```bash
podman pull ghcr.io/curoky/devspace:codespace-agent
```

## 3. 启动 agent

### 3.1 使用参考脚本

```bash
WORKSPACE_ROOT_HOST=/var/lib/codespace \
ATUIN_DB_URI=postgres://user:pass@host:5432/atuin \
bash codespace/images/agent/run.sh
```

### 3.2 直接 podman run

```bash
podman run --rm --name codespace-agent \
  --network host \
  -v /tmp/podmanxd.sock:/tmp/podmanxd.sock \
  -v /var/lib/codespace:/var/lib/codespace \
  -e WORKSPACE_ROOT_HOST=/var/lib/codespace \
  -e ATUIN_DB_URI=postgres://user:pass@host:5432/atuin \
  ghcr.io/curoky/devspace:codespace-agent
```

agent 镜像使用 s6 管理进程，容器启动后会自动拉起 `agent-service` 和 `atuin-service`。启动时只传入
`WORKSPACE_ROOT_HOST` 和可选的 `ATUIN_DB_URI`；其他运行参数固定在 s6 run 脚本中，而不是在镜像命令行后追加 `serve ...`
参数。

环境变量说明：

| 环境变量 | 必填 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `WORKSPACE_ROOT_HOST` | 是 | 无 | 宿主机 workspace 根目录。该路径由宿主机 podman service 解释。 |
| `ATUIN_DB_URI` | 否 | 无 | atuin server 数据库连接串。 |

固定参数：agent 监听 `0.0.0.0:8001`，podman socket 为 `unix:///tmp/podmanxd.sock`，atuin 监听
`127.0.0.1:8002` 且关闭开放注册。

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

点击 Web GUI 顶部的 **Tokens**（按钮上会显示已保存的 provider 数量，如 `1/2`）打开弹窗，填写
GitHub / GitLab token 并点击对应的 Save 按钮。token 会保存到本地 Python Web GUI service 的进程内存中；
刷新页面或重启浏览器后，页面会重新读取“是否已保存”的状态，不需要重复填写。重启 Python Web GUI
service 后，内存 token 会丢失，需要重新保存。

权限要求：

- token 对目标 repo 需要有管理 deploy key 的权限；
- 创建时 Web GUI 会用 service 内存中对应 provider 的 token 注册 deploy key；
- 删除时 Web GUI 会用 service 内存中对应 provider 的 token 按 title `codespace-<id>` 查找并删除 deploy key。

GitLab token 说明：

- 支持 GitLab Personal Access Token，也支持 Fine-grained personal access token；
- Fine-grained token 需要覆盖目标 project，并授予 Deploy Key 相关 REST API 权限，至少包括
  list、create、delete project deploy keys；
- client 只调用 project deploy key API，不要求 token 具备读取完整 project 详情的权限；
- GitLab provider 当前只支持官方 `gitlab.com` API 和默认 SSH host。

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

不要把 Web GUI 暴露到不可信网络。Web GUI 可操作本地 SSH key、`~/.ssh/config` 与
`~/.ssh/codespace/ssh_config`，并会在进程内存中保存 provider token。

## 7. 在 Web GUI 中创建 codespace

Web GUI 以「项目」为中心：每个 config template 是一张项目卡，实例（instance）是项目下的运行环境。

1. 打开 Web GUI。
2. 点击顶部 **Tokens**，填写目标 provider 的 token 并点击 Save 保存到 Python service 内存。
3. 找到目标项目卡（可用 Agent Bar 的搜索框按项目名/repo 过滤）。
4. 一键创建：如果项目还没有环境，直接点卡片上的 **Create**，Web GUI 会用 `default`（或下一个可用名，如 `default-2`）加项目配置直接创建，无需填表。
5. 自定义创建：如果想指定 instance 名（例如 `debug`、`feature-x`），点项目卡右上角的 **New instance** 打开弹窗，template 已锁定为该项目，只需填 instance 名后提交。
6. 该实例会立即以「进行中」的一行出现在所属项目卡里，进度条与 stage 通过 SSE 实时更新；完成后自动替换为可连接的实例行。

> 若对应 provider 的 token 尚未保存，创建会被拒绝并提示先在顶部 Tokens 中保存。

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
| `writing ssh config` | client 写入 `~/.ssh/codespace/ssh_config` 托管块，并确保主 SSH config Include。 |
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

如果本地 alias 存在，优先使用 `ssh <alias>`；如果 alias 缺失，实例行仍会通过 Copy SSH 提供 raw SSH 命令。

每个 ready 实例行提供两个一等动作：**Open in Trae**（Trae Remote-SSH deep link，打开
`/workspace/<repo-name>`）和 **SSH**（复制 `ssh <alias>`，alias 缺失时复制 raw SSH 命令）。

## 9. 删除 codespace

在实例行右侧的 **⋯** 菜单中选择删除方式（会弹出确认框）：

- **Delete container**：删除容器，保留宿主机 workspace。
- **Delete workspace**：删除容器并删除宿主机 workspace 目录本身。

删除会尝试执行：

1. 吊销 Git provider deploy key；
2. 删除 agent 上的容器；
3. 删除本地 `~/.ssh/codespace/ssh_config` 托管块；
4. 删除本地登录 keypair。

如果对应 provider token 未保存，容器仍可删除，但 deploy key 吊销会被跳过并显示 warning。如果 deploy
key 吊销调用返回 403 等 provider 权限错误，Web GUI 也会继续删除容器并把吊销失败显示为 warning。

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
| `~/.ssh/codespace/ssh_config` | Web GUI 写入 codespace SSH Host 托管块。 |
| `~/.ssh/config` | Web GUI 确保包含 `Include ~/.ssh/codespace/ssh_config`。 |

SSH config 托管块示例：

```sshconfig
# ~/.ssh/config
Include ~/.ssh/codespace/ssh_config
```

```sshconfig
# ~/.ssh/codespace/ssh_config
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
- 检查 agent 是否按固定端口 `8001` 启动。

### 创建失败：token missing

- 确认已在 Web GUI 顶部 **Tokens** 弹窗中填写并保存目标 provider 的 token。
- token 只保存在 Python Web GUI service 进程内存中；如果刚重启过 service，需要重新保存。

### 创建失败：deploy key 注册失败

- 确认 token 对目标 repo 有 deploy key 管理权限。
- 如果使用 GitLab Fine-grained token，确认 token 的 project 范围包含目标 repo，且 Deploy Key
  权限包含 create/list/delete project deploy keys。
- 检查 repo 路径是否正确。
- 检查目标 repo 是否已经存在同 title 的异常 deploy key；必要时手动清理 `codespace-<id>` key。

### 创建失败：codespace already exists

这个错误来自 agent 的 Podman container label 去重检查，不是 workspace 目录已存在导致的。agent 会在
创建前查找同一个 `repo/template/instance` 是否已有容器；若找到，就拒绝创建并返回 existing id、容器名
和状态。

常见原因是之前创建流程在容器已创建后失败，留下 stale container。注意 agent 使用固定 podman socket：

```text
unix:///tmp/podmanxd.sock
```

请在 agent 所在机器上使用同一个 socket 排查：

```bash
podman --url unix:///tmp/podmanxd.sock ps -a \
  --filter label=codespace.id \
  --format '{{.ID}} {{.Names}} {{.Status}} {{.Labels}}'
```

确认 stale container 后可清理：

```bash
podman --url unix:///tmp/podmanxd.sock rm -f <container-name-or-id>
```

### 创建失败：clone 失败

- 通常说明 deploy key 尚未生效、repo 路径错误或 Git SSH host 不匹配。
- 检查 template 的 `provider`。
- GitLab provider 只支持官方 `gitlab.com` API 和默认 SSH host；如需自建 GitLab 实例，需要重新引入 API/SSH host 配置。

### `ssh <alias>` 连不上

- 检查 `~/.ssh/config` 是否包含 `Include ~/.ssh/codespace/ssh_config`。
- 检查 `~/.ssh/codespace/ssh_config` 中对应 Host 是否存在。
- 检查 agent profile 的 `ssh_host` 是否是本地可达的宿主机地址。
- 检查宿主机防火墙是否允许访问容器 sshd 随机端口。
- 尝试实例行上 SSH 按钮复制的 raw SSH 命令。

### 删除后 workspace 仍在

这是默认行为。只有选择 **Delete workspace** 才会删除 workspace 目录本身；普通 **Delete container**
会保留 workspace，便于之后用同一 repo/template/instance 复用数据。

## 13. 安全边界

- agent 不持有 GitHub / GitLab token。
- provider token 只保存在本地 Python Web GUI service 进程内存中，不写入 YAML 或浏览器持久化存储。
- Web GUI 进程可访问本地 SSH key、`~/.ssh/config` 和 `~/.ssh/codespace/ssh_config`，默认只监听 localhost。
- 不要把 Web GUI 暴露到不可信网络。
- deploy key 粒度限制在单个 repo。
- 删除 codespace 时由 client 负责吊销 deploy key。
