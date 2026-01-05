# Debian Init Container

这是一个基于 Debian 的容器镜像，预装了常用工具并配置了 SSH 服务。

## 包含的软件包

- sudo
- curl
- tmux
- systemd (init)
- git
- openssh-server

## 使用方法

### 构建镜像

```bash
docker build -t debian-init .
```

### 运行容器

由于容器使用 systemd，需要以特权模式运行：

```bash
docker run -d --privileged --name debian-init -p 2222:22 debian-init
```

### SSH 连接

默认 root 密码为 `root`：

```bash
ssh -p 2222 root@localhost
```

## GitHub Actions

本项目配置了 GitHub Actions workflow，会自动构建并推送镜像到 GitHub Container Registry (ghcr.io)。

镜像地址：`ghcr.io/<your-username>/<repository-name>`

