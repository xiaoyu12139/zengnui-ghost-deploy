const GhostAdminAPI = require('@tryghost/admin-api');

// 创建 GhostAdminAPI 实例
const api = new GhostAdminAPI({
  url: 'https://.',  // 你的 Ghost 后台 URL
  key: ':',  // 你的 API 密钥
  version: "v5.0",  // Ghost API 版本
});

// 获取所有文章
api.posts.browse({
  limit: 'all',  // 获取所有文章
})
.then(posts => {
  console.log(`共找到 ${posts.length} 篇文章`);

  // 遍历所有文章，检查是否有标签
  posts.forEach(post => {
    if (!post.tags || post.tags.length === 0) {
      console.log(`文章 "${post.title}" 没有标签，正在添加默认标签...`);

      // 为没有标签的文章添加默认标签
      api.posts.edit({
        id: post.id,  // 文章 ID
        tags: ['Default'],  // 添加默认标签
        updated_at: post.updated_at,  // 添加 updated_at 字段
      })
      .then(updatedPost => {
        console.log(`文章 "${updatedPost.title}" 已成功添加默认标签！`);
      })
      .catch(error => {
        console.error(`更新文章 "${post.title}" 标签失败:`, error);
      });
    }
  });
})
.catch(error => {
  console.error('获取文章失败:', error);
});
