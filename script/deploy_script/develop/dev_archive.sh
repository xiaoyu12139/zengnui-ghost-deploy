#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
ghost_source_dir=$(jq -r '.ghost_source_dir // empty' $config_dir)
# 设置目标目录
repo_dir="Ghost"
ghost_dir=$ghost_source_dir/$repo_dir
source ${proxy_dir}
# 开启代理
open_shell_proxy
open_git_proxy
open_npm_proxy
# 确保 Ghost 目录存在
if [ ! -d "$ghost_dir" ]; then
    echo "Ghost 源代码目录 '$ghost_dir' 不存在，请检查配置。"
    exit 1
fi
cd $ghost_dir
# 赋予最高权限
sudo chmod -R 777 $ghost_dir
# 关闭所有正在运行的 Docker 容器
docker stop $(docker ps -q)
# 在Ghost的源码顶层目录中执行，安装nx到顶层目录
yarn add -W nx
yarn nx run ghost:build:assets
# 打包Ghost
yarn archive