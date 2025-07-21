#!/bin/bash

# 配置基础变量
tmp_file_name=../proxy.sh
source $(pwd)/${tmp_file_name}

# 克隆代码
open_git_proxy
open_shell_proxy
# 设置目标目录
repo_dir="Ghost"
# 检查目标目录是否已经存在
if [ -d "$repo_dir" ]; then
    echo "目录 '$repo_dir' 已经存在，跳过克隆。"
    cd "$repo_dir"  # 如果已存在，进入该目录
else
    echo "目录 '$repo_dir' 不存在，正在克隆仓库..."
    # git clone --recurse-submodules https://github.com/TryGhost/Ghost.git && cd Ghost
    # git remote rename origin upstream
    # git remote add origin https://github.com/xiaoyu12139/Ghost.git
    git clone --recurse-submodules https://github.com/xiaoyu12139/Ghost.git && cd Ghost
    git config --global --add safe.directory ${pwd}
fi