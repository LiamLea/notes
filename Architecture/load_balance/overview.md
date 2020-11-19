# Load_balance

[toc]


### 概述

#### 1.常用调度算法

##### （1）rr（roundrobin）
问题:某些服务器的连接已经断开,有些没断开,依旧轮询,没断开的压力会更大

##### （2）wrr（weighted roundrobin）
这个可以设置权重

##### （3）sh（source hashing）
相当于ip_hash

##### （4）lc（least connections）
根据 服务器当前的连接情况 进行负载均衡

##### （5）wlc（weighted least connections）
根据 服务器当前的连接情况 和 权重 进行负载均衡
