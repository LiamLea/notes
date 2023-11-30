# OVS (open virtual switch)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [OVS (open virtual switch)](#ovs-open-virtual-switch)
    - [概述](#概述)
      - [1.基础概念](#1基础概念)
      - [2.常用interface type](#2常用interface-type)
    - [使用](#使用)
      - [1.查看信息](#1查看信息)
        - [(1) 查看open vswitch信息](#1-查看open-vswitch信息)
        - [(2) 查看某个bridge的路由信息](#2-查看某个bridge的路由信息)
        - [(3) 查看某个bridge的数据流](#3-查看某个bridge的数据流)

<!-- /code_chunk_output -->

### 概述

[参考](http://www.openvswitch.org/support/dist-docs/ovs-vswitchd.conf.db.5.html)

#### 1.基础概念

|概念|说明|
|-|-|
|port|交换机的网口|
|interface|网卡，一般一个port对应一个interface，当使用bond时，一个port对应多个interface|

#### 2.常用interface type

|interface type|说明|
|-|-|
|system (默认)|系统的网卡（即OVS外部网卡，比如：eth0），将OVS外部的网卡添加到该虚拟交换机上|
|internal|内部网卡（当该interface名字与bridge的名字一样，叫做local interface）|
|patch|连接线（一对），相当于veth pair|
|tap|被该bridge管理的TUN/TAP设备 |
|vxlan|vxlan tunnel，一个endpoint一个vxlan interface|
|genve|是一种加密协议，类似于vxlan|

***

### 使用

只能列出虚拟交换机上的接了哪些端口，具体这些端口的配置看不到，需要配合ovs-nbctl和ovs-sbctl命令去查看
#### 1.查看信息

##### (1) 查看open vswitch信息

* 名称为**tap**开头的网卡一般都是**虚拟机**的网卡

* 没有使用OVN时

```shell
$ ovs-vsctl show

#controller地址
Manager "ptcp:6640:127.0.0.1"
    is_connected: true

#br-ex虚拟交换机信息
Bridge br-ex
    #controller地址
    Controller "tcp:127.0.0.1:6633"
        is_connected: true

    #local interface
    Port br-ex
        Interface br-ex
            type: internal

    #system interface
    Port "enp6s0"
        Interface "enp6s0"

    #patch interface，对端是叫int-br-ex的interface
    Port phy-br-ex
        Interface phy-br-ex
            type: patch
            options: {peer=int-br-ex}

Bridge br-tun
    Controller "tcp:127.0.0.1:6633"
        is_connected: true
    Port br-tun
        Interface br-tun
            type: internal
    Port patch-int
        Interface patch-int
            type: patch
            options: {peer=patch-tun}

    #建立vxlan隧道，一端在本地虚拟机交换机上，一端在外部虚拟交换机上
    Port "vxlan-c0a80ace"
        Interface "vxlan-c0a80ace"
            type: vxlan
            options: {df_default="true", egress_pkt_mark="0", in_key=flow, local_ip="192.168.10.201", out_key=flow, remote_ip="192.168.10.206"}
    Port "vxlan-c0a80acd"
        Interface "vxlan-c0a80acd"
            type: vxlan
            options: {df_default="true", egress_pkt_mark="0", in_key=flow, local_ip="192.168.10.201", out_key=flow, remote_ip="192.168.10.205"}
    Port "vxlan-c0a80aca"
        Interface "vxlan-c0a80aca"
            type: vxlan
            options: {df_default="true", egress_pkt_mark="0", in_key=flow, local_ip="192.168.10.201", out_key=flow, remote_ip="192.168.10.202"}

```

* 使用OVN时

```shell
$ ovs-vsctl show

e5deef00-af0c-4cee-8983-db78a8998e92
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port tapcb234a44-e6
            tag: 4095
            trunks: [4095]
            Interface tapcb234a44-e6
                type: internal
        Port ovn-e18d0f-0
            Interface ovn-e18d0f-0
                type: geneve
                options: {csum="true", key=flow, remote_ip="10.172.1.201"}
        Port ovn-71960a-0
            Interface ovn-71960a-0
                type: geneve
                options: {csum="true", key=flow, remote_ip="10.172.1.132"}
        Port ovn-91dfd8-0
            Interface ovn-91dfd8-0
                type: geneve
                options: {csum="true", key=flow, remote_ip="10.172.1.235"}
        Port patch-br-int-to-provnet-91270315-0043-4282-8c10-4804b15105d4
            Interface patch-br-int-to-provnet-91270315-0043-4282-8c10-4804b15105d4
                type: patch
                options: {peer=patch-provnet-91270315-0043-4282-8c10-4804b15105d4-to-br-int}
        Port ovn-openst-0
            Interface ovn-openst-0
                type: geneve
                options: {csum="true", key=flow, remote_ip="10.172.1.46"}
        Port br-int
            Interface br-int
                type: internal
    Bridge br-ex
        Port patch-provnet-91270315-0043-4282-8c10-4804b15105d4-to-br-int
            Interface patch-provnet-91270315-0043-4282-8c10-4804b15105d4-to-br-int
                type: patch
                options: {peer=patch-br-int-to-provnet-91270315-0043-4282-8c10-4804b15105d4}
        Port ens4
            Interface ens4
        Port br-ex
            Interface br-ex
                type: internal
```

##### (2) 查看某个bridge的路由信息

* 有些内部的路由没有列在这里（没有在linux上创建虚拟设备），而是在数据流内部进行了处理

```shell
$ ovs-appctl ovs/route/show <bridge>

Route Table:
Cached: 169.254.169.254/32 dev ens3 GW 10.172.1.1 SRC 10.172.1.241
Cached: 10.172.1.240/32 dev ens3 SRC 10.172.1.240 local
Cached: 10.172.1.241/32 dev ens3 SRC 10.172.1.241 local
Cached: 127.0.0.1/32 dev lo SRC 127.0.0.1 local
Cached: 172.17.0.1/32 dev docker0 SRC 172.17.0.1 local
Cached: ::1/128 dev lo SRC ::1
Cached: ::1/128 dev lo SRC ::1 local
Cached: dd00:4191:d066:1:f816:3eff:fe22:2800/128 dev ens3 SRC dd00:4191:d066:1:f816:3eff:fe22:2800 local
Cached: fe80::18e8:ddff:fed9:68f1/128 dev ovsmi780823 SRC fe80::18e8:ddff:fed9:68f1 local
Cached: fe80::e4ff:ceff:fe4f:a808/128 dev genev_sys_6081 SRC fe80::e4ff:ceff:fe4f:a808 local
Cached: fe80::f816:3eff:fe22:2800/128 dev ens3 SRC fe80::f816:3eff:fe22:2800 local
Cached: fe80::f816:3eff:febb:b3ef/128 dev ens4 SRC fe80::f816:3eff:febb:b3ef local
Cached: 127.0.0.0/8 dev lo SRC 127.0.0.1 local
Cached: 10.172.1.0/24 dev ens3 SRC 10.172.1.241
Cached: 172.17.0.0/16 dev docker0 SRC 172.17.0.1
Cached: 0.0.0.0/0 dev ens3 GW 10.172.1.254 SRC 10.172.1.241
Cached: dd00:4191:d066:1::/64 dev ens3 SRC dd00:4191:d066:1:f816:3eff:fe22:2800
Cached: fe80::/64 dev ovsmi780823 SRC fe80::18e8:ddff:fed9:68f1
Cached: ::/0 dev ens3 GW fe80::f816:3eff:fe50:9a7f SRC fe80::f816:3eff:fe22:2800
```

##### (3) 查看某个bridge的数据流
```shell
$ ovs-appctl bridge/dump-flows <bridge>
```