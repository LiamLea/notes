# mapping
[toc]
### 概述

#### 1.特点
mapping定义了document如何被索引和存储的
* 字段的类型

#### 2.mapping包括两部分
* meta-fields
比如：`_index`，`_id`，`_source`
* fields or properties

#### 3.简单的数据类型
text
用于全文本搜索
keyword
用于排序和聚合
date
long
double
boolean
ip

#### 4.明确指定mappings
* 创建index时指定
```python
PUT /my-index
{
  "mappings": {
    "properties": {
      "age":    { "type": "integer" },  
      "email":  { "type": "keyword"  },
      "name":   { "type": "text"  }     
    }
  }
}
```
* 添加filed到已存在的index中
```python
PUT /my-index/_mapping
{
  "properties": {
    "employee-id": {
      "type": "keyword",
      "index": false
    }
  }
}
```

* 更新一个field的mapping
不能直接更新。这样会导致index失效
正确的做法是，重新创建一个索引，然后将旧数据重新索引到新的index中
