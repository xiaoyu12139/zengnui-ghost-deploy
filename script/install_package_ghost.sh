#!/bin/bash
# ------------------------init------------------------------------------------------------------------------------------------------------------------------------------------
# 获取clash代理ip
# echo "请输入vmware虚拟机所在的主机的ip："
# read proxy_ip
# # 如果输入为空，则设置默认值
# if [ -z "$proxy_ip" ]; then
#     proxy_ip="192.168.124.3"  # 设置默认值
#     echo "未输入 IP，使用默认值：$proxy_ip"
# else
#     echo "你输入的 IP 为：$proxy_ip"
# fi
proxy_ip="192.168.124.3"
user_name=xiaoyu
tmp_file_name=.tmp_install_source_ghost_def.sh
# 将定义文件写到临时文件中，在后续安装中使用sudo指定用户安装时，使用source加载相关定义
echo '
proxy_ip="192.168.124.3"
user_name=xiaoyu
tmp_file_name=.tmp_install_source_ghost_def.sh
# 开启shell代理
open_shell_proxy() {
    echo "开启shell代理"
    export http_proxy="http://"'${proxy_ip}'":7890"
    export https_proxy="http://"'${proxy_ip}'":7890"
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
    git config --global http.proxy http://'${proxy_ip}':7890
    git config --global https.proxy http://'${proxy_ip}':7890
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
    npm config set proxy   "http://"'${proxy_ip}'":7890"
    npm config set https-proxy "http://"'${proxy_ip}'":7890"
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
}' > ${tmp_file_name}
# 加载配置文件
source $(pwd)/${tmp_file_name}
#-------------------------------------更新apt-----------------------------------------------------------------------------------------------------------------------------------
open_shell_proxy
echo "更新软件列表...."
sudo apt update
sudo apt upgrade -y
echo "软件列表更新完成。"

#-------------------------------------安装其他软件-----------------------------------------------------------------------------------------------------------------------------------
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
# packages=("gedit" "mysql-server" "vim" "curl" "git" "python3-venv" "python3-dev" "python3-setuptools")
packages=("gedit" "curl" "git" "net-tools" "build-essential" "openssh-server")
# 遍历软件包列表，检查并安装
for package in "${packages[@]}"; do
    install_if_missing $package
done
# 提示完成
echo "所有检查和安装任务完成！"

#-------------------------------------配置数据库-----------------------------------------------------------------------------------------------------------------------------------
package="mysql-server" 
if dpkg -l | grep -q "^ii \{1,\}$package" ; then
        echo "$package 已经安装。不对mysql进行相关配置"
else
    echo "$package 未安装，正在安装..."
    sudo apt-get install -y $package
    echo "$package 安装完成。"
    echo "开始配置mysql"
    sudo systemctl enable --now mysql
    sudo mysql <<EOF
    CREATE DATABASE IF NOT EXISTS ghostdb;
    CREATE USER IF NOT EXISTS 'ghostuser'@'localhost' IDENTIFIED BY 'your_strong_password';
    GRANT ALL PRIVILEGES ON ghostdb.* TO 'ghostuser'@'localhost';
    FLUSH PRIVILEGES;
EOF
    echo "mysql 配置完成"
fi

#-----------------------------------------------------nvm安装nodejs 20-------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------npm安装 ghost-cli-------------------------------------------------------------------------------------------------------------------
NVM_DIR=/home/xiaoyu/.nvm
node_version=v20.19.3
sudo -u ${user_name} bash <<EOF
source $(pwd)/${tmp_file_name}
# 检查 Node.js 是否已安装
if command -v node &> /dev/null
then
    echo "Node.js 已安装，版本：$(node -v)"
else
    echo "Node.js 未安装"
    open_git_proxy
    open_shell_proxy
    # 显示正在安装的 Node.js 版本
    echo "正在安装 nvm ..."
    # 安装 nvm（Node Version Manager）
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
    # 安装 Node.js v18.x (Iron LTS) 版本
    echo "正在安装 Node.js v18.x (Iron LTS) ..."
    nvm install $node_version #v18.20.8
    # 使用 Node.js v18.x 版本
    nvm use $node_version
    # 验证安装的 Node.js 和 npm 版本
    echo "安装的 Node.js 版本是：\$(node -v)"
    echo "安装的 npm 版本是：\$(npm -v)"
    echo "Node.js "${node_version}" 和 npm 安装完成！"
fi
# 检查ghost-cli是否安装
if command -v ghost &> /dev/null
then
    echo "ghost 已安装，版本：\$(ghost -v)"
else
    echo "ghost-cli 未安装，开始安装..."
    npm install -g ghost-cli@latest
    echo "安装的 ghost 版本是：\$(ghost -v)"
fi
# 检查 Yarn 是否已安装
if command -v yarn &> /dev/null
then
    echo "Yarn 已安装，版本：\$(yarn -v)"
else
    echo "Yarn 未安装"
    echo “安装yarn”
    npm install --global yarn
    echo "安装的 yarn 版本是：\$(yarn --version)"
    
fi
EOF
echo "环境安装完成，重启终端使环境生效"
#-----------------------------------------------------从pack安装------------------------------------------------------------------------------------------------------------------
# ghost install --archive /home/xiaoyu/桌面/tmp/ghost-custom.tar.gz --dir ~/ghost-custom