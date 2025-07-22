#!/bin/bash

# 运行install目录下的安装脚本
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo -e "\n执行 product_env.sh脚本"
sudo bash "$SCRIPT_DIR/install_env_product.sh"
echo -e "\n执行 npm.sh脚本"
sudo bash "$SCRIPT_DIR/install_npm.sh"
echo -e "\n执行 yarn.sh脚本"
sudo bash "$SCRIPT_DIR/install_yarn.sh"
echo -e "\n执行 ghost-cli.sh脚本"
sudo bash "$SCRIPT_DIR/install_ghost-cli.sh"

echo "Ghost 生产环境部署完成。"
echo "执行 ghost start 启动 Ghost 生产环境。"
echo "请确保已安装 Node.js 和 ghost-cli。"
echo "如果未安装，请先运行相关安装脚本。"