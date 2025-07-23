#!/bin/bash

# 备份原有的源列表
echo "正在备份原有的源列表..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入新的源列表
echo "正在更改源列表..."
sudo tee /etc/apt/sources.list > /dev/null <<EOF
# 阿里云
Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble noble-updates noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
