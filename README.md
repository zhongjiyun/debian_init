# Debian Init Container

这是一个基于 Debian 的容器镜像，预装了常用工具并配置了 SSH 服务。

## 包含的软件包

### 基础环境

- sudo, curl, wget, tmux, systemd (init)
- git, openssh-server / openssh-client
- locales（中文 locale，`zh_CN.UTF-8`）
- ca-certificates

### 语言与构建

- build-essential, pkg-config, libssl-dev
- Python 3（pip、venv）
- nvm + 最新 Node.js（npm、npx，可通过 `nvm install` 切换版本）

### 日常 CLI 工具

- jq, ripgrep (`rg`), fd-find (`fd`), tree
- vim, nano, less, file
- unzip, zip
- procps（`ps` / `top`）, iproute2（`ip`）, dnsutils（`dig`）

默认语言环境为 `zh_CN.UTF-8`，SSH 登录后终端可正常显示中文。

## 使用方法

### 运行容器

由于容器使用 systemd，需要以特权模式运行。在项目目录下执行（会将当前目录挂载到容器内 `/app`）：

```bash
docker rm -f code; docker run -itd --name=code --pull=always -p 30002:22 --privileged -v .:/app ghcr.io/zhongjiyun/debian_init /usr/sbin/init
```

### SSH 连接

默认 root 密码为 `root`：

```bash
ssh -p 30002 root@localhost
```

### 本地构建（可选）

```bash
docker build -t debian-init .
```

## GitHub Actions

本项目配置了 GitHub Actions workflow，会自动构建并推送镜像到 GitHub Container Registry (ghcr.io)。

镜像地址：`ghcr.io/zhongjiyun/debian_init`

