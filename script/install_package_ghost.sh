#!/bin/bash
# ------------------------init------------------------------------------------------------------------------------------------------------------------------------------------
# 获取clash代理ip
echo "请输入vmware虚拟机所在的主机的ip："
read proxy_ip
# 如果输入为空，则设置默认值
if [ -z "$proxy_ip" ]; then
    proxy_ip="192.168.124.3"  # 设置默认值
    echo "未输入 IP，使用默认值：$proxy_ip"
else
    echo "你输入的 IP 为：$proxy_ip"
fi

# 开启shell代理
open_shell_proxy() {
    echo "开启shell代理"
    export http_proxy="http://"$proxy_ip":7890"
    export https_proxy="http://"$proxy_ip":7890"
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
    git config --global http.proxy http://$proxy_ip:7890
    git config --global https.proxy http://$proxy_ip:7890
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
    npm config set proxy   "http://"$proxy_ip":7890"
    npm config set https-proxy "http://"$proxy_ip":7890"
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

#-------------------------------------安装其他软件-----------------------------------------------------------------------------------------------------------------------------------
# 函数：检查并安装软件包
install_if_missing() {
    package=$1
    if dpkg -l | grep -q "^ii  $package "; then
        echo "$package 已经安装。"
    else
        echo "$package 未安装，正在安装..."
        sudo apt-get install -y $package
        echo "$package 安装完成。"
    fi
}
# 软件包列表
# packages=("gedit" "mysql-server" "vim" "curl" "git" "python3-venv" "python3-dev" "python3-setuptools")
packages=("gedit" "curl" "git" "net-tools" "mysql-server")
# 遍历软件包列表，检查并安装
for package in "${packages[@]}"; do
    install_if_missing $package
done
# 提示完成
echo "所有检查和安装任务完成！"

#-------------------------------------配置数据库-----------------------------------------------------------------------------------------------------------------------------------
sudo systemctl enable --now mysql
sudo mysql -uroot -p     # 登录后：
CREATE DATABASE ghostdb;
CREATE USER 'ghostuser'@'localhost' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON ghostdb.* TO 'ghostuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;

#-----------------------------------------------------nvm安装nodejs 20-------------------------------------------------------------------------------------------------------------------
open_shell_proxy
# 显示正在安装的 Node.js 版本
echo "正在安装 nvm ..."
# 安装 nvm（Node Version Manager）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# 让 nvm 脚本生效（如果你是当前会话运行）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# 安装 Node.js v20.x (Iron LTS) 版本
echo "正在安装 Node.js v20.x (Iron LTS) ..."
nvm install 20
# 使用 Node.js v20.x 版本
nvm use 20
# 验证安装的 Node.js 和 npm 版本
echo "安装的 Node.js 版本是："
node -v
echo "安装的 npm 版本是："
npm -v
# 更新 npm 到最新版本
echo "正在更新 npm 到最新版本 ..."
npm install -g npm@latest
# 显示更新后的 npm 版本
echo "更新后的 npm 版本是："
npm -v
echo "Node.js v20.x 和 npm 安装完成！"

#-----------------------------------------------------ghost-cli------------------------------------------------------------------------------------------------------------------
# 创建一个新的全局目录
mkdir ~/.npm-global
# 告诉 npm 以后把全局包都装到这里
npm config set prefix '~/.npm-global'
# 把这个目录加到你的 PATH（在 ~/.profile 或 ~/.bashrc 里加入以下行）
export PATH="$HOME/.npm-global/bin:$PATH"
# 重新加载配置
source ~/.profile
# 现在就可以不带 sudo 安装全局包了
npm install -g ghost-cli


#-----------------------------------------------------从pack安装------------------------------------------------------------------------------------------------------------------
ghost install --archive /home/xiaoyu/桌面/tmp/ghost-custom.tar.gz --dir ~/ghost-custom