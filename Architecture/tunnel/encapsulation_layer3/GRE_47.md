# GRE

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [GRE](#gre)
    - [概述](#概述)
      - [1.GRE](#1gre)
      - [2.GRE header](#2gre-header)
      - [3.GRE特点](#3gre特点)
    - [使用](#使用)
      - [1.设置GRE](#1设置gre)
        - [（1）启动linux的GRE模块](#1启动linux的gre模块)
        - [（2）创建隧道（tunnel）](#2创建隧道tunnel)
        - [（3）启动隧道](#3启动隧道)
        - [（4）配置VIP](#4配置vip)
        - [（5）测试](#5测试)
      - [2.使用GRE](#2使用gre)
        - [（1）开启路由转发功能](#1开启路由转发功能)
        - [（2）在机器一上设置路由](#2在机器一上设置路由)
        - [（3）在机器二上设置SNAT](#3在机器二上设置snat)

<!-- /code_chunk_output -->

### 概述

#### 1.GRE
generic routing encapsulation

#### 2.GRE header
![](./imgs/gre_01.png)

#### 3.GRE特点
* 支持封装多种协议，从而能够使得，无法在互联网上传播的包（比如ipv6包、局域网包等），能够在互联网上传播，最终由server端对该数据包做处理
  * 如果不进封装，局域网内的路由数据包就无法在互联网上传输，可以进行封装后，再在互联网上传播
  * 比如：汽车和轮船，汽车不能在水上行驶，可以将汽车装到轮船里

***

### 使用
两台机器都需执行
#### 1.设置GRE
##### （1）启动linux的GRE模块
```shell
modprobe ip_gre
```

##### （2）创建隧道（tunnel）
```shell
ip tunnel add <TUNNEL_NAME> mode gre remote <REMOTE_REAL_IP> local <LOCAL_REAL_IP>
```

##### （3）启动隧道
```shell
ip link set <TUNNEL_NAME> up
```

##### （4）配置VIP
```shell
ip addr add <LOCAL_VIP> peer <REMOTE_VIP> dev <TUNNEL_NAME>
```

##### （5）测试
```shell
ping <REMOTE_VIP>   #能够ping表示配置成功
```

#### 2.使用GRE
场景描述：
机器一无法访问外网，机器二可以访问，
所以需要将机器一的所有流量从机器二走
* 机器一：3.1.5.19（vip：10.10.10.1）
* 机器二：3.1.1.101（vip：10.10.10.2）

##### （1）开启路由转发功能
```shell
echo 1 > /proc/sys/net/ipv4/ip_forward
```

##### （2）在机器一上设置路由
* 内部网络，走的是 之前的网关
```shell
ip route add 3.1.0.0/16 via 3.1.5.254
```

* 将机器二的vip设置为网关
路由的优先级可以通过metric参数调节，metric越小优先级越高
```shell
ip route add 0.0.0.0/0 via 10.10.10.2
```

##### （3）在机器二上设置SNAT
即从机器一来要外出的流量，都将源地址修改成机器二的源地址（3.1.1.101），如果源地址依然为10.10.10.1，则就收不到返回的包（因为机器二的网关根本不认识10.10.10.1）
```shell
iptables -t nat -A POSTROUTING -s 10.10.10.1  -j SNAT --to-source 3.1.1.101
```
