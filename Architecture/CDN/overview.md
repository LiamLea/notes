# CDN


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [CDN](#cdn)
    - [概述](#概述)
      - [1.CDN（content delivery network）](#1cdncontent-delivery-network)
      - [2.GSLB（globa server load balancer）](#2gslbgloba-server-load-balancer)
      - [3.两种技术实现CDN](#3两种技术实现cdn)
        - [(1) DNS](#1-dns)
        - [(2) anycast](#2-anycast)
        - [(3) 比较](#3-比较)

<!-- /code_chunk_output -->


### 概述

#### 1.CDN（content delivery network）
在地理上分散的服务器，一起工作提供internet内容快速发部的能力

#### 2.GSLB（globa server load balancer）
http://www.tenereillo.com/GSLBPageOfShame.htm
用于给 分散在多个地理位置的服务器 分配流量

#### 3.两种技术实现CDN

##### (1) DNS
根据客户端ip（因为ip能反映出地理位置），然后返回相应的ip给客户端

##### (2) anycast
多个缓存服务器拥有相同的public ip，然后根据路由选择最新的缓存服务器

##### (3) 比较

|DNS|anycast|
|-|-|
||性能更好一点|
|需要有健康检查才能有更好的冗余性|冗余性更好|
|能够制定特定的分发策略||
||能更好的缓解DDoS攻击（因为如果其中一个缓存服务器宕机，可以继续路由到其他缓存服务器）|
