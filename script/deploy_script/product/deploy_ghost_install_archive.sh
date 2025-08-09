#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
ghost_archive_dir=$(jq -r '.ghost_archive_dir // empty' $config_dir)
echo "config.json中配置的 ghost 安装目录: $ghost_archive_dir"
ghost_archive_file=$(jq -r '.ghost_archive_file // empty' $config_dir)
echo "config.json中配置的 ghost 安装文件: $ghost_archive_file"

# 配置代理
proxy_dir=$SCRIPT_DIR/proxy.sh
source ${proxy_dir}
# 开启代理
open_shell_proxy
open_git_proxy
open_npm_proxy

# 给 ghost 安装目录赋予权限
sudo chmod o+rx $ghost_archive_dir
#获取ghost_archive_dir的父目录
ghost_archive_parent_dir=$(dirname "$ghost_archive_dir")
# 给 ghost 安装目录的父目录赋予权限  
sudo chmod o+rx $ghost_archive_parent_dir

# 运行安装脚本
echo -e "\n执行 ghost_install_archive.sh脚本"
ghost install --archive $ghost_archive_file --dir $ghost_archive_dir

