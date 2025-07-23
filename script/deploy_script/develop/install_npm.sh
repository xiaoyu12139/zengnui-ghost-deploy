#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
user_name=$(jq -r '.username // empty' $config_dir)
echo "config.json中配置的用户名: $user_name"
node_version=$(jq -r '.node_version // empty' $config_dir)
echo "config.json中Node.js 版本: $node_version"

# 安装配置
NVM_DIR=/home/${user_name}/.nvm
sudo -u ${user_name} bash <<EOF
# source不会新开一个shell，而是直接在当前shell中执行
source $proxy_dir
# 检查 Node.js 是否已安装
if command -v node &> /dev/null
then
    echo "Node.js 已安装，版本：$(node -v)"
else
    echo "Node.js 未安装"
    open_git_proxy
    open_shell_proxy
    # 显示正在安装的 Node.js 版本
    echo "正在安装 nvm ..."
    # 安装 nvm（Node Version Manager）
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
    # 安装 Node.js v18.x (Iron LTS) 版本
    echo "正在安装 Node.js v18.x (Iron LTS) ..."
    nvm install $node_version #v18.20.8
    # 使用 Node.js v18.x 版本
    nvm use $node_version
    # 验证安装的 Node.js 和 npm 版本
    echo "安装的 Node.js 版本是：\$(node -v)"
    echo "安装的 npm 版本是：\$(npm -v)"
    echo "Node.js "${node_version}" 和 npm 安装完成！"
fi
EOF
