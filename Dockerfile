FROM debian:latest

# 设置环境变量，避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装基础与开发工具
RUN apt-get update && \
    apt-get install -y \
    sudo \
    curl \
    wget \
    tmux \
    systemd \
    git \
    openssh-server \
    openssh-client \
    locales \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    python3 \
    python3-pip \
    python3-venv \
    jq \
    ripgrep \
    fd-find \
    tree \
    vim \
    nano \
    less \
    unzip \
    zip \
    procps \
    iproute2 \
    dnsutils \
    file \
    && sed -i 's/# \(zh_CN.UTF-8\)/\1/' /etc/locale.gen \
    && sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# nvm + 最新 Node.js
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && nvm alias default node \
    && NODE_BIN="$(dirname "$(command -v node)")" \
    && ln -sf "$NODE_BIN/node" /usr/local/bin/node \
    && ln -sf "$NODE_BIN/npm" /usr/local/bin/npm \
    && ln -sf "$NODE_BIN/npx" /usr/local/bin/npx

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

# 配置 SSH 服务
RUN mkdir -p /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 启用 SSH 服务（创建 systemd 符号链接）
RUN mkdir -p /etc/systemd/system/multi-user.target.wants && \
    mkdir -p /etc/systemd/system/sockets.target.wants && \
    if [ -f /lib/systemd/system/ssh.service ]; then \
        ln -sf /lib/systemd/system/ssh.service /etc/systemd/system/multi-user.target.wants/ssh.service; \
    elif [ -f /usr/lib/systemd/system/ssh.service ]; then \
        ln -sf /usr/lib/systemd/system/ssh.service /etc/systemd/system/multi-user.target.wants/ssh.service; \
    fi && \
    if [ -f /lib/systemd/system/ssh.socket ]; then \
        ln -sf /lib/systemd/system/ssh.socket /etc/systemd/system/sockets.target.wants/ssh.socket; \
    elif [ -f /usr/lib/systemd/system/ssh.socket ]; then \
        ln -sf /usr/lib/systemd/system/ssh.socket /etc/systemd/system/sockets.target.wants/ssh.socket; \
    fi

# 配置 root 用户的 SSH 公钥
RUN mkdir -p /root/.ssh && \
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBogggI88EwN5reEoRA41lp+72gJs7R3FdgdbVLdaeGt' > /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys

# 创建 systemd 目录
RUN mkdir -p /run/systemd/system

# 设置默认命令为 /usr/sbin/init
CMD ["/usr/sbin/init"]

