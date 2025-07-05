import os
import zipfile

def zip_directory(directory_path, zip_name):
    # 创建一个 zip 文件
    with zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
        # 遍历目录中的所有文件和子目录
        for root, dirs, files in os.walk(directory_path):
            for file in files:
                # 获取文件的完整路径
                file_path = os.path.join(root, file)
                # 获取相对路径（去除目录中的父级路径部分）
                arcname = os.path.relpath(file_path, directory_path)
                # 将文件添加到 zip 文件中
                zipf.write(file_path, arcname)

# 使用方法
directory_to_zip = 'theme'  # 要打包的目录
output_zip = 'zengnui-theme.zip'  # 输出的 zip 文件名

zip_directory(directory_to_zip, output_zip)
