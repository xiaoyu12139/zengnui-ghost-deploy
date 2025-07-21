#!/bin/bash

# 配置基础变量
tmp_file_name=../proxy.sh
source $(pwd)/${tmp_file_name}
# 开启代理
open_shell_proxy
open_git_proxy
open_npm_proxy
# 安装配置
sudo npm install -g ghost-cli@latest