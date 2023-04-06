# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.分类](#1分类)
        - [（1）按照提供的服务分类](#1按照提供的服务分类)
        - [（2）按照部署的方式分类](#2按照部署的方式分类)
      - [2.hybrid cloud](#2hybrid-cloud)
        - [（1）混合云中可以包含哪些环境](#1混合云中可以包含哪些环境)
        - [（2）不同环境如何进行通信](#2不同环境如何进行通信)

<!-- /code_chunk_output -->

### 概述

#### 1.分类

##### （1）按照提供的服务分类
|类型|说明|
|-|-|
|IaaS（infrastructure as a service）|提供基础设施，比如：存储、服务器等）|
|PaaS（platform as a service）|提供平台|
|SaaS（software as a service）|提供软件|
|FaaS（function as a service）|也称为serverless，也称为事件驱动计算，动态分配资源来运行单个功能（本质上是微服务）|

##### （2）按照部署的方式分类
|类型|说明|使用场景|
|-|-|-|
|public cloud|被多个组织共享的云环境|
|private cloud|给专门组织使用的云环境|
|VPC（virtual private cloud）|虚拟私有云，托管在公有云上的私有云（就是在公有云上实现**逻辑隔离**）|
|Hybrid cloud|混合云，多种云的混合并紧密联系在一起（比如私有云和共有混合）|1.私有云提供某些服务，公有云提供某些服务</br>2.公有云作为私有云的备份</br>3.用公有云处理高需要时段，大多数操作保留在私有云中|
|multicloud|多云，使用多个公有云环境|
|专有云|私有化部署的公有云|

* 混合云与多云的区别
![](./imgs/overview_01.png)

#### 2.hybrid cloud

##### （1）混合云中可以包含哪些环境
* public cloud
* on-premises private cloud（本地私有云）
* hosted private cloud（托管私有云，即VPC）
* on-premises（legacy，部署采用云技术的方式）

##### （2）不同环境如何进行通信
* API
* VPN
* WAN