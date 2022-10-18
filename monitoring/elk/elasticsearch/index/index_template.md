# 索引模板

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [索引模板](#索引模板)
    - [概述](#概述)
      - [1.index template](#1index-template)
      - [2.两种template](#2两种template)
        - [（1）component template（7.8版本之后才有）](#1component-template78版本之后才有)
        - [（2）index template](#2index-template)
    - [操作](#操作)
      - [1.查看index template](#1查看index-template)

<!-- /code_chunk_output -->

### 概述

#### 1.index template
告诉es 当创建index时，如何配置settings、mapping等（比如会创建mapping，该mapping中定义好了字段，如果index中没有相应字段，但是创建mapping时还是会定义该字段）

#### 2.两种template

##### （1）component template（7.8版本之后才有）
用于建立一个小的template，这个template可以复用，用来组建index template
```json
{
  "template": {
    "mappings": {}
  }
}
```

##### （2）index template
```json
{
  //用于指定该template应用于哪些index，可以使用通配符
  "index_patterns": ["te*", "bar*"],    

  //设置该template优先级，当匹配多个template时，使用优先级高的
  "priority": 200,

  //指定使用哪些component template（7.8版本后）
  "composed_of": ["component_template1", "other_component_template"],


  "template": {
    "settings": {},   //设置settings
    "mappings": {}    //设置mappings
  }
}
```

***

### 操作

#### 1.查看index template
* 7.8版本以前
```python
GET /_template
```

* 7.8版本以后
```python
GET /_component_template
GET /_index_template
```
