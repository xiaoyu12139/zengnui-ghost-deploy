#!/bin/bash

# 函数：检查并安装软件包
install_if_missing() {
    package=$1
    if dpkg -l | grep -q "^ii \{1,\}$package" ; then
        echo "$package 已经安装。"
    else
        echo "$package 未安装，正在安装..."
        sudo apt-get install -y $package
        echo "$package 安装完成。"
    fi
}
# 软件包列表
packages=("gedit" "mysql-server" "vim" "curl" "git" "python3-venv" "python3-dev" "python3-setuptools")
# 遍历软件包列表，检查并安装
for package in "${packages[@]}"; do
    install_if_missing $package
done
# 提示完成
echo "所有检查和安装任务完成！"