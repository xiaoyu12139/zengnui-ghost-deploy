## 一、创建api token

打开cloudfare: https://dash.cloudflare.com/

点击头像，点击profile，点击api tokens，点击create custom token

![image-20250727084317259](C:\Users\xiaoyu\AppData\Roaming\Typora\typora-user-images\image-20250727084317259.png)

![image-20250727084350397](C:\Users\xiaoyu\AppData\Roaming\Typora\typora-user-images\image-20250727084350397.png)

如上：token name任意定义，permisssions:添加

![image-20250727084511431](C:\Users\xiaoyu\AppData\Roaming\Typora\typora-user-images\image-20250727084511431.png)

account resources配置需要包含的账号，我这里就配置了一个

![image-20250727084728715](C:\Users\xiaoyu\AppData\Roaming\Typora\typora-user-images\image-20250727084728715.png)

zone resources配置如下：

![image-20250727084804090](C:\Users\xiaoyu\AppData\Roaming\Typora\typora-user-images\image-20250727084804090.png)

然后点击continue，create

## 二、curl远程操作

获取acount id。返回的json中的id就是ACCOUNT_ID

```
curl -X GET "https://api.cloudflare.com/client/v4/accounts" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json"
```

获取tunnel列表

```
curl -X GET "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/tunnels" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json"
  

过滤结果的方法：
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/tunnels" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json" \
| jq -r '.result[] | "\(.name) \(.id)"'
```

根据状态过滤tunel

```
curl -s -G "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/tunnels" \
  --data-urlencode "status=active" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json" \
| jq -r '.result[] | "\(.name) \(.id)"'
```

创建tunnel

```
curl -v \
  -X POST "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/tunnels" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json" \
  --data '{"name":"ghost-blog-server"}'
```

删除tunnel

```
curl -X DELETE "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/tunnels/49d3477c-1740-4c12-861c-00aaaf45ea2e" \
  -H "Authorization: Bearer <第一步创建的授权码>" \
  -H "Content-Type: application/json"
```

## 三、具体步骤

#### 1.创建tunnel与相关配置文件

执行步骤2中的创建tunnel，返回一个json, 这里返回的id就是tunnel id

```
{
    "success": true,
    "errors": [],
    "messages": [],
    "result": {
        "id": "09423d221b-9f6iou7-4527-e235gfff5-d6a4cfb9449d",
        "account_tag": "354b1e87e1e1a293755213b133414392f1a9",
        "created_at": "2025-07-27T02:03:23.986130Z",
        "deleted_at": null,
        "name": "ghost-blog-server",
        "connections": [],
        "conns_active_at": null,
        "conns_inactive_at": "2025-07-27T02:03:23.986130Z",
        "tun_type": "cfd_tunnel",
        "metadata": {},
        "status": "inactive",
        "remote_config": false,
        "credentials_file": {
            "AccountTag": "354be87e1e1a293123755b133414392f1a9",
            "TunnelID": "092134d221b-9f1237-45e7-9e525-d6a4cfb9441239d",
            "TunnelName": "ghost-blog-server",
            "TunnelSecret": "xybEZeoTwnbDLwdFRNsHxw1eqkCW2/P833L231afBRMsLW122jhgjhn1KTT61bTw2uZqbKhSCHGtmqS4tkNY79pl9TEjqrkUOw=="
        },
        "token": "eyJhIjoi12MzU0YmU4N2UxZTFhMjkzNzU1YjEzMzQxNDM5MmYxYTkiLCJ0IjoiMDk0ZDIyMWItOWY2Ny00NWU3LTllNTUtZDZhNGNmYjk0NDlkIiwicyI6Inh5YkVaZW9Ud25iREx3ZEZSTnNIeHcxZXFrQ1cyL1A4MzNMYWZCkuiuhUk1zTFduS1RUNjFiVHcydVpxYktoU0NIR3RtcVM0dGtOWTc5cGw5VEVqcXJrVU93PT0ifQ=="
    }
}
```

保存credentials_file字段的内容到~/.cloudflared/TUNEL_ID.json

```
mkdir -p ~/.cloudflared

cat > ~/.cloudflared/<上面生成的tunnel id>.json <<'EOF'
{
  "AccountTag": "上面生成的",
  "TunnelID": "上面生成的",
  "TunnelName": "上面生成的",
  "TunnelSecret": "上面生成的"
}
EOF
```

配置config.yml

```
cat > ~/.cloudflared/config.yml <<'EOF'
tunnel: <tunnel id>
credentials-file: ~/.cloudflared/<tunnel id>.json

ingress:
  - hostname: zengnui.uk
    service: http://127.0.0.1:2368
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s

  - service: http_status:404
EOF
```

#### 2、配置cname

登录到cloudflare.com页面，点击域名，点击dns，添加一个cname，name设置为@即为主域名，其他为子域名，target设置为

| 类型  | 名称             | 目标                             | 代理  |
| ----- | ---------------- | -------------------------------- | ----- |
| CNAME | blog.example.com | `<tunnel-UUID>.cfargotunnel.com` | 开启🟠 |

编辑 `/etc/systemd/resolved.conf`：

```
[Resolve]
DNS=1.1.1.1 1.0.0.1
DNSStubListener=yes
```

sudo systemctl restart systemd-resolved重启resolver

测试：

```
resolvectl status | grep 'DNS Servers'
# 你应该能看到 1.1.1.1 1.0.0.1
```

#### 3、启动tunnel

启动tunnel

cloudflared tunnel run ghost-blog-server

#### 4.配置服务单元启动

配置为服务单元启动: sudo vim /etc/systemd/system/cloudflared-tunnel@.service

```
[Unit]
Description=cloudflared Tunnel %i
After=network.target

[Service]
Type=simple
User=xiaoyu
Environment="TUNNEL_NAME=%i"
Environment="CLOUDFLARED_CONFIG=/home/xiaoyu/.cloudflared/config.yml"
ExecStart=/usr/bin/cloudflared tunnel run "${TUNNEL_NAME}"
Restart=on-failure
RestartSec=5s
WorkingDirectory=/home/xiaoyu/.cloudflared
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

重新加载systemd服务配置：sudo systemctl daemon-reload

启动服务：

```
sudo systemctl enable cloudflared-tunnel@ghost-blog-server
sudo systemctl start cloudflared-tunnel@ghost-blog-server
```

#### 

## 四、配置ghost

注意修改ghost的配置文件中的url也要为http://zengnui.uk

然后ghost start就能正常访问