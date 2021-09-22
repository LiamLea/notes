# overview

[toc]

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

#### 3.基础概念

##### （1）failure domain（故障域）
一个故障域，就是其中某个资源出现问题，会相互影响
不同的故障域，资源是相互独立的，不会影响到对方

##### （2）zone vs region
zone是部署区域，一个zone是一个故障域
region是地理区域，由地理位置靠近的zone组成，一个region也是一个故障域（防止某地因为发生自然灾害，导致该地区的服务不可用）
![](./imgs/overview_02.png)
