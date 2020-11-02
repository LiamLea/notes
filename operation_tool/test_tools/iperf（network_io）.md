# iperf

[toc]

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
