#!/bin/bash

# 运行install目录下的安装脚本
sudo bash ./intatll/dev_env.sh
sudo bash ./install/npm.sh
sudo bash ./install/yarn.sh
sudo bash ./install/docker.sh

echo "Ghost开发环境部署完成。"
echo "执行 yarn setup 初始 ghost 开发环境。"
echo "请确保已安装 Node.js 和 Yarn。"
echo "如果未安装，请先运行相关安装脚本。"