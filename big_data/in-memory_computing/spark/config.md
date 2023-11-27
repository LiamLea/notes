# config


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [config](#config)
    - [常用配置](#常用配置)
      - [1.提交配置](#1提交配置)
      - [2.hadoop客户端配置](#2hadoop客户端配置)
      - [3.分区数](#3分区数)

<!-- /code_chunk_output -->


### 常用配置

[参考](https://spark.apache.org/docs/latest/configuration.html)

#### 1.提交配置

|配置|默认值|建议值|说明|
|-|-|-|-|
|--num-executors|2|work node的数量||
|--executor-cores|1|一个executor的cpu数||
|--executor-memory|1G|一个executor的内存||

#### 2.hadoop客户端配置

|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.hadoop.dfs.client.use.datanode.hostname|false|true|使用hostname连接hdfs|
|spark.hadoop.mapreduce.input.fileinputformat.input.dir.recursive|false|true|可以迭代读取某个目录下的文件|

#### 3.分区数

|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.default.parallelism|根据系统情况设置|cpu的5倍左右|用于设置task的并行数（也就是分区数），如果用户没有特别指定，使用这里的值|