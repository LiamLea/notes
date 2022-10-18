# CAP

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [CAP](#cap)
    - [概述](#概述)
      - [1.CAP理论](#1cap理论)
        - [（1）consistency（一致性）](#1consistency一致性)
        - [（2）availability（可用性）](#2availability可用性)
        - [（3）partition tolerance（分区容错）](#3partition-tolerance分区容错)
      - [2.PACELC理论（对CAP的补充）](#2pacelc理论对cap的补充)
      - [3.raft是一个CP系统（即使允许部分node宕机）](#3raft是一个cp系统即使允许部分node宕机)

<!-- /code_chunk_output -->

### 概述

![](./imgs/CAP_01.png)

#### 1.CAP理论

无法同时满足，只能满足其中两项，分布式系统需要分区容错，所以一般就是CP或者AP

##### （1）consistency（一致性）
所有实例进行同步，保持数据一致
* 每一次读取，都是最近一次的写入或者错误（错误即代表服务不可用）

##### （2）availability（可用性）
能够访问服务（不一定要返回最近的数据，可以返回服务降级函数，比如："服务繁忙请稍后再试"）

##### （3）partition tolerance（分区容错）
系统部署在不同的网络环境中，当两个环境网络不通，需要考虑是否：
* 保持可用性（可能数据不一致）
* 保持一致性（在此期间无法使用）

#### 2.PACELC理论（对CAP的补充）

![](./imgs/CAP_02.png)

* 在有分区的情况下，必须在A和C中进行选择
* 在没有分区的情况下，需要在C和L（latency）中进行选择
  * 选择L: 放宽一致性的要求，减少延迟

#### 3.raft是一个CP系统（即使允许部分node宕机）
请求都会被转发到leader，所以保证了一致性
如果发生了网络分区，则follower无法访问leader，则无法获取数据，则没有可用性
