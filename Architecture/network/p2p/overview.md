# peer to peer


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [peer to peer](#peer-to-peer)
    - [概述](#概述)
      - [1.几种方案](#1几种方案)
        - [(1) tracker](#1-tracker)
        - [(2) DHT (distributed hash table) 和 gossip protocol](#2-dht-distributed-hash-table-和-gossip-protocol)
      - [2.gossip protocol](#2gossip-protocol)

<!-- /code_chunk_output -->

### 概述

#### 1.几种方案

##### (1) tracker
* tracker服务器记录所有peer的地址

##### (2) DHT (distributed hash table) 和 gossip protocol

* 每个peer维护一部分DHT
    * 当需要查找某个节点（或数据时），peer先计算hash值，然后根据自己的DHT找到最近的节点
    * 下一个节点会查询自己的DHT，找到离自己最新的节点
    * 直到找到节点（或数据）
* 距离是逻辑距离，有特殊的算法
* 这样查找复杂度就是O(logn)

#### 2.gossip protocol

https://www.analyticssteps.com/blogs/gentle-introduction-gossip-protocol