[toc]
### 预备知识
#### 1.sidecar模式
边车部署模式，一个单节点有两个容器组成，一个是应用容器，一个是配件容器，配件容器**共享**应用容器的**资源**和**生命周期**，即配件容器不能单独存活
>这里指的是把一个**微服务**和一个**proxy**部署在一起  

#### 2.通信架构
* data plane
所有用于**转发流量**的功能和过程
<br/>
* control plane
所有用于**确定如何转发**（比如选择哪条路径等）的功能和过程
<br/>
* management plane
所有用于**控制设备（即配置控制平面）和监控设备**(比如CLI，snmp等)的功能
***
### 基础概念
#### 1.核心功能
* traffic management
依赖以sidecar模式部署envoy，所有流量由envoy转发
无需对服务做任何更改
<br/>
* security
* observability

#### 2.整体架构
![](./imgs/overview_01.png)

#### 3.traffic management
istio维护了一个内部的服务注册表
该表是 service和其endpoint 的集合
表中的内容是由 pilot组成 自动发现生成的
