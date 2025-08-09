## 一、环境准备

### 1.vmware pro17

百度搜索下载破解版本，搜索秘钥进行激活

### 2.ubuntu24.0.4

> 注意配置ubuntu的内容为8g，cpu为4核

> 配置系统最大文件监控数量
>
> 临时生效（重启后失效）
>
> ```
> sudo sysctl fs.inotify.max_user_watches=524288
> ```
>
> 永久生效
>
> ```
> echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
> sudo sysctl -p
> ```

* https://ubuntu.com/download/desktop 中下在ubuntuLTS稳定版本，并在vmware 中安装

* 安装过程中出现界面显示不全：ctrl+alt+t打开终端，输入`xrandr -s 1280x800` 即可看到完整界面进行安装

* ubuntu进行换源：

  * 以前版本：/etc/apt/sources.list

  * 新版本：/etc/apt/sources.list.d/ubuntu.sources

    ```
    # 阿里云
    Types: deb
    URIs: http://mirrors.aliyun.com/ubuntu/
    Suites: noble noble-updates noble-security
    Components: main restricted universe multiverse
    Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
    ```

    然后sudo apt update，然后sudo apt upgrade

* 打开设置，电源，设置永不熄屏

* 如果无法正常在vmware中粘贴复制文件等，使用

  ```
  1.更新清华源，24版本的更新源方法与之前不同
  2.彻底删除open-vm-tools：sudo apt autoremove open-vm-tools
  3.在安装：sudo apt install open-vm-tools open-vm-tools-desktop -y
  4.在reboot
  5.还是无法解决，尝式注销后，点击用户，然后点右下角那也切换一下
  ```

### 3.win10：安装clash，同时开启clash中主页中的allow lan

### 4.查看win10的ip地址，设置ubuntu的代理模式

#### shell代理

```
ip="192.168.124.5"
export http_proxy="http://"$ip":7890"
export https_proxy="http://"$ip":7890"
```



#### git代理

```
ip=192.168.124.5
git config --global http.proxy http://$ip:7890
git config --global https.proxy http://$ip:7890
```

#### npm代理

```
ip="192.168.124.5"
npm config set proxy   "http://"$ip":7890"
npm config set https-proxy "http://"$ip":7890"
```

### 5.准备可用的docker镜像源

https://blog.whsir.com/post-8126.html 中查看测试可用的镜像源，确保该镜像源可用

6、将ghost的github进行fork到自己的github中

## 二、ubuntu中依赖软件安装

#### 1.软件安装

开发环境：

```
packages=("gedit" "curl" "git" "openssh-server" "python3" "python3-dev" "python3-setuptools" "python3-venv"  "net-tools" "build-essential")
```

部署环境：

```
packages=("gedit" "mysql-server" "vim" "curl" "git" "python3-venv" "python3-dev" "python3-setuptools")
```

开发和部署都要安装的：

* nodejs20：不要使用sudo

  ```
  # 安装 nvm（Node Version Manager）
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
  # 安装 Node.js v18.x (Iron LTS) 版本
  echo "正在安装 Node.js v18.x (Iron LTS) ..."
  nvm install $node_version #v18.20.8
  # 使用 Node.js v18.x 版本
  nvm use $node_version
  ```

* yarn: 不使用sudo，npm install --global yarn

* docker：

  ```
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
  sudo apt-get install -y docker-ce
  echo "正在启动 Docker 并设置开机自启..."
  sudo systemctl start docker
  sudo systemctl enable docker
  ```

  修改配置镜像：编辑创建/etc/docker/daemon.json

  ```
  {
      "registry-mirrors": [
          "第1步中查询得到的可用的镜像源"
      ]
  }
  ```

  将docker加入到当前用户组：

  ```
  # 将当前用户加入 docker 组
  sudo usermod -aG docker ${user_name}
  # 立即让当前 shell 生效（不需重登）
  newgrp docker
  ```

  最后配置重启docker

  ```
  echo "重载 Docker 配置并重启服务…"
  sudo systemctl daemon-reload
  sudo systemctl restart docker
  ```

可选：安装vscode

#### 2、代理配置

对于代理可以配置临时的，也可以配置全局的

#### 3、克隆代码

git clone --recurse-submodule fork到自己github账号的项目地址

sudo chmod -R 777 项目目录名

## 三、ghost安装配置

在ghost项目目录中执行：yarn setup 等待初始配置完成

> 如果过程中报错找不到某些资源，可以尝试开启shell代理，git代理

修改配置文件：在Ghost/ghost下编辑config.devlop.json

```
1.添加这个用于配置邮箱验证
"mail": {
    "transport": "SMTP",
    "options": {
      "service": "QQ",
      "host": "smtp.qq.com",
      "port": 465,
      "secure": true,
      "auth": {
        "user": "your-email@qq.com",  // 你的 QQ 邮箱地址
        "pass": "your-auth-code"  // 你的授权码（不是密码）
      }
    }，
     "from": "your-email@qq.com"
  }
2.配置vmware中的ghost到内网可以访问
"url": "http://192.168.72.130:2368",
"server": {
    "host": "0.0.0.0",
    "port": 2368
}
```

执行yarn dev启动项目

## 四、打包

调试好代码后，执行yarn archive打包ghost为.tgz文件格式，在目标机器上使用。

准备：

```
关闭docker中ghost使用的相关程序
docker stop $(docker ps -q)
在Ghost的源码顶层目录中执行
yarn add -W nx
```

yarn archive打包报错时：执行报错权限不够时，nx run ghost:"build:assets"这个任务执行失败，则单独执行

```
yarn nx run ghost:"build:assets"
然后在运行yarn archive
可正常打包，打包的文件在core文件夹下，找不到可以搜索一下.tgz文件
默认打包的输出路径在Ghost/ghost/core/xxx.tgz
```

## 五、目标机器安装

目标机器只需要 Node v20 、 Ghost-CLI和mysql即可

安装ghost-cli：sudo npm install -g ghost-cli@latest

安装node v20方法见上面的步骤

安装mysql

```
安装配置mysql
sudo apt-get update
sudo apt-get install -y mysql-server
sudo systemctl enable --now mysql
mysql -uroot -p     # 登录后：
CREATE DATABASE IF NOT EXISTS ghostdb;
CREATE USER IF NOT EXISTS 'ghostuser'@'localhost' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON ghostdb.* TO 'ghostuser'@'localhost';
FLUSH PRIVILEGES;
```

默认安装的mysql，sudo mysql可进入root，不需要密码。修改指定用户密码：ALTER USER 'ghostuser'@'localhost' IDENTIFIED BY 'ghostpassword';

安装ghost：ghost install官方文档https://ghost.org/docs/ghost-cli/#ghost-install

```
需要开启shell代理，git代理，否则会访问一些资源失败
# 添加其他用户可操作
sudo chmod o+rx /home/xiaoyu
# 安装并启动
ghost install --archive 绝对路径/ghost-custom.tgz --dir 安装到的目录（绝对路径）
```

启动ghost

```
在ghost install时会询问是否需要启动ghost，可以在这里就选择启动ghost
或者后续使用ghost start启动

启动过程中遇到的问题：
启动问题按照提示的suggestion执行就能解决，要么就是权限不足，直接给整个目录权限赋成777
但是在启动过程中还遇到的问题有:报错cron不是一个函数。解决办法为：
1.在current下的packge中的搜索cron找到cron的版本修改为1.8.2。（后续需要测试，是否需要修改这里的版本）如果不需要则只需要执行下一步的操作即可
2.找到current/node_modules/bree/lib这个目录，打开job-validator.js 文件，然后定位到文件中
var cron = require('cron-validate');将这个改成
var cronModule = require('cron-validate');
// 兼容新版 cron-validate 的 default 导出和老版直接导出
var cron = typeof cronModule === 'function'
    ? cronModule
    : (cronModule.default || cronModule);
```

