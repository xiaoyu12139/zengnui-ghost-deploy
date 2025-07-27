from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time

# 可选：无头模式
opts = Options()
# opts.add_argument("--headless")
# opts.add_argument("--disable-gpu")
opts.add_argument("--log-level=3")  # 限制日志级别为 `ERROR`，减少日志输出

# 自动下载并启动最新的 chromedriver
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=opts)

# 设置隐式等待时间
driver.implicitly_wait(10)

# ghost cookie
cookies = [
  {
    "domain": "192.168.85.132",
    "hostOnly": True,
    "httpOnly": True,
    "name": "ghost-admin-api-session",
    "path": "/ghost",
    "secure": False,
    "session": True,
    "value": "s%3AP0N3RlUJ91VeaJXUfHL87TO3VJDT8hLz.X94%2BpDfJmDwBI4OOyUZdrkdyMkArrlRUMWoy9kFMKV8"
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
# 动态等待页面加载完成
wait = WebDriverWait(driver, 15)  # 最长等 15 秒
# 等待 #login-button 可点击
post_btn = wait.until(
    # 等待元素可见
    EC.element_to_be_clickable((By.XPATH, '//*[@id="ember9"]'))
)

# 点击post按钮
post_btn.click()

def update_file(data):
    new_post_btn = wait.until(
        # 等待元素可见
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember67"]'))
    )
    new_post_btn.click()

update_file("test update markdown")

input("Press Enter to close the browser...")
driver.quit()
