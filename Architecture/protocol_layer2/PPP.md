# PPP（point-to-point protocol）
[toc]

### 概述

#### 1.PPP有3个组成
从下到上
* HDLC（high-level data link control，高级数据链路控制协议）
* LCP（link control protocol，链路控制协议）
负责认证相关
* NCP（network control protocol，网络控制协议）
用于控制网络层协议

#### 2.主要功能
* connection authentication
* transmission encryption
* compression

#### 3.PPPOE（point-to-point over ethernet）
现在PPP已经淘汰，使用的基本都是PPPOE
* 因为PPP使用的点对点信道，一个线路上，只能连接一对机器，不能连接多个，所以成本太高
