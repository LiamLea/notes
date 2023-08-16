# ip（internet protocol）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ip（internet protocol）](#ipinternet-protocol)
    - [概述](#概述)
      - [1.ip报头](#1ip报头)
        - [（1）TTL（time to live）](#1ttltime-to-live)
        - [（2）protocol](#2protocol)
      - [2.reachalibity scopes (可达域)](#2reachalibity-scopes-可达域)
        - [(1) node-local](#1-node-local)
        - [(2) link-local](#2-link-local)
        - [(3) global](#3-global)
      - [3.ipv6](#3ipv6)
        - [(1) 表示](#1-表示)
        - [(2) prefix](#2-prefix)
        - [(3) scope id](#3-scope-id)
    - [ipv4保留地址](#ipv4保留地址)

<!-- /code_chunk_output -->

### 概述

#### 1.ip报头
![](./imgs/ip_01.png)

##### （1）TTL（time to live）
每个ip都有一个TTL，每经过一个路由，TTL-1，当TTL=0时，ip包就会被丢弃（防止ip包被无限传播）
可以`ping <IP> -t <TTL>`，用设置的TTL减去返回的TTL，就能知道经过了多少路由

##### （2）protocol
协议号，用于标识封装的是什么协议
比如：
  * 4 IP-in-IP协议
  * 6 TCP协议
  * 17 UDP协议


#### 2.reachalibity scopes (可达域)

##### (1) node-local
* 本地
  * 即数据包不会发往link和router
  * 比如: `127.0.0.1/8`、`::1/128`等

##### (2) link-local

* 同一链路上的机器
  * 即数据包不会发往router、
  * 比如:
    * ipv4: 未指定ip，会用`169.254.0.0/16`这个地址段进行链路上的通信
    * ipv6: 以`fe80`开头的地址

##### (3) global

* 全局

#### 3.ipv6

##### (1) 表示

* 一共128 bit，每16 bit为一组 (8组)，每组用4个16进制数表示
  * 形如: `21DA:00D3:0000:2F3B:02AA:00FF:FE28:9C5A`

* 当多个连续的组都是0时，可以进行**压缩**（压缩成`::`），只能压缩**一次**
  * 比如: `FF02:0:0:0:0:0:0:2`压缩成`FF02::2`

##### (2) prefix
* 跟ipv4的prefix一样，用于标识网段
* ipv6没有subnet mask

##### (3) scope id

* `<ipv6>%<scope_id>`
* 在**link-local**域时，需要指定，用于标识该ipv6地址属于哪个网卡的link-local
  * 如果不指定，当有多个网卡时，每个网卡都有自己的link-local address，会产生歧义

***

### ipv4保留地址

|地址块|地址范围|用于范围|用途|
|-|-|-|-|
|127.0.0.0/8|全范围|Host|环路地址|
|224.0.0.0/4|全范围|Internet|组播地址|
|10.0.0.0/8|全范围|Private Network|私有网络内通信|
|172.16.0.0/12|全范围（172.16.0.0–172.31.255.255）|Private Network|私有网络内通信|
|192.168.0.0/24|全范围|Private Network|私有网络内通信|
|169.254.0.0/16|全范围|Subnet|链路地址（用于没有ip时，同一链路上的主机能够设置链路地址，进行通信）|

[更多参考](https://en.wikipedia.org/wiki/Reserved_IP_addresses)
