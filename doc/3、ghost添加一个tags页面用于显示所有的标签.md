在配置文件config.production.json中进行配置

源码安装的ghost的主题目录在Ghost/ghost/core/themes

官方推荐方法安装的主题目录在安装的目录下的content/themes

在主题同级目录下的settings文件夹中的routes.yml可以配置自定义的.hbs模板路径访问url

如下，这里的tags.hbs就是我添加在与default.hbs同级目录下的模板文件。访问方法即为：url/tags

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

同时保证存在tags.hbs在与default.hbs同目录下

```
{{!< default}}

<style>
/* ====== page-tags.hbs 专属样式 ====== */
.page-tags {
  padding: 4rem 1rem;
  background-color: var(--grey-lightest);
}

.page-tags .container {
  max-width: 960px;
  margin: 0 auto;
}

.page-tags h1 {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  text-align: center;
  color: var(--text);
}

.page-tags p {
  text-align: center;
  color: var(--text-fade);
  margin-bottom: 2rem;
}

/* 标签列表：卡片风格 + 响应式网格 */
.page-tags .tags-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 0.75rem;
  padding: 0;
  list-style: none;
}

.page-tags .tag-item {
  background: var(--white);
  border: 1px solid var(--grey-light);
  border-radius: 0.5rem;
  text-align: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.page-tags .tag-item a {
  display: block;
  padding: 0.75rem 1rem;
  color: var(--primary);
  font-weight: 500;
  text-decoration: none;
}

.page-tags .tag-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  color: #ffffff; /* 白色文字 */
  background-color: #007bff; /* 蓝色背景 */
}

.page-tags .tag-count {
  display: inline-block;
  margin-left: 0.25rem;
  color: var(--text-fade);
  font-size: 0.85em;
}

/* 移动端优化 */
@media (max-width: 480px) {
  .page-tags h1 { font-size: 2rem; }
  .page-tags .tags-list {
    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  }
}

</style>

<main class="page-tags">
  <section class="container">
    <h1>所有标签</h1>

    {{!-- 如果想加简介，解开下面注释 --}}
    {{!--
    <p>这里展示站点所有标签，点击即可查看对应文章。</p>
    --}}

    {{#get "tags" limit="all" include="count.posts" order="count.posts DESC"}}
      {{#if tags}}
        <ul class="tags-list">
          {{#foreach tags}}
            <li class="tag-item">
              <a href="{{url}}" title="查看“{{name}}”标签下的所有文章">
                {{name}} <span class="tag-count">（{{count.posts}}）</span>
              </a>
            </li>
          {{/foreach}}
        </ul>
      {{else}}
        <p>目前还没有任何标签。</p>
      {{/if}}
    {{/get}}
  </section>
</main>

```

