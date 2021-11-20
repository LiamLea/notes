### 概述

![](./imgs/network_01.png)
#### 1.网络基于ovs（openvswitch）

1.br-ex（external）
只在network node上，用于连接外部网络，会与一个混杂模式的网卡绑定，作为外出的出口

2.br-int（integration)
集成网桥，每个compute-node上都有一个，该节点的vm都连接到该虚拟机上
所有 instance 的虚拟网卡和其他虚拟网络设备都将连接到该网桥

3.br-tun（tunnel）
  隧道网桥，基于隧道技术的 VxLAN 和 GRE 网络将使用该网桥进行通信
  能够实现跨节点通信

#### 2.ovs虚拟交换机
通过ovs创建的虚拟交换机机，用linux自带命令查不出有用信息，而且看起来都是down的
因为所有的功能都是通过ovs这个软件实现的 ，所以需要通过ovs客户端去查看相关信息

#### 3.网络的组成

##### （1）external（provider）networks
供应商网络，用于连接公网

##### （2）project（tenant）networks
租户网络，每个租户之间的网络是隔离的

##### （3）routers
路由器，用于串通这些网络，比如使得某个租户网络能够连接外网，需要在他们之间加一个路由器


#### 4.network type

|网络类型|说明|
|-|-|
|flat|不能进行网络隔离等，通常用于external网络|
|vxlan|可以对网络进行隔离等，通常用于租户网络|
