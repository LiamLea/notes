# enterprise WAN

[toc]

### 概述

![](./imgs/enterprise-WAN_01.png)

#### 1.enterprise WAN

##### （1） traditional network
* leased line（专线）
  * 是一个物理的**专用网络**
  * 成本高
* MPLS
  * 利用供应商的MPLS网络，会给数据包打上标签，然后运营商会根据该标签，将数据包发往指定的目的地
  * 成本较高
* internet-based VPN
  * 基于internet网络，创建隧道
  * 性能不够好

##### （2）SD-WAN（software defined WAN）
* 基于internet网络
* 有统一的控制平面，能够控制edge device、cloud的virtual gateway
* 可以基于SD-WAN实现VPN
