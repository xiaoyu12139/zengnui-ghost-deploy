#!/bin/bash

# 配置基础变量
tmp_file_name=./proxy.sh
source $(pwd)/${tmp_file_name}
# 开启代理
open_shell_proxy
open_git_proxy
open_npm_proxy
# 配置系统最大监控文件数
sudo sysctl fs.inotify.max_user_watches=524288

# 启动ghost开发环境
yarn dev