#!/bin/bash

# 配置基础变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json
ghost_archive_dir=$(jq -r '.ghost_archive_dir // empty' $config_dir)
echo "config.json中配置的 ghost 安装目录: $ghost_archive_dir"
ghost_archive_file=$(jq -r '.ghost_archive_file // empty' $config_dir)
echo "config.json中配置的 ghost 安装文件: $ghost_archive_file"

# 给 ghost 安装目录赋予权限
sudo chmod o+rx $ghost_archive_dir

# 运行安装脚本
echo -e "\n执行 ghost_install_archive.sh脚本"
ghost install --archive $ghost_archive_file --dir $ghost_archive_dir

