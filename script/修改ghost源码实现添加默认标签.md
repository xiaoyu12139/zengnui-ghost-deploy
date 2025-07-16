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