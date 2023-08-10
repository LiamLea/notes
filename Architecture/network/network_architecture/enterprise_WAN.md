# enterprise WAN

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [enterprise WAN](#enterprise-wan)
    - [概述](#概述)
      - [1.enterprise WAN](#1enterprise-wan)
        - [（1） traditional network](#1-traditional-network)
        - [（2）SD-WAN（software defined WAN）](#2sd-wansoftware-defined-wan)
      - [2.接入运营商MPLS网络](#2接入运营商mpls网络)
        - [（1）Access layer（接入层）: CE(customer edge) router](#1access-layer接入层-cecustomer-edge-router)
        - [（2）Distribution layer（分发层/汇聚层）: PE(provider edge) router](#2distribution-layer分发层汇聚层-peprovider-edge-router)
        - [（3）Core layer（核心层）: P(provider) router](#3core-layer核心层-pprovider-router)

<!-- /code_chunk_output -->

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

#### 2.接入运营商MPLS网络

##### （1）Access layer（接入层）: CE(customer edge) router
本地所有流量通过CE router外出，接入到PE router
CE设备特点：接口类型丰富，数据量不大

##### （2）Distribution layer（分发层/汇聚层）: PE(provider edge) router
连接不同运行商的网络
PE设备特点：汇聚、封装/解封装能力强

##### （3）Core layer（核心层）: P(provider) router
根据标签进行路由
P设备: 强大的交换能力
