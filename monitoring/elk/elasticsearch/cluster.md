# cluster

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [cluster](#cluster)
    - [概述](#概述)
      - [1.集群状态及解决](#1集群状态及解决)
        - [（1）集群状态为red](#1集群状态为red)
        - [（2）集群状态为yellow](#2集群状态为yellow)
        - [（3）解决思路：](#3解决思路)

<!-- /code_chunk_output -->

### 概述

#### 1.集群状态及解决

##### （1）集群状态为red
red表示**不是**所有的**主分片**都可用，通常时由于某个索引的主分片为分片unassigned，只要找出这个索引的分片，手工分配即可

##### （2）集群状态为yellow
yellow表示所有**主分片**可用，但**不是**所有**副本分片**都可用，最常见的情景是单节点时，由于es默认是有1个副本，主分片和副本不能在同一个节点上，所以副本就是未分配unassigned

##### （3）解决思路：
* 先找出有问题的indices和nodes
```shell
curl IP:PORT/_cluster/health?level=indices
curl IP:POTT/_cat/health    #一个个试
```
* 然后查看该节点上哪一个分片是unassigned
```shell
curl IP:PORT/_cat/shards
```
