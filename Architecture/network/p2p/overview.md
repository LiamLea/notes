# peer to peer


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [peer to peer](#peer-to-peer)
    - [概述](#概述)
      - [1.几种方案](#1几种方案)
        - [(1) tracker](#1-tracker)
        - [(2) DHT (distributed hash table) 和 gossip protocol](#2-dht-distributed-hash-table-和-gossip-protocol)
      - [2.gossip protocol](#2gossip-protocol)
      - [3.DHT工作原理](#3dht工作原理)

<!-- /code_chunk_output -->

### 概述

#### 1.几种方案

##### (1) tracker
* tracker服务器记录所有peer的地址

##### (2) DHT (distributed hash table) 和 gossip protocol

* gossip protocol
  * 用于发现peer
* DHT
  * 根据文件的hash值，定为文件位置（即去哪些peer上去下载）
* 每个peer维护一部分DHT
    * 当需要查找某个节点（或数据时），peer先计算hash值，然后根据自己的DHT找到最近的节点
    * 下一个节点会查询自己的DHT，找到离自己最新的节点
    * 直到找到节点（或数据）
* 距离是逻辑距离，有特殊的算法
* 这样查找复杂度就是O(logn)

#### 2.gossip protocol

https://www.analyticssteps.com/blogs/gentle-introduction-gossip-protocol

#### 3.DHT工作原理

* 加入DHT网络
  * 首先与bootstrap peer交换信息，获取peer信息，然后与更多的peer交换信息
* locate（定位）
  * 根据文件中的hash信息、peer上的路由信息，找到相应的peer
  * 询问peer
    * 发DHT请求（key为文件的hash值）
    * peer收到请求后，查看key是否存在本地，返回离这个key最近的peer
  * 一直重复上述步骤，直至找到提供该文件的peer
* 定位到peer后
  * 可以存储key-value
    * key为文件的hash, value为node的id（即提供该文件的下载节点）
  * 可以获取key-value，从而进行下载