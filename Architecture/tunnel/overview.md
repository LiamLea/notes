# tunnel

[toc]

### 概述

#### 1.NAT对tunnel的影响

##### （1）改变ip和tcp headers
* 会对checksum等字段产生影响（可以disable checksum解决）
* 对某些协议产生影响，比如有些协议只接收设置好的ip（比如vxlan，gre、IPIP等）

##### （2）对于加密的tunnel，无法实现nat映射
* 因为NAT需要根据 源ip + 上层协议的状态（比如端口、icmp中的id），添加映射记录（可以通过路由器的passthrough功能解决）

#### 2.解决nat的问题

##### （1）解决问题1：NAT traversal
下面只是某一种NAT traversal
tunnel封装后，用udp再封装一层，到了endpoint后，先解封装，然后处理tunnel的封装

##### （2）解决问题2：passthrough
是路由器（只要转发流量都叫路由器）的一个功能，如果没有这个功能，使用NAT的路由器无法转发VPN流量
* 由于PPTP会加密网络层协议，导致NAT没有办法创建映射记录
  * 因为NAT需要根据 源ip + 上层协议的状态（比如端口、icmp中的id），添加映射记录

* passthrough 利用 源ip + gre中的call id，添加映射记录
