#!/bin/bash

# 运行install目录下的安装脚本
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo -e "\n执行 install_dev_env.sh脚本"
sudo bash "$SCRIPT_DIR/install_env_dev.sh"

echo -e "\n执行 install_npm.sh脚本"
sudo bash "$SCRIPT_DIR/install_npm.sh"

echo -e "\n执行 install_yarn.sh脚本"
sudo bash "$SCRIPT_DIR/install_yarn.sh"

echo -e "\n执行 install_docker.sh脚本"
sudo bash "$SCRIPT_DIR/install_docker.sh"

echo "Ghost开发环境部署完成。"
echo "执行 yarn setup 初始 ghost 开发环境。"
echo "请确保已安装 Node.js 和 Yarn。"
echo "如果未安装，请先运行相关安装脚本。"