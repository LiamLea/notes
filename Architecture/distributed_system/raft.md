# raft


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [raft](#raft)
    - [概述](#概述)
      - [1.节点有三种状态](#1节点有三种状态)
      - [2.领导选举](#2领导选举)
        - [（1）follower -> candidate](#1follower-candidate)
        - [（2）candidate -> leader](#2candidate-leader)
        - [（3）leader](#3leader)
      - [3.一致性](#3一致性)
      - [4.网络分区](#4网络分区)

<!-- /code_chunk_output -->

### 概述

#### 1.节点有三种状态

|state|description|condition|
|-|-|-|
|follower|跟随leader的状态|刚开始或者存在leader时，其他节点都处于follwer状态|
|candidate|竞选leader的状态|当节点未发现leader时，则切换成candidate状态|
|leader|所有的修改操作都必须经过leader（从而保证了一致性）||

#### 2.领导选举

##### （1）follower -> candidate

* follower在一定时间内（该时间是150ms~300ms中**随机**的）未发现leader
  * 时间随机的原因：防止同时成为candidate，无法选举出leader
* 则切换成candidate状态

##### （2）candidate -> leader
* 节点状态变为candidate后，第一票首先投给自己
* 然后会向其他节点发送请求（拉取选票)
* 如果获取超过一半的回复（即选票），则当选leader

##### （3）leader
* 成为leader后，会不断向其他节点发送心跳检查

#### 3.一致性
所有修改操作都经过leader
* leader接收修改请求后，先记录在WAL中，而没有commit
* 将WAL拷贝到其他节点，其他节点也还没有commit
  * 当大部分节点收到了该WAL，则leader进行commit
    * 然后通知其他节点，其他节点才会commit

#### 4.网络分区
网络分区，由于只有可能有一个分区的leader的选票过半，所以只有可能有一个分区工作，，其他分区都不会工作
