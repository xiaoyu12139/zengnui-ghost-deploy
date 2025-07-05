const GhostAdminAPI = require('@tryghost/admin-api');

// 创建 GhostAdminAPI 实例
const api = new GhostAdminAPI({
  url: 'https://zengnui.uk',  // 你的 Ghost 后台 URL
  key: '6868f62470e4bf6682443f43:6a9d53318e2d9b23b70906205ce7bb712038e6c607a2658d0079785205daef26',  // 你的 API 密钥
  version: "v5.0",  // Ghost API 版本
});

// 创建文章
api.posts.add({
  title: 'My first draft API post',
  lexical: '{"root":{"children":[{"children":[{"detail":0,"format":0,"mode":"normal","style":"","text":"Hello, beautiful world! 👋","type":"extended-text","version":1}],"direction":"ltr","format":"","indent":0,"type":"paragraph","version":1}],"direction":"ltr","format":"","indent":0,"type":"root","version":1}}',
  tags: ['Default'],  // 添加默认标签,
  status: 'published'  // 设置为已发布状态
})
.then(response => {
  console.log('文章创建成功:', response);
})
.catch(error => {
  console.error('创建文章失败:', error);
});
