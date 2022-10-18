# iperf

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [iperf](#iperf)
    - [概述](#概述)
      - [1.特点](#1特点)
    - [使用](#使用)
      - [1.测试带宽](#1测试带宽)

<!-- /code_chunk_output -->

### 概述

#### 1.特点
用于测试网络的带宽

***

### 使用

#### 1.测试带宽

* 在A机器上启动服务端
```shell
iperf3 -s -p 5201
#-s，server
#-p，port
#-u，监听UDP协议
```

* 在B机器上启动客户端，连接服务端
```shell
iperf3 -c <IP> -p 5201
#-c，connect
#-p，port
#-u，使用UDP协议
#-P，parallel，设置线程数，即用多少个线程连接服务端
```
