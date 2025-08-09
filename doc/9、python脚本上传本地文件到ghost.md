## 环境准备

使用conda管理虚拟环境

```
conda create --name auto python=3.9
conda activate auto
```

vscode中安装python插件，然后ctrl shift p调出命令面板，然后在输入python select intepreter选择我们创建的那个虚拟环境的python

在激活了auto虚拟环境的终端中：

```
pip install selenium
pip install webdriver-manager
pip install Pillow pyperclip
pip install requests
pip install Pillow pywin32
```

新版本的selenium推荐使用webdriver-manager来自动管理浏览器的驱动

## cookie

在本地的chrome中下载cookie editor插件，导出json格式的cookie

在python代码中指定设置这个cookie,

注意这个cookie中需要删除expirationDate和storeId，还有sameSite字段。此外，secure要设置为False，因为ghost我们配置的是http连接

```
cookies = [
{
"domain": "192.168.85.132",
"hostOnly": True,
"httpOnly": True,
"name": "ghost-admin-api-session",
"path": "/ghost",
"secure": False,
"session": True,
"value": "s%3AP0N3RlUJ9O3VJDT8hLz.X94%2BpDfJmDwBI4OOyUZdrkdyMkArrlRUMWoy9kFMKV8"
}
]
# 打开 Ghost 博客的 URL
ghost_url = "http://192.168.85.132:2368/ghost"
driver.get(ghost_url)
# 添加 cookie
driver.add_cookie(cookies[0]) 
# 刷新页面以确保 cookies 生效
driver.get(ghost_url)
# 确认 cookies 是否已设置
cookies = driver.get_cookies()
print("当前的 cookies:", cookies)
```

使用教程：

将里面的directory替换为放有markdown文件的路径即可
