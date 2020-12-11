# ICMP（internet control message protocol）

[toc]

### 概述

#### 1.特点
* 为了提高IP数据包交付成功的机会
* 允许网络设备报告差错情况

#### 2.ICMP报文分类

##### （1）ICMP询问报文
* Echo Request（echo回复）
* Echo Reply（echo请求）
* Timestamp（时间戳请求）
* Timestamp Reply（时间戳回复）

##### （2）差错报告报文
* Destination Unreachable（终点不可达）
* Source Quench（源点抑制）
* Time Exceeded（时间超时）
* Parameter Problem: Bad IP header（参数问题）
* Redirect Message（改变路由，重定向）
  * 告诉源主机可以选择更好的一条路由
  * 比如：3.1.5.19将默认路由设为3.1.5.20，而3.1.5.20的默认路由为3.1.5.254，所以3.1.5.19机器ping 114.114.114.114，就会收到重定向到3.1.5.254这个主机的信息
