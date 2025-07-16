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
# ------------------------安装vscode------------------------------------------------------------------------------------------------------------------------------------------------
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
# -------------------------------------安装其他软件-----------------------------------------------------------------------------------------------------------------------------------
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
packages=("gedit" "curl" "git" "openssh-server" "python3" "python3-dev" "python3-setuptools" "python3-venv"  "net-tools" "build-essential")
# packages=("gedit" "curl" "git" "net-tools")
# 遍历软件包列表，检查并安装
for package in "${packages[@]}"; do
    install_if_missing $package
done
# 提示完成
echo "所有检查和安装任务完成！"
#-----------------------------------------------------nvm安装nodejs 18-------------------------------------------------------------------------------------------------------------------
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
# EOF
# #----------------------------------安装yarn--------------------------------------------------------------------------------------------------------------------------------------
# sudo -u ${user_name} bash <<EOF
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
#---------------------------------------------安装docker---------------------------------------------------------------------------------------------------------------------------
open_shell_proxy
# 检查 Docker 是否安装
if command -v docker &>/dev/null; then
    echo "Docker 已安装，版本信息："
    docker --version
else
    echo "Docker 未安装。"
    # 更新 apt 包索引
    echo "正在更新 apt 包索引..."
    sudo apt-get update
    # 安装 Docker 安装依赖项
    echo "安装 Docker 安装依赖项..."
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    # 下载并添加 Docker 官方 GPG 密钥到 trusted.gpg.d 目录（替代 apt-key）
    echo "添加 Docker 官方 GPG 密钥..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
    # 获取 Ubuntu 版本代号，手动设置代号为 'jammy'（对于 Ubuntu 24.04 LTS）
    lsb_v=focal
    # lsb_v=jammy
    # 设置 Docker 稳定版仓库
    echo "正在添加 Docker 稳定版仓库..."
    # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $lsb_v stable" # 正常设置，需要输入ENTER
    echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $lsb_v stable"
    # 更新 apt 包索引
    echo "正在更新 apt 包索引..."
    sudo apt-get update
    # 检查 unattended-upgr 是否在运行
    if ps aux | grep '[u]nattended-upgr' > /dev/null
    then
        echo "unattended-upgr 进程正在运行，正在停止..."
        
        # 获取进程 ID (PID) 并杀死进程
        PID=$(ps aux | grep '[u]nattended-upgr' | awk '{print $2}')
        sudo kill -9 $PID
        echo "unattended-upgr 进程已停止"
    else
        echo "unattended-upgr 进程未运行"
    fi
    # 安装 Docker
    echo "正在安装 Docker..."
    sudo apt-get install -y docker-ce
    # 启动 Docker 并设置开机启动
    echo "正在启动 Docker 并设置开机自启..."
    sudo systemctl start docker
    sudo systemctl enable docker
    # 验证 Docker 安装
    echo "Docker 安装完成，当前版本是：$(docker --version)"
    #配置docker镜像
    MIRROR_URL="https://docker-0.unsee.tech"
    # Docker 配置文件路径
    DAEMON_JSON="/etc/docker/daemon.json"
    BACKUP_JSON="/etc/docker/daemon.json.bak.$(date +%F_%T)"
    # 1. 备份现有配置
    if [ -f "$DAEMON_JSON" ]; then
        echo "检测到 /etc/docker/daemon.json，正在备份到 $BACKUP_JSON"
        sudo cp "$DAEMON_JSON" "$BACKUP_JSON"
    else
        echo "没有找到 /etc/docker/daemon.json，稍后会新建该文件"
    fi
    # 2. 生成或更新 daemon.json
    echo "正在写入镜像加速配置…"
    tee "$DAEMON_JSON" > /dev/null <<EOF
    {
    "registry-mirrors": [
        "$MIRROR_URL"
    ]
    }
EOF
#这里需要顶格写，这一行只能有EOF
    # 将当前用户加入 docker 组
    sudo usermod -aG docker ${user_name}
    # 立即让当前 shell 生效（不需重登）
    newgrp docker

    # # 3. 重载并重启 Docker
    echo "重载 Docker 配置并重启服务…"
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    # 4. 验证
    echo "验证镜像加速配置："
    docker info | grep -A3 "Registry Mirrors"
    echo "配置完成！"
fi

#------------------------------------------------------------克隆代码------------------------------------------------------------------------------------------------------------
open_git_proxy
open_shell_proxy
# 设置目标目录
repo_dir="Ghost"
# 检查目标目录是否已经存在
if [ -d "$repo_dir" ]; then
    echo "目录 '$repo_dir' 已经存在，跳过克隆。"
    cd "$repo_dir"  # 如果已存在，进入该目录
else
    echo "目录 '$repo_dir' 不存在，正在克隆仓库..."
    # git clone --recurse-submodules https://github.com/TryGhost/Ghost.git && cd Ghost
    # git remote rename origin upstream
    # git remote add origin https://github.com/xiaoyu12139/Ghost.git
    git clone --recurse-submodules https://github.com/xiaoyu12139/Ghost.git && cd Ghost
    git config --global --add safe.directory ${pwd}
fi
close_shell_proxy
# git config --global --add safe.directory /home/xiaoyu/ghost/Ghost
# sudo chmod -R u+w /home/xiaoyu/ghost/Ghost/node_modules
# sudo chmod -R u+w /home/xiaoyu/ghost/Ghost/.github/hooks
# yarn setup
# 启动ghost Ghost 现在在http://localhost:2368/ 运行 - Ghost 管理员位于 http://localhost:2368/ghost/
# export ALL_PROXY="socks5h://192.168.124.3:7890"
# unset HTTP_PROXY HTTPS_PROXY
# yarn dev
# 将这些代码拖出来安装就正常安装，直接bash运行就报错


# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# #------------------------------------------------------------------------------------------------------------------------------------------------------------------------