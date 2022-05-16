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

***

### ip transparency

#### 1.layer 4：ip transparency

##### （1）DR模式
* 真实的服务器需要做额外的设置（参考LVS的DR模式）
![](./imgs/overview_01.png)

##### （2）NAT模式
* 关键点：真实服务器的网关必须设为LB，这样确保所有流量都经过LB，从而能够进行地址的映射（参考nginx的proxy_bind模式）
![](./imgs/overview_02.png)

#### 2.layer 7: 在http头中添加源客户端的信息

##### (1)  X-Forwarded-For headers

#### 3.通用方式：proxy protocol
* 参考nginx的proxy protocol
