# config


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [config](#config)
    - [常用配置](#常用配置)
      - [1.资源设置](#1资源设置)
        - [(1) executor静态分配](#1-executor静态分配)
        - [(2) executor动态分配](#2-executor动态分配)
      - [2.hadoop客户端配置](#2hadoop客户端配置)
      - [3.分区数](#3分区数)
      - [4.性能优化](#4性能优化)

<!-- /code_chunk_output -->


### 常用配置

[参考](https://spark.apache.org/docs/latest/configuration.html)

#### 1.资源设置

[参考](https://medium.com/analytics-vidhya/understanding-resource-allocation-configurations-for-a-spark-application-9c1307e6b5e3)

##### (1) executor静态分配

|配置|默认值|建议值|说明|
|-|-|-|-|
|--executor-cores|1|5|一个executor的cpu数|
|--executor-memory|1G||一个executor的内存|
|--num-executors|2||executor的数量|

##### (2) executor动态分配
|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.dynamicAllocation.enabled|false||开启executor的动态分配|
|spark.dynamicAllocation.schedulerBacklogTimeout|1s||如果有pending tasks持续了这么长时间，则就会申请新的executor|

#### 2.hadoop客户端配置

|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.hadoop.dfs.client.use.datanode.hostname|false|true|使用hostname连接hdfs|
|spark.hadoop.mapreduce.input.fileinputformat.input.dir.recursive|false|true|可以迭代读取某个目录下的文件|

#### 3.分区数

|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.default.parallelism|根据系统情况设置|cpu的5倍左右|用于设置task的并行数（也就是分区数），如果用户没有特别指定，使用这里的值|
|spark.sql.shuffle.partitions|200|总的核心数的2-5倍|join或aggregation，进行数据shuffle时，使用的分区数|

#### 4.性能优化

|配置|默认值|建议值|说明|
|-|-|-|-|
|spark.sql.adaptive.enabled|true|true|程序运行时，对分区数等进行优化|