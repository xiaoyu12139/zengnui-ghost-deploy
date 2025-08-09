## 1、关闭https Rewrites

登录cloudflare网站

点击zengnui.uk

点击ssl/tls

点击edge certificates

向下滑动找到Automatic HTTPS Rewrites点击关闭

## 2、关闭限制访问

如果开启了限制访问会导致还是重定向到使用https

## 3、服务器配置https

将ghost中的config.json配置的url中http改成https