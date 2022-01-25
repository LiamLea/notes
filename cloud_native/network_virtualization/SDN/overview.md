# SDN(software definitied network)

[toc]

### 概述

#### 1.SDN架构
![](./imgs/overview_01.png)

* Southbound使用的协议：openflow

#### 2.与traditional network比较
![](./imgs/overview_02.png)

![](./imgs/overview_03.png)

* traditional network：
  * 每个device都有自己的控制平面，依靠自己的控制平面，决定路由等
  * 如果需要改配置，每个device都要改
* SDN：
  * 对网络进行抽象
  * 基于internet网络，有**统一的控制平面**
  * 能够控制edge device、cloud的virtual gateway
  * 在controller上进行配置，然后下发给各个device，不需要操作每台设备

#### 3.why need SDN
* 可以**路由cloud的流量**，然而传统网络不支持
* 配置更加简单方面，只需要在统一的控制平面进行配置，然后下发到各个edge device，传统的网络，需要一个个进行配置
* 基于SDN可以快速配置网络策略、路由等等（比如：能够快速建立VPN）
