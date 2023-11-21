# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.数据并行化 (Data-Level Parallelism)](#1数据并行化-data-level-parallelism)
        - [(1) why](#1-why)
        - [(2) 挑战](#2-挑战)
        - [(3) 适用场景](#3-适用场景)
      - [2.ETL](#2etl)

<!-- /code_chunk_output -->

### 概述

#### 1.数据并行化 (Data-Level Parallelism)

基于divide-and-conquer策略

##### (1) why

* 计算量大
  * 单进程算的不够快，多cpu算
* 内存需求大
  * 单机内存不够大
  * 内存随即访问比硬盘随即访问快100,000倍
* I/O量大
  * 单个硬盘读写太慢，多个硬盘读写

##### (2) 挑战
* 编程困难
  * 并行性识别与表达，难写
  * 同步语句，难写对
* 性能调优难
  * 负载均衡
  * 局部性（利用缓存）
* 容错难

##### (3) 适用场景

* 数据并行并不适合所有类型的数据，当数据满足以下条件是才适合使用数据并行方式:
    * 数据能够切分且是独立的
    * 操作必须是确定性的和幂等的

#### 2.ETL

* E: extract
  * 提取数据

* T: transform
  * 清洗数据（对数据格式等进行转换）

* L: load
  * 将清洗后的数据重新加载  