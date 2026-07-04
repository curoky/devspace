# Codespace 使用说明

本文档面向**使用者**，讲解如何部署 agent、用 client 创建/管理远程开发容器。
架构与设计细节见 [`DESIGN.md`](./DESIGN.md)。

## 1. 组件与前置条件

| 组件 | 运行位置 | 前置条件 |
| --- | --- | --- |
| **agent** | Linux 宿主机 | rootful Podman（`/run/podman/podman.sock` 可用）、可被 client 访问的网络端口 |
| **client** | macOS / 本地 | Python 3.13+、`uv`、`ssh` 与 `ssh-keygen` |
| **dev 镜像** | 由 agent 拉起 | 满足 `DESIGN.md §3` 契约（sshd 支持 `SSHD_PORT`、非 root 用户、`/workspace` 可写、含 git/ssh） |

准备一枚 **GitHub token**（对目标 repo 有 deploy key 管理权限）。token **只用在 client 本地**
与 GitHub 交互，**从不发给 agent、不经网络**（见 §7）。

## 2. 构建镜像

```bash
# 参考开发镜像（满足 §3 契约）
podman build -t codespace/dev:latest codespace/image

# agent 自身镜像（从仓库根构建，需 pyproject.toml/uv.lock 在上下文）
podman build -t codespace/agent:latest -f codespace/agent/Dockerfile .
```

> CI 也会把 agent 镜像推到 `ghcr.io/curoky/devspace:codespace-agent`，可直接
> `podman pull ghcr.io/curoky/devspace:codespace-agent` 使用（配 `AGENT_IMAGE` 环境变量）。

## 3. 启动 agent（Linux 宿主机）

agent 无状态、不接触 GitHub，只挂载 podman socket。配置仅通过**命令行参数**传入，两个
参数全部必填：`--workspace-root-host`、`--podman-uri`。

### 方式一：参考脚本

```bash
ADVERTISE_HOST=10.0.0.5 \
WORKSPACE_ROOT_HOST=/var/lib/codespace-workspaces \
bash codespace/agent/run-agent.sh
```

### 方式二：直接 podman run

```bash
podman run --rm --name codespace-agent \
  --network host \
  -v /run/podman/podman.sock:/run/podman/podman.sock \
  codespace/agent:latest \
  serve \
  --workspace-root-host /var/lib/codespace-workspaces \
  --podman-uri unix:///run/podman/podman.sock \
  --host 0.0.0.0 --port 8001
```

| CLI 参数 | 必填 | 说明 |
| --- | --- | --- |
| `--workspace-root-host` | 是 | 工作区 bind mount 的宿主机路径前缀 |
| `--podman-uri` | 是 | podman service socket URI |
| `--host` / `--port` | 否 | HTTP 绑定地址/端口（默认 `0.0.0.0:8001`） |

配置非法（缺必填项等）时 agent 启动即报错退出。

验证：`curl http://<host>:8001/codespaces` 返回 `[]`。

## 4. 使用 client（本地）

命令通过 `uv run python -m codespace.client <子命令>` 调用。
`--token` 可用环境变量 `GITHUB_TOKEN` 提供。

### 创建

```bash
export GITHUB_TOKEN=ghp_xxx
uv run python -m codespace.client create \
  --repo owner/name \
  --agent http://0.0.0.0:8001 \
  --ssh-host 10.0.0.5 \
  --image ghcr.io/curoky/devspace:codespace-image-debian12 \
  --workspace default \
  --alias my-cs
```

- `--repo`（必填）：目标 GitHub 仓库 `owner/name`。
- `--agent`（可选，默认 `http://0.0.0.0:8001`）：agent 地址。
- `--ssh-host`（必填）：client 可达的宿主机地址，用于 ssh 到 dev 容器（写入 ssh config 的
  `HostName`）；常与 `--agent` 的 host 相同。
- `--token`（必填，或 `GITHUB_TOKEN`）：GitHub token，仅本地使用。
- `--image`（可选，默认 `ghcr.io/curoky/devspace:codespace-image-debian12`）：满足 §3 契约的
  dev 镜像，由 client 指定。
- `--user`（可选，默认 `dev`）：容器内登录用户。
- `--workspace`（可选，默认 `default`）：同一 repo 下的独立持久化工作区。
- `--alias`（可选）：SSH 别名，默认 `<repo 名>-<workspace>`。

此外每个 codespace 会自动获得一组**固定额外仓库**的只读拉取权限（见「额外只读仓库」）。

流程：
1. 本地生成登录 keypair `~/.ssh/codespace/<alias>{,.pub}`（已存在则复用）；
2. `POST` 到 agent（**不含 token**），agent 建容器、注入 deploy 私钥（主 repo + 额外 repo）、
   返回各 repo 的 deploy 公钥；
3. client 用 token 把每个公钥注册为对应 repo 的 GitHub deploy key（`codespace-<id>`）；任一
   注册失败会吊销已注册的 key、请求 agent 删除容器（回滚），避免孤儿；
4. `~/.ssh/config` 写入托管块（含 `id` 与全部 `repos`）；
5. 提示 `ssh <alias>` 即可登录。

### 登录

```bash
ssh my-cs
```

进入容器后可直接对目标 repo 操作（deploy key 已注入且仅授权该仓库）：

```bash
git clone git@github.com:owner/name.git   # 成功且可 push
# clone 其它仓库会因无权限失败——这是预期的隔离保证
```

### 额外只读仓库

每个 codespace 会自动获得一组**固定额外仓库**的**只读**拉取权限（如共享配置
`curoky/ai-coding-config`）。该列表硬编码在 client 的 `EXTRA_REPOS` 常量中，无需额外配置。

创建后进入容器，额外仓库可用**原始 URL 透明拉取**（内部经 host alias + git `insteadOf`
重写到该 repo 专属只读 key）：

```bash
git clone git@github.com:curoky/ai-coding-config.git   # 只读，可 pull，不可 push
```

> 每个额外仓库对应一把独立的 `read_only` deploy key，删除 codespace 时一并吊销。

### 列表

```bash
uv run python -m codespace.client list --agent http://10.0.0.5:8001 --ssh-host 10.0.0.5
```

> `--ssh-host` 可选，仅用于填充 HOST 列展示（省略则显示 `-`）；agent 只返回端口。

### 删除

```bash
uv run python -m codespace.client delete --alias my-cs
# 附带 --purge 时连同宿主机工作区目录一起删除（彻底清数据）
```

删除会：**client 用 token 吊销 GitHub deploy key**（按 title `codespace-<id>` 反查）→
请求 agent 移除容器 → 清理本地 `~/.ssh/config` 托管块与登录 key。
**默认保留工作区目录**，重建同名 `--workspace` 即复用其中数据。

> `delete` 需要 `--token`（或 `GITHUB_TOKEN`）用于吊销 deploy key；`id` 与 `repo` 自动从
> ssh config 托管块读取，无需手填（缺失时可用 `--id` / `--repo` 覆盖）。

## 5. 工作区持久化

每个 `(repo, workspace)` 对应宿主机一个固定目录
`<workspace_root_host>/codespace-<repo-slug>-<workspace>-<hash8>`，以 bind mount 挂到
容器 `/workspace`。删除容器（不 `--purge`）保留该目录，重建复用。
同一 repo 用不同 `--workspace` 可并行开多个互不干扰的 codespace。

## 6. 常见问题

- **`curl` 返回空但 create 失败**：确认 agent 能连 podman socket，且 `--image` 指定的镜像
  已构建/可拉取。
- **`ssh <alias>` 连不上**：确认 `--ssh-host` 是 client 可达的宿主机地址，且宿主机
  防火墙放行了开发容器在 host network 下监听的随机 sshd 端口。
- **`git clone` 目标 repo 失败**：确认 token 有 deploy key 权限、repo 名正确；deploy key
  默认可读写。
- **create 报注册 deploy key 失败**：检查 token 权限；client 已自动回滚容器，修正 token 后重试。

## 7. 安全边界（务必知悉）

本方案假定 **client 与 Linux 宿主机均为不可信环境**：agent **不做鉴权、明文 HTTP 传输**，
但 **GitHub token 只在 client 本地使用、从不经网络到达 agent**——agent 不持任何 GitHub 凭据。
rootful podman socket 等价宿主机 root，故 deploy **私钥**注入容器后，宿主机 root 在容器存活期
仍可读取；影响面被 deploy key 限制在**单个 repo**，删除时由 client 即时吊销。
完整威胁模型见 `DESIGN.md §11`。
