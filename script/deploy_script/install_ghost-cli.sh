#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "ghost-cli.sh脚本所在目录: $SCRIPT_DIR"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
user_name=$(jq -r '.username // empty' $config_dir)
echo "config.json中配置的用户名: $user_name"
node_version=$(jq -r '.node_version // empty' $config_dir)
echo "config.json中Node.js 版本: $node_version"
# 确保前面安装的 npm 生效
NVM_DIR="/home/"${user_name}"/.nvm"
# 安装配置
sudo -u ${user_name} bash <<EOF
# 确保前面安装的 npm 生效
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use $node_version
# 开代理
source $proxy_dir
open_shell_proxy
open_git_proxy
open_npm_proxy
# 检查 Yarn 是否已安装
if command -v ghost &> /dev/null
then
    echo "ghost 已安装，版本：\$(ghost -v)"
else
    echo "ghost-cli 未安装"
    echo “安装 ghost-cli”
    npm install -g ghost-cli@latest
    echo "安装的 ghost 版本是：\$(ghost --version)"
    
fi
EOF