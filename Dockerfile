FROM debian:latest

# 设置环境变量，避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装必要的软件包
RUN apt-get update && \
    apt-get install -y \
    sudo \
    curl \
    tmux \
    systemd \
    git \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

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

