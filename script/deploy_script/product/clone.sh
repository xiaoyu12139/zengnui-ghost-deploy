#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
ghost_source_dir=$(jq -r '.ghost_source_dir // empty' $config_dir)
# 设置目标目录
repo_dir="Ghost"
ghost_dir=$ghost_source_dir/$repo_dir

source ${proxy_dir}

# 克隆代码
open_git_proxy
open_shell_proxy
# 设置目标目录
repo_dir="Ghost"
# 检查目标目录是否已经存在
if [ -d "$ghost_dir" ]; then
    echo "目录 '$ghost_dir' 已经存在，跳过克隆。"
    cd "$ghost_dir"  # 如果已存在，进入该目录
else
    echo "目录 '$ghost_dir' 不存在，正在克隆仓库..."
    # git clone --recurse-submodules https://github.com/TryGhost/Ghost.git && cd Ghost
    # git remote rename origin upstream
    # git remote add origin https://github.com/xiaoyu12139/Ghost.git
    cd $ghost_source_dir
    git clone --recurse-submodules https://github.com/xiaoyu12139/Ghost.git && cd Ghost
    git config --global --add safe.directory $ghost_dir
fi