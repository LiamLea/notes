
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [插入操作（index some documents）](#插入操作index-some-documents)
  - [1.插入一条记录](#1插入一条记录)
  - [2.批量插入](#2批量插入)
- [查询操作](#查询操作)
  - [1.index相关](#1index相关)
    - [（1）查询index的概述信息](#1查询index的概述信息)
    - [（2）查询index的内容](#2查询index的内容)
    - [（3）curl格式](#3curl格式)
  - [2.查询语法](#2查询语法)
    - [（1）基本格式](#1基本格式)
    - [（2）query中的语法](#2query中的语法)
    - [（3）查询nested类型数据](#3查询nested类型数据)
  - [3.集群相关](#3集群相关)
    - [(1) 查看集群状态](#1-查看集群状态)
- [其他操作](#其他操作)
  - [1.重新索引（把一个index的documents 拷贝到 另一个index）](#1重新索引把一个index的documents-拷贝到-另一个index)

<!-- /code_chunk_output -->

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

##### （3）curl格式
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
```

#### 2.查询语法
```shell
GET /<index>/_search
```
##### （1）基本格式

```json
{
	"size": 10,
	"query": {}
}

//常用字段:
//  size: 获取多少个数据
//  sort: 对结果进行排序
//  from: 从第几个document开始查
```

##### （2）query中的语法
[参考](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/query-dsl.html)

* `match_all`
  * 所有documents
    ```json
    {
      "query": {"match_all": {}}
    }
    ```

* 查询关键词（无顺序）: `match`
  * 查询 `字段<key>的值 包含 <v1>或者<v2>`
    ```json
    {
        "query": {
            "match": {
                "<key>": "<v1> <v2>",
                "operator": "or"
            }
        }
    }
    ```

* 查询关键词（有顺序）: `match_phrase`
  * 查询 `字段<key>的值 包含 "<v1> <v2>"这种格式的词组`
    ```json
    {
        "query": {
            "match_phrase": {
                "<key>": "<v1> <v2>",
            }
        }
    }
    ```

* 查询某个字段的范围（比如时间戳）: `range`
  * 查询近30min的结果
    ```json
    {
        "query": {
            "range": {
                "@timestamp": {
                    "gte": "now-30m"
                }
            }
        }
    }
    ```

  * 使用正则表达式: `regexp`
  ```json
  {
    "query": {
      "regexp": {
        "user.id": {
          "value": "k.*y",
          "flags": "ALL",
          "case_insensitive": true,
          "max_determinized_states": 10000,
          "rewrite": "constant_score"
        }
      }
    }
  }
  ```

* 复合查询（有多个查询语句）: `bool`
  * must (==and)
  * should (==or)
  * 查询近30min内, message字段的值 包含 "similar"和"error"这两个内容
  ```json
  {
      "query": {
          "bool": {
              "must": [
                  {
                      "match": {
                          "message": {
                              "query": "similar error",
                              "operator": "and"
                          }
                      }
                  },
                  {
                      "range": {
                          "@timestamp": {
                              "gte": "now-30m"
                          }
                      }
                  }
              ]
          }
      }
  }
  ```

##### （3）查询nested类型数据
```json
{
  "query": {
      "nested": {
        "path": "system.process",
        "query": {
            "match": { "system.process.pid": "3077"}
        }
      }
    }
}
```

#### 3.集群相关

##### (1) 查看集群状态
```shell
curl IP:PORT/_cluster/health?pretty

#查看分片的状态
curl IP:PORT/_cat/shards

#查看index
curl IP:PORT/_cluster/health?level=indices
```

***

### 其他操作

#### 1.重新索引（把一个index的documents 拷贝到 另一个index）
```python
POST _reindex
{
  "source": {
    "index": "<OLD_INDEX_NAME>"
  },
  "dest": {
    "index": "<NEW_INDEX_NAME>  "
  }
}
```
