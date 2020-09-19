# VPN
[toc]

### 概述

#### 1.VPN（virtual private network）
* 在公共网络上建立 **tunnel**（隧道），为了通信的 **安全**（可以避免数据在经过其它路由时被窃取）
  * 仿佛在一个局域网内
* 是**client-server**架构（相应的vpn client只能连接相应的vpn server）

#### 2.tunneling（隧道）
将数据包封装在其他数据包中，称为隧道

#### 2.特点
* private不代表数据就是私有和安全的，只是指虚拟网络的拓扑（即tunnel）
* 数据的私密性和安全性，由不同的VPN协议提供
  * 所以，可以创建数据不安全的VPN连接
* 当tunnel检测到有渗透时（比如 数据包大量丢失时），会根据重新选择路线建立tunnel（双方中间有多个路由，所以有多种路线）

#### 3.原理
* vpn遵循 **routing**、**bridging** 和 **encapsulation** 的原则
* routing
  * 会在客户端创建一个虚拟网络接口，服务端会给这个 接口 分配ip地址，Layer 3 VPN 会添加新的路由
* bridging
  * Layer 2 VPN就行两个相连的物理设备
* encapsulation

#### 4.VPN工作在两层
layer2：bridged vpn，会虚拟出tap设备，使用ppp协议
layer3：routed vpn，会虚拟出tun设备

#### 4.封装协议
##### （1）GRE（generic routing encapsulation）

#### 2.常用VPN类型
L2TP、PPTP、IPSEC

##### （2）PPTP（point to point tunneling protocol）
利用TCP协议

##### （3）L2TP（layer 2 tunneling protocol）

##### （4）IPSec（internet protocol security）
