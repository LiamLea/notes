# ip（internet protocol）

[toc]

### 概述

#### 1.ip报头
![](./imgs/ip_01.png)

##### （1）TTL（time to live）
每个ip都有一个TTL，每经过一个路由，TTL-1，当TTL=0时，ip包就会被丢弃（防止ip包被无限传播）
可以`ping <IP> -t <TTL>`，用设置的TTL减去返回的TTL，就能知道经过了多少路由

##### （2）protocol
协议号，用于标识封装的是什么协议
比如：
  * 4 IP中的IP（封装）
  * 6 TCP协议
  * 17 UDP协议
