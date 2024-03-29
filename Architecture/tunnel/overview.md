# tunnel

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [tunnel](#tunnel)
    - [概述](#概述)
      - [1.NAT对tunnel的影响](#1nat对tunnel的影响)
        - [（1）改变ip和tcp headers](#1改变ip和tcp-headers)
        - [（2）对于加密的tunnel，无法实现nat映射](#2对于加密的tunnel无法实现nat映射)
      - [2.解决nat的问题](#2解决nat的问题)
        - [（1）解决问题1：NAT traversal](#1解决问题1nat-traversal)
        - [（2）解决问题2：VPN passthrough](#2解决问题2vpn-passthrough)
      - [3.数据到达VPN server后](#3数据到达vpn-server后)

<!-- /code_chunk_output -->

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

##### （2）解决问题2：VPN passthrough
是路由器（只要转发流量都叫路由器）的一个功能，如果没有这个功能，使用NAT的路由器无法转发VPN流量
* 由于PPTP会加密网络层协议，导致NAT没有办法创建映射记录
  * 因为NAT需要根据 源ip + 上层协议的状态（比如端口、icmp中的id），添加映射记录

* passthrough 利用 源ip + gre中的call id，添加映射记录

#### 3.数据到达VPN server后

会将数据**路由**到目标地址，并且进行**SNAT**（保证数据能回到VPN server）
