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
# 配置系统最大监控文件数
sudo sysctl fs.inotify.max_user_watches=524288
# 确保 Ghost 目录存在
if [ ! -d "$ghost_dir" ]; then
    echo "Ghost 源代码目录 '$ghost_dir' 不存在，请检查配置。"
    exit 1
fi
# 赋予最高权限
sudo chmod -R 777 $ghost_dir
cd $ghost_dir
# 启动ghost开发环境
yarn dev