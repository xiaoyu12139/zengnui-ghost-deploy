#!/bin/bash

# 运行install目录下的安装脚本
sudo bash ./intatll/product_env.sh
sudo bash ./install/npm.sh
sudo bash ./install/yarn.sh
sudo bash ./install/ghost-cli.sh

echo "Ghost 生产环境部署完成。"
echo "执行 ghost start 启动 Ghost 生产环境。"
echo "请确保已安装 Node.js 和 ghost-cli。"
echo "如果未安装，请先运行相关安装脚本。"