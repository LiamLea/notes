# settings

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [settings](#settings)
    - [概述](#概述)
      - [1.有两类settigs](#1有两类settigs)
      - [2.常用配置](#2常用配置)
        - [（1）static settings](#1static-settings)
        - [（2）dynamic settings](#2dynamic-settings)

<!-- /code_chunk_output -->

### 概述

#### 1.有两类settigs
* static
只能 在创建index时 或者 在关闭index后 设置
* dynamic
利用api可以设置

#### 2.常用配置

##### （1）static settings
```json
"settings" : {
  "index" : {
    "number_of_shards": "<NUM>", //设置 主分片 数量
  }
}
```

##### （2）dynamic settings
```json
"settings" : {
  "index" : {
    "number_of_replicas": "<NUM>", //设置 备份分片 数量
  }
}
```
