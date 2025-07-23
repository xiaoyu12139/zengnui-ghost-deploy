## 1.实现过程

ghost源码安装

yarn dev启动

定位到文件：/home/xiaoyu/ghost/Ghost/ghost/admin/app/components/editor/publish-management.js

中的函数 @task

  *publishTask({taskName = 'saveTask'} = {}) {

在函数中打印    console.log("test post:")

​    console.log(this.publishOptions.post)
获得数据

```json
{
    "count": {
        "clicks": 0,
        "positive_feedback": 0,
        "negative_feedback": 0
    },
    "createdAtUTC": "2025-06-12T10:51:45.000Z",
    "excerpt": "Dolore sed dicta. Eos sed ratione est delectus temporibus rerum reprehenderit. Illo cupiditate omnis et totam nemo deserunt.\n\nConsequatur repellat perferendis assumenda tempora cupiditate culpa quos pariatur iure. Quos totam maxime. Accusamus quae neque molestiae ea saepe placeat ullam. Quam illo excepturi culpa aspernatur harum. Non rem assumenda quia aliquid eligendi. Dicta aliquam adipisci.\n\nOdio labore quod quasi nobis iusto dolor exercitationem. Reprehenderit inventore eos debitis. Fuga odi",
    "customExcerpt": null,
    "featured": false,
    "canonicalUrl": null,
    "codeinjectionFoot": null,
    "codeinjectionHead": null,
    "customTemplate": null,
    "ogImage": null,
    "ogTitle": null,
    "ogDescription": null,
    "twitterImage": null,
    "twitterTitle": null,
    "twitterDescription": null,
    "emailSubject": null,
    "html": null,
    "visibility": "paid",
    "metaDescription": null,
    "metaTitle": null,
    "mobiledoc": null,
    "lexical": "{\"root\":{\"children\":[{\"children\":[{\"detail\":0,\"format\":0,\"mode\":\"normal\",\"style\":\"\",\"text\":\"Dolore sed dicta. Eos sed ratione est delectus temporibus rerum reprehenderit. Illo cupiditate omnis et totam nemo deserunt.\",\"type\":\"extended-text\",\"version\":1}],\"direction\":\"ltr\",\"format\":\"\",\"indent\":0,\"type\":\"paragraph\",\"version\":1},{\"children\":[{\"detail\":0,\"format\":0,\"mode\":\"normal\",\"style\":\"\",\"text\":\"Consequatur repellat perferendis assumenda tempora cupiditate culpa quos pariatur iure. Quos totam maxime. Accusamus quae neque molestiae ea saepe placeat ullam. Quam illo excepturi culpa aspernatur harum. Non rem assumenda quia aliquid eligendi. Dicta aliquam adipisci.\",\"type\":\"extended-text\",\"version\":1}],\"direction\":\"ltr\",\"format\":\"\",\"indent\":0,\"type\":\"paragraph\",\"version\":1},{\"children\":[{\"detail\":0,\"format\":0,\"mode\":\"normal\",\"style\":\"\",\"text\":\"Odio labore quod quasi nobis iusto dolor exercitationem. Reprehenderit inventore eos debitis. Fuga odit similique dolore officiis ducimus earum voluptates qui et.\",\"type\":\"extended-text\",\"version\":1}],\"direction\":\"ltr\",\"format\":\"\",\"indent\":0,\"type\":\"paragraph\",\"version\":1},{\"children\":[{\"detail\":0,\"format\":0,\"mode\":\"normal\",\"style\":\"\",\"text\":\"Adipisci magni ipsa mollitia eum excepturi vero. Ipsa doloremque unde dicta voluptate facilis perferendis ipsum et. Ipsam accusamus aliquid. Ipsum ut vel nostrum esse aliquam provident deserunt vel eum. Inventore iusto similique minima impedit iure.\",\"type\":\"extended-text\",\"version\":1}],\"direction\":\"ltr\",\"format\":\"\",\"indent\":0,\"type\":\"paragraph\",\"version\":1}],\"direction\":\"ltr\",\"format\":\"\",\"indent\":0,\"type\":\"root\",\"version\":1}}",
    "plaintext": null,
    "publishedAtUTC": "2025-07-14T15:11:16.000Z",
    "slug": "optio-dolorum-ad-commodi-consequuntur-expedita-quod-debitis-635",
    "status": "published",
    "title": "Optio dolorum ad commodi consequuntur expedita quod debitis.",
    "updatedAtUTC": "2025-07-14T15:11:15.000Z",
    "updatedBy": null,
    "url": "http://192.168.72.130:2368/optio-dolorum-ad-commodi-consequuntur-expedita-quod-debitis-635/",
    "uuid": "5a1c08ad-d375-461c-a497-7d572ebe80ba",
    "emailSegment": "all",
    "emailOnly": false,
    "featureImage": null,
    "featureImageAlt": null,
    "featureImageCaption": null,
    "showTitleAndFeatureImage": true,
    "tiers": [
        {
            "id": "00000000fb69af947b236466",
            "name": "Bronze",
            "slug": "bronze-467",
            "active": true,
            "welcome_page_url": null,
            "visibility": "public",
            "trial_days": 0,
            "description": "Bronze tier member",
            "type": "paid",
            "currency": "usd",
            "monthly_price": 500,
            "yearly_price": 5000,
            "created_at": "2018-08-01T23:40:15.000Z",
            "updated_at": null,
            "monthly_price_id": null,
            "yearly_price_id": null
        },
        {
            "id": "00000000703e0fb16598bca1",
            "name": "Silver",
            "slug": "silver-241",
            "active": true,
            "welcome_page_url": null,
            "visibility": "public",
            "trial_days": 0,
            "description": "Silver tier member",
            "type": "paid",
            "currency": "usd",
            "monthly_price": 1000,
            "yearly_price": 10000,
            "created_at": "2018-06-18T23:43:36.000Z",
            "updated_at": null,
            "monthly_price_id": null,
            "yearly_price_id": null
        },
        {
            "id": "0000000088b6886da24cd97d",
            "name": "Gold",
            "slug": "gold-776",
            "active": true,
            "welcome_page_url": null,
            "visibility": "public",
            "trial_days": 0,
            "description": "Gold tier member",
            "type": "paid",
            "currency": "usd",
            "monthly_price": 1500,
            "yearly_price": 15000,
            "created_at": "2018-08-08T03:08:43.000Z",
            "updated_at": null,
            "monthly_price_id": null,
            "yearly_price_id": null
        }
    ],
    "authors": [
        "1"
    ],
    "createdBy": null,
    "email": null,
    "newsletter": null,
    "publishedBy": null,
    "tags": [
        "00000000700cc39a904415e1",
        "000000008db8b87d6cc7fb69"
    ],
    "postRevisions": [
        "68751e1422b4832944a5ebc5"
    ]
}
```

说明tags是按id数组保存的

```
"tags": [
    "00000000700cc39a904415e1",
    "000000008db8b87d6cc7fb69"
]
```

但我想要找到的是可以直接添加名字就修改



搜索save相关的函数，定位到/home/xiaoyu/ghost_dev/Ghost/ghost/admin/app/controllers/lexical-editor.js

在这里面的函数@task

  *beforeSaveTask()：

````
修改为：
 @task
    *beforeSaveTask() {
        if (this.post?.isDestroyed || this.post?.isDestroying) {
            return;
        }

        // ––– 在这里检测并自动添加标签 –––
        const REQUIRED_TAG_ID = '000000008292eb1a4db37ea9';//977
        console.log("todo  found tag:", REQUIRED_TAG_ID);
        console.log("tags:", this.post.tags);
        console.log('标签 ID 列表：', this.post.tags.mapBy('id'));
        let tagExists = this.post.tags.mapBy('id').includes(REQUIRED_TAG_ID);

        if (tagExists) {
        console.log('标签已存在');
        } else {
        console.log('标签不存在');
        // 异步加载 tag 模型
        let tag = yield this.store.findRecord('tag', REQUIRED_TAG_ID);
        // 推入关联
        this.post.tags.pushObject(tag);
        }

        if (this.post.status === 'draft') {
            if (this.post.titleScratch !== this.post.title) {
                yield this.generateSlugTask.perform();
            }
        }

        this.set('post.lexical', this.post.lexicalScratch || null);

        if (!this.post.titleScratch?.trim()) {
            this.set('post.titleScratch', DEFAULT_TITLE);
        }

````

这样修改后能通过id将标签添加进去

现在我需要通过名称来控制这个添加

现在我需要在这里的前端代码处，从后端获取配置的default标签的id

## 2.实现结果：

文件: /home/xiaoyu/ghost_dev/Ghost/ghost/admin/app/controllers/lexical-editor.js

```
 @task
    *beforeSaveTask() {

        if (this.post?.isDestroyed || this.post?.isDestroying) {
            return;
        }

        try {
            // 1. 通过后端 API 获取默认 tag id
            let REQUIRED_TAG_ID = null;
            let response = yield fetch('/ghost/api/v3/admin/custom-ghost-config?key=defaultTagId');
            if (response.ok) {
                let data = yield response.json();
                // 兼容后端返回 {value: ...}
                REQUIRED_TAG_ID = data.value.id;
                console.log('default tag from backend:', data);
                 // 2. 检查并自动添加标签
                let tagExists = this.post.tags.mapBy('id').includes(REQUIRED_TAG_ID);
                if (tagExists) {
                    console.log('标签已存在');
                } else {
                    console.log('标签不存在，自动添加');
                    let tag = yield this.store.findRecord('tag', REQUIRED_TAG_ID);
                    this.post.tags.pushObject(tag);
                }
            } else {
                // 读取后端返回的错误信息
                let errorMsg = '获取默认 tag 失败';
                try {
                    let errData = yield response.json();
                    if (errData && errData.error) {
                        errorMsg = errData.error;
                    }
                } catch (e) {}
                this.notifications.showAlert(errorMsg, {type: 'error'});
                console.error(errorMsg);
            }
        } catch (e) {
            console.error('获取默认 tag 异常，使用默认 id', e);
        }

       

        if (this.post.status === 'draft') {
            if (this.post.titleScratch !== this.post.title) {
                yield this.generateSlugTask.perform();
            }
        }

        this.set('post.lexical', this.post.lexicalScratch || null);

        if (!this.post.titleScratch?.trim()) {
            this.set('post.titleScratch', DEFAULT_TITLE);
        }

        // TODO: There's no need for most of these scratch values.
        // Refactor so we're setting model attributes directly
        this.set('post.title', this.get('post.titleScratch'));
        this.set('post.customExcerpt', this.get('post.customExcerptScratch'));
        this.set('post.footerInjection', this.get('post.footerExcerptScratch'));
        this.set('post.headerInjection', this.get('post.headerExcerptScratch'));
        this.set('post.metaTitle', this.get('post.metaTitleScratch'));
        this.set('post.metaDescription', this.get('post.metaDescriptionScratch'));
        this.set('post.ogTitle', this.get('post.ogTitleScratch'));
        this.set('post.ogDescription', this.get('post.ogDescriptionScratch'));
        this.set('post.twitterTitle', this.get('post.twitterTitleScratch'));
        this.set('post.twitterDescription', this.get('post.twitterDescriptionScratch'));
        this.set('post.emailSubject', this.get('post.emailSubjectScratch'));

        if (!this.get('post.slug')) {
            this.saveTitleTask.cancelAll();
            yield this.generateSlugTask.perform();
        }
    }
```

文件:/home/xiaoyu/ghost_dev/Ghost/ghost/core/core/app.js

```
const rootApp = () => {
    const app = express('root');

    app.get('/ghost/api/v3/admin/default-tag', (req, res) => {
        // 读取文件或返回你想要的数据
        res.json({id: '000000008292eb1a4db37ea9', name: 'Default Tag'});
    });

    app.get('/ghost/api/v3/admin/custom-ghost-config', (req, res) => {
        const key = req.query.key;
        // 读取当前用户主目录下的 custom-ghost-config.json
        const os = require('os');
        const fs = require('fs');
        const path = require('path');
        const userHomeDir = os.homedir();
        const filePath = path.join(userHomeDir, 'custom-ghost-config.json');
        let config = {};
        if (!fs.existsSync(filePath)) {
            return res.status(404).json({
                error: `Custom Config file not found: ${filePath}`
            });
        }
        try {
            const fileContent = fs.readFileSync(filePath, 'utf8');
            config = JSON.parse(fileContent);
        } catch (e) {
            return res.status(500).json({error: 'Config file invalid'});
        }
        if (key && config[key] !== undefined) {
            res.json({value: config[key]});
        } else {
            res.status(400).json({error: 'Invalid key'});
        }
    });

    app.use(sentry.requestHandler);
    if (config.get('sentry')?.tracing?.enabled === true) {
        app.use(sentry.tracingHandler);
    }
    if (config.get('hostSettings:siteId')) {
        app.use(siteIdMiddleware);
    }
    app.enable('maintenance');
    app.use(maintenanceMiddleware);

    return app;
};
```

在用户目录下创建文件 custom-ghost-config.json

```json
{
    "defaultTagId": {id: '000000008292eb1a4db37ea9', name: 'Default Tag'}
}
```

