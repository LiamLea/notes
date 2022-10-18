# tcpdump

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [tcpdump](#tcpdump)
    - [概述](#概述)
      - [1.tcpdump和iptables的处理顺序](#1tcpdump和iptables的处理顺序)
    - [使用](#使用)
      - [1.在宿主机上抓取容器中某个网卡的数据包](#1在宿主机上抓取容器中某个网卡的数据包)
        - [（1）方法一](#1方法一)
        - [（2）方法二](#2方法二)
      - [2.解析https流量](#2解析https流量)
        - [（1）利用ssl-key-log解析](#1利用ssl-key-log解析)
        - [（2）利用private key（不通用）](#2利用private-key不通用)

<!-- /code_chunk_output -->

### 概述

#### 1.tcpdump和iptables的处理顺序
* inbound流量
```shell
Wire -> NIC -> tcpdump -> netfilter/iptables
```

* outbound流量
```shell
iptables -> tcpdump -> NIC -> Wire
```

***

### 使用

#### 1.在宿主机上抓取容器中某个网卡的数据包

##### （1）方法一

默认`ip netns`无法显示和操作容器中的netns
* 获取容器的pid
```shell
pid=`docker inspect -f '{{.State.Pid}}' <CONTAINER_ID>`
#根据pid可以找到netns：
#  /proc/<PID>/net/ns
```
* 创建`/var/run/netns/`目录
```shell
mkdir -p /var/run/netns/
```

* 将netns连接到`/var/run/netns/`目录下
```shell
ln -s /proc/<PID>/ns/net /var/run/netns/<CUSTOME_NAME>

#ip netns list就可以看到该netns
```
* 监听
```shell
ip netns exec <CUSTOME_NAME> <COMMAND>
```

##### （2）方法二

* 进入容器执行
```shell
$ cat /sys/class/net/<INTERFACE>/iflink

28
```

* 在宿主机执行
```shell
$ ip link

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:50:56:b8:6d:a3 brd ff:ff:ff:ff:ff:ff
... ...
28: cali5ddcf4a2547@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netnsid 7
```

* 在宿主机上 抓取 容器中指定网卡 的数据包
```shell
tcpdump -l -i cali5ddcf4a2547 -nn
#-l：Make stdout line buffered，能够立即看到抓到的包
```

#### 2.解析https流量

##### （1）利用ssl-key-log解析
只能解析客户端的https（即在抓取客户端的包，利用客户端的ssl-key log）
```shell
ssldump -i eth0 -dnq -l /tmp/ssl-key.log port 443
```
结果如下
```
...
1 11   0.1172   (0.0001)    C>S    application_data
      ---------------------------------------------------------------
      GET / HTTP/1.1
      User-Agent: curl/7.29.0
      Host: 10.172.1.207
      Accept: */*

      ---------------------------------------------------------------
1 12   0.1174   (0.0001)    S>C    application_data
      ---------------------------------------------------------------
      HTTP/1.1 200 OK
      Server: nginx/1.20.1
      Date: Fri, 13 May 2022 08:53:00 GMT
      Content-Type: text/html
      Content-Length: 4
      Last-Modified: Fri, 13 May 2022 08:02:13 GMT
      Connection: keep-alive
      ETag: "627e1085-4"
      Accept-Ranges: bytes

      aaa
      ---------------------------------------------------------------
...
```
* 发起https请求
```shell
SSLKEYLOGFILE="/tmp/ssl-key.log" curl --insecure https://10.172.1.207:443
```

##### （2）利用private key（不通用）
We can only decrypt TLS/SSL packet data if RSA keys are used to encrypt the data.因为很多并没有用RSA进行加密，而是利用RSA进密钥传递，然后用该密钥加密数据，所以导致无法用private key解密数据。

根据serverhello中的Cipher Suite类型，当使用的是DHE或者RSA ephemeral cipher suite等，就不能用私钥进行https解密

* 建议使用wireshark解析，使用ssldump解析可能会有问题
```shell
ssldump -i eth0 -dnq -k <server.key> port 443
```
