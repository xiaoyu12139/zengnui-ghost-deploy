#!/bin/bash

# 配置proxy代理的脚本

# 读取配置文件中的proxy_ip
# 如果proxy_ip不存在，则输出提示信息并退出程序
# jq 是一个用于在命令行下处理和解析 JSON 数据的工具
# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
proxy_ip=$(jq -r '.proxy_ip // empty' $SCRIPT_DIR/config.json)
if [ -z "$proxy_ip" ]; then
  echo "proxy_ip不存在，程序结束"
  exit 1
fi

open_shell_proxy() {
    echo "开启shell代理"
    export http_proxy="http://"${proxy_ip}":7890"
    export https_proxy="http://"${proxy_ip}":7890"
    echo "shell代理已设置为："
    echo $http_proxy
    echo $https_proxy
}
# 关闭shell代理
close_shell_proxy() {
    echo "关闭shell代理"
    export http_proxy=""
    export https_proxy=""
    echo "shell代理已设置为："
    echo $http_proxy
    echo $https_proxy
}
# 开启git代理
open_git_proxy(){
    echo “开启git代理”
    git config --global http.proxy http://${proxy_ip}:7890
    git config --global https.proxy http://${proxy_ip}:7890
    echo "git代理已设置为："
    git config --global --get http.proxy
    git config --global --get https.proxy
}
# 关闭git代理
close_git_proxy(){
    echo “关闭git代理”
    git config --global http.proxy “”
    git config --global https.proxy “”
    echo "git代理已设置为："
    git config --global --get http.proxy
    git config --global --get https.proxy
}
# 开启npm代理
open_npm_proxy(){
    echo “开启npm代理”
    npm config set proxy   "http://"${proxy_ip}":7890"
    npm config set https-proxy "http://"${proxy_ip}":7890"
    echo "npm代理已设置为："
    npm config get proxy
    npm config get https-proxy
}
# 关闭npm代理
close_npm_proxy(){
    echo “关闭npm代理”
    npm config set proxy   ""
    npm config set https-proxy ""
    echo "npm代理已设置为："
    npm config get proxy
    npm config get https-proxy
}

case "$1" in
    open)
        echo "执行打开git,npm,shell代理的操作"
        # 在这里添加打开代理的命令
        open_shell_proxy
        open_git_proxy
        open_npm_proxy
        echo "代理已开启"
        ;;
    close)
        echo "执行关闭代理的操作"
        # 在这里添加关闭代理的命令
        close_shell_proxy
        close_git_proxy
        close_npm_proxy
        echo "代理已关闭"
        ;;
    *)
        echo "用法: $0 {open|close}"
        echo "当前没有输入参数，视为导入关闭开启代理到当前bash环境"
        ;;
esac
