# docker网络模式

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [docker网络模式](#docker网络模式)
    - [概述](#概述)
      - [1. 虚拟交换机](#1-虚拟交换机)
      - [2.bridge模式（是一个nat桥）](#2bridge模式是一个nat桥)
      - [3.host模式](#3host模式)
      - [4.container模式](#4container模式)
      - [5.none模式](#5none模式)
      - [6.overlay模式](#6overlay模式)
      - [6.macvlan模式](#6macvlan模式)
      - [7.macvlan通信](#7macvlan通信)
      - [8.创建docker网络](#8创建docker网络)

<!-- /code_chunk_output -->

### 概述

#### 1. 虚拟交换机
* 如果使用虚拟交换机，虚拟网卡会创建一对，一个在宿主机中，一个在虚拟交换机上
* 如果使用nat桥，可以在宿主机上查看nat的规则：iptables -t nat -vnL
* 桥接模式和nat模式区别：
都是bridge模式
桥接模式不能与不同网段的通信(需要虚拟一个路由器），nat可以

#### 2.bridge模式（是一个nat桥）
有一个虚拟交换机dokcer0，所有的容器都与docker0相连，通过宿主机路由出去
```shell
#修改bridge所在的网段：vim /etc/docker/daemon.json
  {
    "bip": "192.168.0.11/24"          #指定docker0桥的ip地址和其掩码
  }
```
#### 3.host模式
  新创建的容器与宿主机共享一个netns
```shell
  --network host
```

#### 4.container模式
  新创建的容器和已经存在的一个容器共享一个netns
```shell
  --network container:xx         //xx为已经存在的容器的名字
```

#### 5.none模式
  使用none模式，Docker容器拥有自己的Network Namespace，但是，并不为Docker容器进行任何网络配置。
  也就是说，这个Docker容器没有网卡、IP、路由等信息。需要我们自己为Docker容器添加网卡、配置IP等

#### 6.overlay模式
  可以实现容器的跨主机通信，host模式也可以

（1）工作方式：
* 需要创建一个consul的服务容器，提供ip地址池，比如10.0.9.0/24之类的
* 容器的从consul获取ip
* 获取完了后，会通过eth1进行通信

（2）工作原理
* 通过隧道的方式，源地址和目标地址不变
* 再封装一层四层和三层报文，源地址为源宿主机地址，目标地址为目标宿主机地址
* 然后再进行二层等报文的封装

#### 6.macvlan模式
**一定要允许混杂模式，如果是vm：真机 -> 虚拟交换机 -> 允许混杂模式**
* 就是在一个物理网卡上虚拟多个网卡，然后都连接到该物理网卡上，流量都从这个物理网卡外出
  * 每个虚拟的网卡都有一个mac地址，就像真的网卡一样
  * 真正的物理网卡就像一个交换机

  * 一个物理网卡只能用于一个macvlan网络（不能用于其他，也不能有ip），一个macvlan网络可以分配多个ip地址
  * 子网卡不能访问母网卡的地址

```shell
docker network create -d macvlan --subnet=10.0.36.0/24 \
  --ip-range=10.0.36.115/32 --gateway=10.0.36.254  \
  -o parent=ens34 xx
```

#### 7.macvlan通信     
子网掩码越长，路由优先级越高
这个方法只能解决宿主机和容器通信的问题，所以没什么用

（1）创建macvlan网络
```shell
docker  network create -d macvlan --subnet 10.0.36.0/24 \
  --ip-range 10.0.36.192/27 --aux-address 'host=10.0.36.223' \         #aux-address就是排除的ip地址，即不会进行分配
  --gateway 10.0.36.254  -o parent=ens34 mynet
```
（2）创建一个新的macvlan接口，用于连接host和container
```shell
  ip link add mynet-shim link ens34 type macvlan mode bridge     
  ip addr add 10.0.36.223/32 dev mynet-shim
  ip link set mynet-shim up
```

（3）添加路由信息
```shell
  ip route add 10.0.36.192/27 dev mynet-shim
```
#### 8.创建docker网络
```shell
  docker network create -d 驱动 --subnet "xx" --gateway "xx" 网络的名字
```
