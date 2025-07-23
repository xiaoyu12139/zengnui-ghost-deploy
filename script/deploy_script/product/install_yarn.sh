#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
user_name=$(jq -r '.username // empty' $config_dir)
node_version=$(jq -r '.node_version // empty' $config_dir)
NVM_DIR="/home/"$user_name"/.nvm"

# 安装配置
sudo -u ${user_name} bash <<EOF
# 确保前面安装的 npm 生效
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use $node_version
# 检查 Yarn 是否已安装
if command -v yarn &> /dev/null
then
    echo "Yarn 已安装，版本：\$(yarn -v)"
else
    echo "Yarn 未安装"
    echo “安装yarn”
    npm install --global yarn
    echo "安装的 yarn 版本是：\$(yarn --version)"
    
fi
EOF