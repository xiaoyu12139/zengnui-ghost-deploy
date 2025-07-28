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

def copy_image_to_clipboard(image_path: Path):
    """
    复制指定路径的图片到剪贴板
    """
    # 打开图片
    image = Image.open(image_path)
    
    # 将图片保存到剪贴板
    image.show()  # 使用默认图像查看器打开，可能会显示在剪贴板中
    
    # 图片复制到剪贴板
    # try:
    image = Image.open(image_path)
    output = BytesIO()
    image.save(output, format="PNG")
    image_data = output.getvalue()
    
    # 使用 pyperclip 复制，注意 pyperclip 只支持文本，必须转换为合适的类型
    pyperclip.copy(image_data)  # 这样可能无法复制图片，但这是一个简化例子
    print(f"图片 {image_path} 已复制到剪贴板。")
    # except Exception as e:
    #     print(f"复制图片到剪贴板失败: {e}")

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
    if img_path.scheme in ["http", "https"]:
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

def paste_content():
    editor = wait.until(
        # 等待元素可见
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember25"]/div[1]/div[1]/div[3]/div/div[1]/div/div[1]/div'))
    )
    # 执行 JavaScript 将光标移动到编辑区域的最后
    driver.execute_script("""
        var editor = arguments[0];
        var range = document.createRange();
        var selection = window.getSelection();
        range.selectNodeContents(editor);
        range.collapse(false);  // false 表示将光标放在内容末尾
        selection.removeAllRanges();
        selection.addRange(range);
    """, editor)
    editor.click()  # 模拟点击光标所在位置
    pyperclip.paste()

def publish():
    publish_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember25"]/header/section/button[2]/span[1]'))
    )
    publish_btn.click()
    continue_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember30"]/div/div/div[3]/button'))
    )
    continue_btn.click()
    ok_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember40"]'))
    )
    ok_btn.click()
    close_btn = wait.until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember108"]/div/button'))
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
                        # 等待元素可见
                        EC.element_to_be_clickable((By.XPATH, '//*[@id="ember67"]'))
                    )
                    new_post_btn.click()
                    for item in content:
                        if item[0] == 'text':
                            pyperclip.copy(text[item[1]])
                        elif item[1] == 'img':
                            handle_image_path(file, img[item[1]])
                        else:
                            print("error...")
                        # pyperclip.paste()
                        paste_content()
                        publish()
                except Exception as e:
                    print(f"Upload markdown file failed: {file}")
                    failed_list.append(file)
                


directory = ""
traverse_files(directory)
for file in failed_list:
    print(f"上传失败的文件：{file}")
    
input("Press Enter to close the browser...")
driver.quit()
print("上传完成..")
