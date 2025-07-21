#!/bin/bash

# 配置基础变量
tmp_file_name=../proxy.sh
user_name=$(jq -r '.username // empty' ../config.json)
# 安装配置
sudo -u ${user_name} bash <<EOF
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