## 目录结构

* doc：相关操作文档、
* script：相关配置脚本
* theme：自定义修改的主题

### 1、doc介绍

详见doc目录下的markdown

### 2、script介绍

详见doc目录下的 script操作说明文档

#### 3、theme介绍

simply的明暗主题

attila的简约效果

https://github.com/razbook/ghost-themes/tree/master/attila-1.7.5

aeizzz的博客效果？

https://github.com/razbook/ghost-themes/tree/master/Aeizzz-ghost-theme-kaldorei-323ccfe

决定：以attila为base，同时可以参考另外两个，然后在attila基础上对theme进行改进

#### 说明

在/.../content/settings中的routes.yml中设置打开指定页面的url

```
routes:
  /tags/:
    template: tags

collections:
  /:
    permalink: /{slug}/
    template: index


taxonomies:
  tag: /tag/{slug}/
  author: /author/{slug}/
```

添加tags.hbs

#### api管理内容

首先cloudflare关闭限制访问

进入script文件夹

```
npm init -y
npm install @tryghost/admin-api
```

创建更新文章默认标签脚本

创建上传本地文章脚本

node xxx.js执行脚本

#### TODO：发布文章时默认添加一个标签分类？

