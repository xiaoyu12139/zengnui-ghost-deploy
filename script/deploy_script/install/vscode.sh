#!/bin/bash

# 检查是否安装了 Visual Studio Code
if command -v code &>/dev/null; then
    echo "Visual Studio Code 已经安装。"
else
    echo "Visual Studio Code 未安装，正在安装..."

    # 下载最新版本的 Visual Studio Code .deb 包
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb

    # 安装 VSCode
    sudo dpkg -i vscode.deb

    # 解决依赖问题（如果有）
    sudo apt-get install -f

    # 启动 VSCode
    echo "Visual Studio Code 安装完成。"
    code
fi