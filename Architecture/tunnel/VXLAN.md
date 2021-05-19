# VXLAN

[toc]

### 概述

#### 1.特点
应用在数据中心网络
虚拟机比较多，所以需要的vlan也比较多，传统的vlan技术，只能划分4096个vlan

#### 2.相关术语

##### （1）VNI（vxlan netwotk id）

##### （2）VTEP（virtual tunnel endpoint）
一个VTEP就是一个vxlan节点，监听着相应udp端口
能够与其他VETP交换信息，从而生成和维护mac地址转发表（`bridge fdb show`可以查看）

#### 3.数据包格式
![](./imgs/vxlan_01.png)

#### 4.发现其他VTEP的方式

##### （1）组播
* 组播的好处
  * 能够自动发现其他VTEP
  * 良好的带宽控制
    * 因为在arp阶段，确定了数据包的目标地址，不会占用很大的带宽
  * 分散且无控制器的设计

* 组播的缺点
  * 不是所有设备都支持组播

##### （2）单播
不能自动发现VTEP，需要手动配置

#### 5.通信过程（非常重要）
3.1.5.19上vxlan设备配置的10.10.10.1/24
3.1.5.20上vxlan设备配置的10.10.10.2/24
从3.1.5.19上ping 10.10.10.2经历的过程

* 首先查看路由表
  ```shell
  $ ip route

  #表明数据包要从vxlan.100出去
  10.10.10.0/24 dev vxlan.100 proto kernel scope link src 10.10.10.1
  ```
* 查看arp表
  * 如果手动添加了arp条目，下面就不会发起arp请求了
  * 没有发现10.10.10.2对应的ip地址
    * 发起arp请求
    * 查询mac地址表
      ```shell
      $ bridge fdb show dev vxlan.100

      #全0条目表示，会将BUM帧，发送到所有全0条目指定的地址（这里就是224.0.0.100）
      00:00:00:00:00:00 dst 224.0.0.100 via ens192 self permanent
      ```
    * 收到arp回复，在mac地址表中添加条目
      ```shell
      $ bridge fdb show dev vxlan.100

      #表明这个mac地址，在3.1.5.20这个节点上
      12:24:a9:23:af:2d dst 3.1.5.20 self
      ```
* 构造icmp包
  * 目标ip为：10.10.10.2
  * 目标mac为：12:24:a9:23:af:2d
* vxlan封装icmp包
  * 目标ip为：3.1.5.20
  * 目标mac为：3.1.5.20的mac（如果没有该ip对应的mac，就需要用arp请求去获取）
* 将数据包从ens192发出去

***

### 配置

#### 1.利用组播

##### （1）创建vxlan设备
```shell
ip link add <NAME> \      #该vxlan设备的名字
        type vxlan \
        id <VNI>   \      #设置该vxlan设备所在的vxlan id
        dev <physiacl_device> \
        group <multicast_address> \   #设置用于通信的组播地址，只要与其他不冲突，比如：224.0.0.100
        dstport 8472      #设备VTEP监听的端口 和 发出去的数据包的目标端口

#将vxlan设备启动，该设备绑定的物理网卡 就会添加 相应的组播地址（ip maddr查看）
ip link set <NAME> up
```

##### （2）验证配置
* 验证组播地址
```shell
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
ping <multicast_address>      #比如：ping 224.0.0.100
```

* 查看fdb表
```shell
$ bridge fdb show

...
00:00:00:00:00:00 dev vxlan.100 dst 224.0.0.100 via ens192 self permanent
...

#全0条目表示，会将BUM帧，发送到所有全0条目指定的地址（这里就是224.0.0.100）
```

##### （3）配置ip
```shell
#在3.1.5.19上配置ip
ip addr add 10.10.10.1/24 dev ens192

#在3.1.5.20上配置ip
ip addr add 10.10.10.2/24 dev ens192
```

#### 2.利用单播

##### （1）创建vxlan设备
```shell
ip link add <NAME> \      #该vxlan设备的名字
        type vxlan \
        id <VNI>   \      #设置该vxlan设备所在的vxlan id
        dev <physiacl_device> \
        dstport 8472 \    #设备VTEP监听的端口 和 发出去的数据包的目标端口
        local <LOCAL_IP> \
        nolearning        #不自动更新该设备的fdb表
```

##### （2）添加vxlan的fdb条目
```shell
#有多个VTEP就添加多个下面的内容

bridge fdb append 00:00:00:00:00:00 dev <NAME> dst <REMOTE_IP>  
#这个用于arp，获取对应vxlan的mac
#设置之后，arp请求包会发到<REMOTE_IP>这个地址，从而更新vxlan的mac
#如果不设置，可以通过手动添加arp条目实现（flannel就是这样的）

bridge fdb append <REMOTE_VXLAN_MAC> dev <NAME> dst <REMOTE_IP>
```

##### （3）其他设备，跟组播差不多，这里省略
