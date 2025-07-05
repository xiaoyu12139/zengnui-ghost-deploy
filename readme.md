#### 介绍

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

#### TODO：发布文章时默认添加一个标签分类？