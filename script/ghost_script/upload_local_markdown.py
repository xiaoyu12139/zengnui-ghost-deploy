from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time
from pathlib import Path
import re
from typing import List, Tuple, Union
import pyperclip
import os
import requests
from pathlib import Path
from PIL import Image
import pyperclip
from io import BytesIO
from selenium.webdriver.common.keys import Keys
from urllib.parse import urlparse
import os
from io import BytesIO
from PIL import Image
import win32clipboard
from win32con import CF_DIB
import ctypes
from selenium.webdriver.common.action_chains import ActionChains

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

# update_file("test update markdown")

def copy_image_to_clipboard(image_path: str):
    """
    复制指定路径的图片到剪贴板
    """
    # 打开图片
    image = Image.open(image_path)

    # 将图片转化为 BMP 格式（Windows 剪贴板需要 BMP 格式）
    with BytesIO() as output:
        image.convert("RGB").save(output, format="BMP")
        data = output.getvalue()[14:]  # 跳过 BMP 头的前14 字节

    # 打开剪贴板
    win32clipboard.OpenClipboard()
    win32clipboard.EmptyClipboard()
    # 设置剪贴板数据为图片
    win32clipboard.SetClipboardData(CF_DIB, data)
    win32clipboard.CloseClipboard()

    print(f"图片 {image_path} 已复制到剪贴板。")

def is_url(path):
    """检查路径是否是 URL"""
    # 如果是 Path 对象，则直接返回 False
    if isinstance(path, Path):
        return False
    
    # 使用 urlparse 来解析 URL
    parsed_url = urlparse(path)
    # 检查 scheme 是否是 http 或 https
    return parsed_url.scheme in ["http", "https"]

def handle_image_path(markdown_file_path: Path, img_path: str):
    """
    处理图片路径，如果是相对路径则转换为绝对路径，
    如果是 URL 则下载图片并保存到本地，最后复制图片到剪贴板
    """
    img_path = Path(img_path)

    # 1. 判断是否是相对路径
    if not img_path.is_absolute():
        # 将相对路径转为绝对路径
        img_path = markdown_file_path.parent / img_path
        print(f"相对路径转换为绝对路径: {img_path}")
    
    # 2. 判断是否是 URL
    if is_url(img_path):
        # 下载图片并保存到本地
        print(f"正在从 {img_path} 下载图片...")
        response = requests.get(img_path)
        
        if response.status_code == 200:
            # 获取图片的文件名，并保存到当前脚本所在目录的 tmp 文件夹
            tmp_dir = Path(__file__).parent / "tmp"
            tmp_dir.mkdir(parents=True, exist_ok=True)  # 确保 tmp 目录存在
            
            # 保存图片文件
            img_filename = tmp_dir / img_path.name
            with open(img_filename, "wb") as f:
                f.write(response.content)
            print(f"图片已下载并保存为: {img_filename}")
            img_path = img_filename  # 更新为下载的图片路径
    
    # 3. 复制图片到剪贴板
    copy_image_to_clipboard(img_path)

def extract_markdown_info(md_file_path: Path) -> Tuple[List[Tuple[str, int]], List[str], List[str]]:
    """
    读取一个 Markdown 文件（Path 对象），按图片和文本分割，返回三元组：
      1. content 列表：每项为 (类型, index)，类型为 'text' 或 'img'，index 是该项在 text/img 列表中的索引
      2. text 列表：按出现顺序存储的所有文本段落
      3. img 列表：按出现顺序存储的所有图片 URL
    """
    # 读取整个文件内容
    content_str = md_file_path.read_text(encoding='utf-8')
    
    # 图片的正则：匹配 Markdown 里的 ![alt](url)
    image_pattern = re.compile(r'!\[.*?\]\((.*?)\)')
    
    # 先用 re.split 保留图片标记，把文本和图片“段”分开
    parts = re.split(r'(!\[.*?\]\(.*?\))', content_str)
    
    text: List[str] = []
    img: List[str] = []
    content: List[Tuple[str, int]] = []
    
    for part in parts:
        if not part:
            continue
        m = image_pattern.match(part)
        if m:
            # 这是一个图片
            url = m.group(1)
            img.append(url)
            content.append(('img', len(img) - 1))
        else:
            # 剩下的都是文本（可能包含换行）
            stripped = part.strip()
            if stripped:
                text.append(stripped)
                content.append(('text', len(text) - 1))
    
    return content, text, img

def paste_title():
    title_ele = wait.until(
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[2]/div/main/div[1]/section/div[1]/div[1]/div[2]/textarea'))
    )
    title_ele.click()
    time.sleep(0.5)
    title_ele.send_keys(Keys.CONTROL, 'v')

def paste_content(content_type, first_line):
    editor = wait.until(
        # 等待元素可见 /html/body/div[2]/div/main/div[1]/section/div[1]/div[1]/div[3]/div/div[1]/div/div[1]/div
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[2]/div/main/div[1]/section/div[1]/div[1]/div[3]/div/div[1]/div/div[1]/div[last()]'))
    )
    driver.execute_script("""
        var element = arguments[0];
        element.scrollIntoView({behavior: 'smooth', block: 'end'});
    """, editor)
    time.sleep(1)
    # # 执行 JavaScript 将光标移动到编辑区域的最后
    driver.execute_script("""
        var editor = arguments[0];
        var range = document.createRange();
        var selection = window.getSelection();
        range.selectNodeContents(editor);
        range.collapse(false);  // false 表示将光标放在内容末尾
        selection.removeAllRanges();
        selection.addRange(range);
        editor.focus();
    """, editor)

    print(repr(pyperclip.paste()))
    if not first_line:
        editor.send_keys(Keys.ENTER)
    editor.send_keys(Keys.CONTROL, 'v')
    WebDriverWait(driver, 20).until(
        lambda driver: driver.find_element(By.XPATH, '/html/body/div[2]/div/main/div[1]/section/header/div/div/span/div').text != "Saving..."
    )

def publish():
    publish_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[2]/div/main/div[1]/section/header/section/button[2]'))
    )
    publish_btn.click()
    continue_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[4]/div/div/div/div[3]/button'))
    )
    continue_btn.click()
    ok_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[4]/div/div/div/div[2]/button[1]'))
    )
    ok_btn.click()
    close_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '/html/body/div[5]/div/div/button'))
    )
    close_btn.click()

failed_list = []

def traverse_files(directory):
    # 创建一个 Path 对象
    path = Path(directory)
    
    # 使用 rglob() 方法递归查找所有文件
    for file in path.rglob('*'):  # '*' 表示匹配所有文件
        if file.is_file():  # 检查是否是文件而不是目录
            # print(f"Found file: {file}")
            # 获取文件的后缀并转为小写
            file_extension = file.suffix.lower()
            
            # 判断后缀是否为 .md
            if file_extension == '.md':
                print(f"Found markdown file: {file}")
                try:
                    content, text, img = extract_markdown_info(file)
                    new_post_btn = wait.until(
                        # 等待元素可见 /html/body/div[2]/div/main/div[1]/section/div[1]/div[1]/div[3]/div/div[1]/div/div[1]/div
                        EC.element_to_be_clickable((By.XPATH, '/html/body/div[2]/div/main/section/div/header/section/div[2]'))
                    )
                    new_post_btn.click()
                    pyperclip.copy(file.stem)
                    paste_title()
                    first_line = True
                    for item in content:
                        if item[0] == 'text':
                            pyperclip.copy(text[item[1]])
                        elif item[0] == 'img':
                            handle_image_path(file, img[item[1]])
                        else:
                            print("error...")
                        # pyperclip.paste()
                        paste_content(item[0], first_line)
                        first_line = False
                    publish()
                except Exception as e:
                    print(f"Upload markdown file failed: {file}")
                    print(f"error: {e}")
                    failed_list.append(file)
                


directory = r"C:\Users\xiaoyu\Desktop\upload"
traverse_files(directory)
for file in failed_list:
    print(f"上传失败的文件：{file}")

# input("暂停...")
driver.quit()
print("上传完成..")
input("Press Enter to close the browser...")
