# network

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [network](#network)
    - [概述](#概述)
      - [1.netfilter](#1netfilter)
      - [2.物理网卡](#2物理网卡)
      - [3.network namesapce](#3network-namesapce)
        - [（1）ip netns命令](#1ip-netns命令)
        - [（2）容器的netns](#2容器的netns)
      - [4.`ifindex`和`iflink`](#4ifindex和iflink)
        - [（1）在同一network namespace下，`ifindex`是唯一的](#1在同一network-namespace下ifindex是唯一的)
        - [（2）`iflink`标识对端设备`ifindex`](#2iflink标识对端设备ifindex)
        - [（3）有对端设备的接口的命名方式：`@`](#3有对端设备的接口的命名方式)
      - [5.`netnsid`和`link-netnsid`](#5netnsid和link-netnsid)
        - [（1）`netnsid`唯一标识netns](#1netnsid唯一标识netns)
        - [（2）`link-netnsid`标识对端设备所在的netns的id](#2link-netnsid标识对端设备所在的netns的id)
      - [6.判断设备属于何种类型（TUN/TAP、veth等）](#6判断设备属于何种类型tuntap-veth等)

<!-- /code_chunk_output -->

### 概述

#### 1.netfilter
![](./imgs/netfilter_01.png)


#### 2.物理网卡
```            
                +-------------+   
                | Socket API  |   
                +-------------+              
User Space             |
-----------------------------------------------
Kernel Space           |
                 raw packets
                       |              
                +-------------+  
                |Network Stack|   
                +-------------+  
                       |                  
                +-------------+   
                |    eth0     |  
                +-------------+  
                       |                  
                +-------------+   
                |     NIC     |  
                +-------------+      
                       |   
                      wire
```


#### 3.network namesapce

##### （1）ip netns命令

* 创建netns
```shell
ip netns add <NAME>
```

* 列出所有netns
```shell
 ip netns list
```

* 在指定netns中执行命令
```shell
ip netns exec <NAME> <CMD>

#切换到指定netns中
ip netns exec <NAME> bash
```

##### （2）容器的netns
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

#### 4.`ifindex`和`iflink`

##### （1）在同一network namespace下，`ifindex`是唯一的

##### （2）`iflink`标识对端设备`ifindex`
* 如果iflink等于ifindex（比如：`bridge`、`ens192`等）
  * 表示该设备没有对端设备
* 如果iflink不等于ifindex（比如：`veth pair`）
  * 则iflink则为对端设备的ifindex
  * 还需要知道**对端设备所在的netns**，才能定位到对端设备
  ```shell
  $ ip link

  #其中，link-netnsid标识了对端设备所在的netns
  6: vethbb74a593@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP mode DEFAULT group default
    link/ether 5a:56:4d:b4:06:0b brd ff:ff:ff:ff:ff:ff link-netnsid 0
  7: veth5d181a6f@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP mode DEFAULT group default
    link/ether 1a:a0:c8:b2:47:57 brd ff:ff:ff:ff:ff:ff link-netnsid 1
  ```

##### （3）有对端设备的接口的命名方式：`@`
* 当对端设备也在该netns中时
  * `<ifname>@<peername>`

* 当对端设备在其他netns中时
  * `<ifname>@if<iflink>`

#### 5.`netnsid`和`link-netnsid`

##### （1）`netnsid`唯一标识netns
* root netns没有netnsid
* 先被使用的netns（不是先创建的），会先分配netnsid（从0开始）

##### （2）`link-netnsid`标识对端设备所在的netns的id

#### 6.判断设备属于何种类型（TUN/TAP、veth等）

* 判断设备属于哪种类型
```shell
ip -d link show <DEVICE_NAME>
```

* 判断某种类型有哪些设备
```shell
ip link show type <TYPE>  #<TYPE>：veth、bridge、dummy等
ip tuntap show
ip tunnel show
```
