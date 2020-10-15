# settings

[toc]

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
