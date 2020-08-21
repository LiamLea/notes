[toc]
### 插入操作（index some documents）

#### 1.插入一条记录
```shell
curl -H "Content-Type: application/json" \
-XPOST <IP>:<PORT>/<INDEX>/_doc/<ID> -d '<JSON>'
```

#### 2.批量插入
```shell
curl -H "Content-Type: application/json" \
-XPOST <IP>:<PORT>/<INDEX>/_bulk --data-binary "@<JSON_FILE>"
```
* `<JSON_FILE>`的格式
```json
{"index": {"_id": "1"}}
{"key1": "v1", "key2": "v2"}
{"index": {"_id": "6"}}
{"key1": "v1", "key2": "v2"}
```

***

### 查询操作

#### 1.index相关
##### （1）查询index的概述信息
```shell
curl <IP>:<PORT>/_cat/indices?v
```

##### （2）查询index的内容
```shell
curl <IP>:<PORT>/<INDEX>/_search?pretty&size=<NUMBER>
```
* 结果解析：
```json
{
  "took": 63,              //这次查询用了多久（毫秒）

  "timed_out": false,      //此次查看是否超时了

  "_shards": {             //此时查询分片的情况
    "total": 5,            //一共查询了5个分片
    "successful": 5,
    "skipped": 0,
    "failed": 0
  },

  "hits": {                //查询结果

    "total": {
        "value": 1000,      //查询到的documents的数量
        "relation": "eq"
    },

    "max_score": null,
    "hits": [               //每一个json是一个document
        {
        "_index": "bank",   //该document所属index
        "_type": "_doc",    
        "_id": "0",         //该document在index中的id   
        "_score": 1.0,      //该document相关性得分？？？

        //_source为该document的具体内容
        "_source": {"account_number":0,"balance":16623,"firstname":"Bradshaw","lastname":"Mckenzie","age":29,"gender":"F","address":"244 Columbus Place","employer":"Euron","email":"bradshawmckenzie@euron.com","city":"Hobucken","state":"CO"}    
      },
    ]
  }
}
```

#### 2.高级查询
##### （1）基本语法
```shell
curl -H "Content-Type: application/json" \
-XGET <IP>:<PORT>/<INDEX>/_search -d \
'{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ],
  "from": 10,
  "size": 10
}'

#sort对结果进行排序
#from、size就是从第10个结果开始向后的10个结果
```

##### （2）`query`
* 所有documents
```json
{
  "query": {"match_all": {}}
}
```

* `<KEY>`的value等于`<VALUE>`的documents
```json
{
  "query": { "match": { "<KEY>": "<VALUE>"}}
}
```

* `<KEY>`的value包含`<VALUE>`的documents
```json
{
  "query": {"match_phrase": {"<KEY>": "<VALUE>"}}
}
```

* 复合查询
```json
{
  "query": {
    "bool": {
      "must": [
        {"match": {"<KEY>": "<VALUE>"}},
      ],
      "must_not": [
        {"match": {"<KEY>": "<VALUE>"}}
      ]
    }
  }
}
```


#### 3.节点相关
##### （1）查看单个节点状态
```shell
curl IP:PORT/_cat/health
#查看分片的状态
curl IP:PORT/_cat/shards
```

#### 4.集群相关
###### （1）查看集群状态
```shell
curl IP:PORT/_cluster/health?level=indices
```
