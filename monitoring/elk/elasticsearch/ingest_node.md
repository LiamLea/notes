# ingest node

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ingest node](#ingest-node)
    - [概述](#概述)
      - [1.ingest node（摄取节点）](#1ingest-node摄取节点)
      - [2.与logstash区别](#2与logstash区别)
      - [3.pipeline](#3pipeline)
    - [操作](#操作)
      - [1.创建pipeline](#1创建pipeline)
      - [2.添加document时，使用指定pipeline](#2添加document时使用指定pipeline)
      - [3.index配置默认的pipeline](#3index配置默认的pipeline)
      - [4.设置最终pipeline（即最后一个执行的pipeline）](#4设置最终pipeline即最后一个执行的pipeline)

<!-- /code_chunk_output -->

### 概述

#### 1.ingest node（摄取节点）
* 是elasticsearch的一个功能
* 在index之前发生（ingest node会拦截index和bulk请求）
* 相当于一个简单的logstash
  * 在index文档之前，对文档进行清洗，清洗之后，再进行index

#### 2.与logstash区别
logstash功能更强大，可以输出到队列，从而缓冲数据
ingest node更加小巧方面

#### 3.pipeline
* 用于清洗数据
* 这里的pipeline是由多个processors组成
  * processors是具体的操作，比如重命名、添加字段等等
```json
{
  "description" : "...",
  "processors" : [ ... ]
}
```

***

### 操作

#### 1.创建pipeline
```python
PUT _ingest/pipeline/<PIPELINE_NAME>

{
  "description" : "describe pipeline",
  "processors" : [
    {
      "set" : {
        "field": "foo",
        "value": "new"
      }
    }
  ]
}
```

#### 2.添加document时，使用指定pipeline
```python
PUT <INDEX>/_doc/<ID>?pipeline=<PIPELINE_NAME>

{
  #document数据
}
```

#### 3.index配置默认的pipeline
需要在index的dynamic settings中添加`index.default_pipeline`配置

#### 4.设置最终pipeline（即最后一个执行的pipeline）
需要在index的dynamic settings中添加`index.final_pipeline`配置
