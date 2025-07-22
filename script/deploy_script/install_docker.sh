#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR./proxy.sh
config_dir=$SCRIPT_DIR/config.json
user_name=$(jq -r '.username // empty' $config_dir)
# 安装配置
source ${proxy_dir}
open_shell_proxy
# 检查 Docker 是否安装
if command -v docker &>/dev/null; then
    echo "Docker 已安装，版本信息："
    docker --version
else
    echo "Docker 未安装。"
    # 更新 apt 包索引
    echo "正在更新 apt 包索引..."
    sudo apt-get update
    # 安装 Docker 安装依赖项
    echo "安装 Docker 安装依赖项..."
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    # 下载并添加 Docker 官方 GPG 密钥到 trusted.gpg.d 目录（替代 apt-key）
    echo "添加 Docker 官方 GPG 密钥..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
    # 获取 Ubuntu 版本代号，手动设置代号为 'jammy'（对于 Ubuntu 24.04 LTS）
    lsb_v=focal
    # lsb_v=jammy
    # 设置 Docker 稳定版仓库
    echo "正在添加 Docker 稳定版仓库..."
    # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $lsb_v stable" # 正常设置，需要输入ENTER
    echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $lsb_v stable"
    # 更新 apt 包索引
    echo "正在更新 apt 包索引..."
    sudo apt-get update
    # 检查 unattended-upgr 是否在运行
    if ps aux | grep '[u]nattended-upgr' > /dev/null
    then
        echo "unattended-upgr 进程正在运行，正在停止..."
        
        # 获取进程 ID (PID) 并杀死进程
        PID=$(ps aux | grep '[u]nattended-upgr' | awk '{print $2}')
        sudo kill -9 $PID
        echo "unattended-upgr 进程已停止"
    else
        echo "unattended-upgr 进程未运行"
    fi
    # 安装 Docker
    echo "正在安装 Docker..."
    sudo apt-get install -y docker-ce
    # 启动 Docker 并设置开机启动
    echo "正在启动 Docker 并设置开机自启..."
    sudo systemctl start docker
    sudo systemctl enable docker
    # 验证 Docker 安装
    echo "Docker 安装完成，当前版本是：$(docker --version)"
    #配置docker镜像
    MIRROR_URL=$docker_mirror_url
    # Docker 配置文件路径
    DAEMON_JSON="/etc/docker/daemon.json"
    BACKUP_JSON="/etc/docker/daemon.json.bak.$(date +%F_%T)"
    # 1. 备份现有配置
    if [ -f "$DAEMON_JSON" ]; then
        echo "检测到 /etc/docker/daemon.json，正在备份到 $BACKUP_JSON"
        sudo cp "$DAEMON_JSON" "$BACKUP_JSON"
    else
        echo "没有找到 /etc/docker/daemon.json，稍后会新建该文件"
    fi
    # 2. 生成或更新 daemon.json
    echo "正在写入镜像加速配置…"
    tee "$DAEMON_JSON" > /dev/null <<EOF
    {
    "registry-mirrors": [
        "$MIRROR_URL"
    ]
    }
EOF
#这里需要顶格写，这一行只能有EOF
    # 将当前用户加入 docker 组
    sudo usermod -aG docker ${user_name}
    # 立即让当前 shell 生效（不需重登）
    newgrp docker

    # # 3. 重载并重启 Docker
    echo "重载 Docker 配置并重启服务…"
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    # 4. 验证
    echo "验证镜像加速配置："
    docker info | grep -A3 "Registry Mirrors"
    echo "配置完成！"
fi