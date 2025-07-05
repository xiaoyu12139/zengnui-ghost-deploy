import fs from 'fs';
import path from 'path';
// import { GhostAdminAPI } from '@tryghost/admin-api';  // 使用 ES 模块导入
import pkg from '@tryghost/admin-api';  // 使用默认导入
const GhostAdminAPI = pkg;  // 解构赋值获取 GhostAdminAPI
import { marked } from 'marked';  // 使用 ES 模块导入

// 设置 Ghost API 配置
const api = new GhostAdminAPI({
  url: 'https://zengnui.uk',  // 你的 Ghost 后台 URL
  key: '6868f62470e4bf6682443f43:6a9d53318e2d9b23b70906205ce7bb712038e6c607a2658d0079785205daef26',  // 你的 API 密钥
  version: "v5.0",  // Ghost API 版本
});

// 递归读取指定目录中的 .md 文件
function readMarkdownFiles(dirPath) {
  const files = fs.readdirSync(dirPath);
  const markdownFiles = [];

  files.forEach(file => {
    const fullPath = path.join(dirPath, file);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      // 如果是目录，递归查找
      markdownFiles.push(...readMarkdownFiles(fullPath));
    } else if (file.endsWith('.md')) {
      // 如果是 .md 文件，添加到文件列表
      markdownFiles.push(fullPath);
    }
  });

  return markdownFiles;
}

// 将 Markdown 转换为 Ghost 可编辑的 Lexical 格式
function markdownToLexical(markdown) {
  // 你可以根据实际需求，进一步解析 Markdown 内容并生成 Lexical 格式的 JSON
//   const htmlContent = marked(markdown);  // 使用 marked 将 Markdown 转换为 HTML
//   const htmlContent = markdown;
  const jsonContent = {
    root: {
        children: [
        {
            children: [
            {
                detail: 0,
                format: 0,
                mode: "normal",
                style: "",
                text: markdown,
                type: "extended-text",
                version: 1
            }
            ],
            direction: "ltr",
            format: "",
            indent: 0,
            type: "paragraph",
            version: 1
        }
        ],
        "direction": "ltr",
        "format": "",
        "indent": 0,
        "type": "root",
        "version": 1
    }
    };
    return JSON.stringify(jsonContent);
}

// 上传单个 Markdown 文件到 Ghost
async function uploadMarkdownFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');  // 读取文件内容
    const lexicalString= markdownToLexical(content);
    const postData = {
      title: path.basename(filePath, '.md'),  // 使用文件名作为文章标题
      status: 'published',  // 默认发布
    //   lexical: `'{"root":{"children":[{"children":[{"detail":0,"format":0,"mode":"normal","style":"","text":"${content}","type":"extended-text","version":1}],"direction":"ltr","format":"","indent":0,"type":"paragraph","version":1}],"direction":"ltr","format":"","indent":0,"type":"root","version":1}}'`,
      lexical: lexicalString,
    //   html: htmlContent,  // 将文件内容直接作为 HTML 上传
      tags: ['Default'],  // 默认标签
    };

    const response = await api.posts.add(postData);
    console.log(`文章 "${response.title}" 上传成功！`);
  } catch (error) {
    console.error(`上传文件 ${filePath} 失败:`, error);
  }
}

// 主程序
async function uploadMarkdownFilesFromDirectory(directoryPath) {
  const markdownFiles = readMarkdownFiles(directoryPath);

  if (markdownFiles.length === 0) {
    console.log('没有找到任何 .md 文件');
    return;
  }

  console.log(`共找到 ${markdownFiles.length} 个 Markdown 文件，开始上传...`);

  for (const filePath of markdownFiles) {
    await uploadMarkdownFile(filePath);
  }
}

// 指定要上传的目录路径
const directoryPath = 'D:/blog/test';  // 请替换为你的 Markdown 文件目录路径
uploadMarkdownFilesFromDirectory(directoryPath);
