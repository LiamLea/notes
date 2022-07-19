# OVS (open virtual switch)

[toc]

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

***

### 使用

#### 1.查看信息

* 查看所有关于vswitch的信息
```shell
ovs-vsctl show
```
```shell
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

* 列出vswitch
```shell
ovs-vsctl list-br
```

* 列出vswitch上的所有端口
```shell
ovs-vsctl list-br <vswitch_name>
```

* 查看该vswitch的controller
```shell
ovs-vsctl get-controller <vswitch_name>
```
