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
