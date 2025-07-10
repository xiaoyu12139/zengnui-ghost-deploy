#### 1、环境

vmware pro17、ubuntu24

> ubuntu无法粘贴与拖文件问题：
>
> 更新清华源，24版本的更新源方法与之前不同
>
> 然后彻底删除open-vm-tools：sudo apt autoremove open-vm-tools
>
> 然后在安装：sudo apt install open-vm-tools open-vm-tools-desktop -y
>
> 然后在reboot
>
> 或者尝式注销后，点击用户，然后点右下角那也切换一下

配置虚拟机代理：主机clash开启allow lan

```
ip="192.168.124.3"
export http_proxy="http://"$ip":7890"
export https_proxy="http://"$ip":7890"
```

安装nodejs,npm,git,mysql

```
sudo apt install nodejs npm git mysql-server -y
```

安装vscode

```
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb
sudo dpkg -i code.deb
```

设置git代理

```
ip=192.168.124.3
git config --global http.proxy http://$ip:7890
git config --global https.proxy http://$ip:7890
```

拉取代码：

```
sudo git clone https://github.com/TryGhost/Ghost.git
```

npm设置代理

```
ip="192.168.124.3"
npm config set proxy   "http://"$ip":7890"
npm config set https-proxy "http://"$ip":7890"
```

进入拉取下来的ghost目录：安装依赖

```
sudo npm install --production --no-dev
报错则可以尝试如下：
sudo npm install --production --no-dev --legacy-peer-deps
```

> 安装ghost也可以不选择源码安装：
>
> sudo npm install -g ghost-cli@latest --verbose
>
> ghost install --dir /path/to/your/desired/directory
>
> 到ghost目录使用ghost start等命令

源码安装官方文档：https://ghost.org/docs/install/source/#prerequisites

docker目前可用镜像：https://blog.whsir.com/post-8126.html

##### 整合成脚本

```
#!/bin/bash
```

运行yarn setup时，保证docker源可用

保证运行yarn时关闭代理，ubuntu原来安装的mysql需要关调

sudo systemctl stop mysql

yarn dev启动前要设置

export ALL_PROXY="socks5h://192.168.124.3:7890"

unset HTTP_PROXY HTTPS_PROXY

不然会报一些静态资源找不到

#### 2、Ghost配置

数据库配置：ghost默认数据库为SQLite ，修改配置为mysql

创建mysql数据库

```
mysql -u root -p
CREATE DATABASE ghostdb;
GRANT ALL PRIVILEGES ON ghostdb.* TO 'ghostuser'@'localhost' IDENTIFIED BY 'your_password';
FLUSH PRIVILEGES;
```

编辑ghost配置文件指定mysql

```
sudo gedit config.production.json
```

#### 3、cloudflared内网穿透 配置

下载安装cloudflared

```
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo apt update
sudo dpkg -i cloudflared-linux-amd64.deb
# 如果有依赖缺失，再运行：
sudo apt --fix-broken install
cloudflared --version #验证安装
```

配置

```
# 会在 ~/.cloudflared 保存凭证文件
cloudflared tunnel login 打开的浏览器页面点击授权
# 创建一个名为 ghost-blog 的隧道
cloudflared tunnel create ghost-blog
```

编辑~/.cloudflared/config.yml

```
tunnel: <your-tunnel-UUID>
credentials-file: /home/youruser/.cloudflared/<your-tunnel-UUID>.json

ingress:
  - hostname: blog.example.com
    service: http://127.0.0.1:2368
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s

  # 回退：其他请求返回 404
  - service: http_status:404
```

登录到cloudflare.com页面，点击域名，点击dns，添加一个cname，name设置为@即为主域名，其他为子域名，target设置为

| 类型  | 名称             | 目标                             | 代理  |
| ----- | ---------------- | -------------------------------- | ----- |
| CNAME | blog.example.com | `<tunnel-UUID>.cfargotunnel.com` | 开启🟠 |

> 问题1：当 cloudflared 在启动阶段一直拿不到 `_v2-origintunneld._tcp.argotunnel.com` 的 SRV 记录（因为它走的是 systemd-resolved 的 127.0.0.53 stub 且超时），它就认为自己无法找到任何可用的 Cloudflare Edge 节点，最终就会自行退出

编辑 `/etc/systemd/resolved.conf`：

```
[Resolve]
DNS=1.1.1.1 1.0.0.1
DNSStubListener=yes
```

sudo systemctl restart systemd-resolved重启resolver

```
resolvectl status | grep 'DNS Servers'
# 你应该能看到 1.1.1.1 1.0.0.1
```

作为系统服务自动启动

创建系统服务单元

```
[Unit]
Description=cloudflared Tunnel %i
After=network.target

[Service]
Type=simple
User=xiaoyu
Environment="TUNNEL_NAME=%i"
Environment="TUNNEL_ORIGIN_CERT=/home/xiaoyu/.cloudflared/cert.pem"
ExecStart=/usr/bin/cloudflared tunnel run "${TUNNEL_NAME}"
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

相关操作：

sudo systemctl daemon-reload
sudo systemctl enable --now cloudflared@ghost-tunnel
sudo systemctl status cloudflared@ghost-tunnel

#### 4、cloudflared配置 限制访问

https://dash.cloudflare.com/

进入登录后，点击域名，点击左侧面板的access，点击右侧的launch zero trust，点击access，然后点击application创建一个application，点击self host，点击Add public hostname，在domain中将域名填进去

![image-20250705221135864](./源码安装ghost.assets/image-20250705221135864.png)

然后点击policies,添加一个policies，

![image-20250705221157877](./源码安装ghost.assets/image-20250705221157877.png)

![image-20250705221511260](./源码安装ghost.assets/image-20250705221511260.png)

#### 5、ghost自定义化修改

## 使用 Ghost-CLI 打包成 `.tar.gz`

Ghost-CLI 自带一个 `ghost pack` 命令，可以把当前目录下的 Ghost 整个项目（含编译好的前端资源、生产依赖、配置示例等）打包成一个压缩包，然后你可以把它拷到任何一台服务器或其他环境，用同一个 Ghost-CLI 来安装。

1. **安装并验证编译**

   ```
   bash复制编辑# 在 Ghost 源码根目录下
   yarn install              # 或 npm install
   yarn build                # 编译 admin UI + 核心前端资源
   npm prune --production    # 删除 devDependencies，只保留生产依赖
   ```

2. **全局安装 Ghost-CLI**

   ```
   bash
   
   
   复制编辑
   sudo npm install -g ghost-cli@latest
   ```

3. **打包**

   ```
   bash复制编辑# 在源码根目录下执行
   ghost pack --output ghost-custom-1.0.0.tar.gz
   ```

   （如果你想指定版本号，先确认 `package.json` 中 version 字段正确；`ghost pack` 会读取它。）

4. **在目标机器上安装**

   ```
   bash复制编辑# 把 ghost-custom-1.0.0.tar.gz 上传到新服务器
   mkdir -p /var/www/ghost-custom
   cd /var/www/ghost-custom
   ghost install ./ghost-custom-1.0.0.tar.gz \
     --db mysql --dbhost 127.0.0.1 --dbuser root --dbpass yourpass \
     --url https://blog.yoursite.com
   ```

   这样 Ghost-CLI 会自动解压、生成配置、安装数据库表、并启动 Ghost。