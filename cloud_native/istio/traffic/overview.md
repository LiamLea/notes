# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.service registry](#1service-registry)
        - [（1）生成service registry](#1生成service-registry)
        - [（2）利用service registry配置envoy](#2利用service-registry配置envoy)
      - [2.流量处理流程](#2流量处理流程)
      - [3.unknown 和 passthroughcluster 和 BlackHole](#3unknown-和-passthroughcluster-和-blackhole)

<!-- /code_chunk_output -->

### 概述

![](./imgs/traffic_management_01.png)

#### 1.service registry

##### （1）生成service registry
* 自动发现
  * 通过调用k8s接口，发现如下内容：
    * service 即k8s的service
    * endpoint 即k8s中的endpoints中的endpoint
      * 并且会根据endpoint对应的**pod的labels**，**作为这个endpoint的labels**

* 静态添加
  * 通过ServiceEntry在service registry中添加

##### （2）利用service registry配置envoy

|通过service registry生成的envoy的配置项|说明|
|-|-|
|envoy的listener和route（即filter）|根据service、endpoint、pod等信息生成|
|envoy的cluster|命名规则：`<DIRECTION>|<PORT>|<SUBSET>|<SERVICE_FQDN>`|

#### 2.流量处理流程

* VirtualService
  * 即envoy的route（即filter）
  * 匹配条件后，发往指定的DestinationRule
* DestinationRule
  * 即envoy的cluster
  * 转发到endpoints


#### 3.unknown 和 passthroughcluster 和 BlackHole
* 当不知道的外部流量进来时，则标识来源为**unknown**
* 当流量发往外部不知道的服务时，则标记为目的为**passthroughcluster** 或者 **blackholw**
当允许流量外出时，为**passthroughcluster**
当不允许流量外出时，为**blackhole**
