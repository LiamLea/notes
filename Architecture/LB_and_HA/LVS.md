# LVS

[toc]

### 概述

#### 1.术语
* director server（调度服务器）
将负载分发到real server的服务器

* real server（真实服务器）   
真正提供应用服务的服务器

* VIP（虚拟IP地址）       
公布给用户访问的IP地址,因为该地址配置在虚拟网卡上的,所有叫VIP

* DIP（直连IP地址）       
调度器 连接 节点服务器 的IP地址

* RIP :真实IP地址（节点服务器使用的IP地址）

#### 2.LVS工作模式(对于真实服务器而言的)

##### （1）NAT模式（也叫SNAT模式）
* 跟 nginx 和 k8s中service 负载一样，在调度机上会修改源ip地址，改成自身的ip地址
  * 所以请求和回复都经过调度机
  * 性能会成为瓶颈

##### （2）DR模式(direct routing，路由模式，默认的)
* 请求经过调度机，回复根据路由直接给客户机
  * 因为服务器收到的请求的源ip不是调度机的了，而是真正的源ip，所以会根据路由回复给源ip

* 需要在服务器上 设置 跟调度机上 **一样** 的vip
  * 因为有一个基本原则:当请求的目的IP是多少,回应的IP也必须是多少
  * 所以,DR模式下真实服务器需要伪装源IP地址,客户端才会接受其回应的数据

* 为什么调度机上的VIP要设置在虚拟机接口上
  * 因为优先使用主接口，client先访问VIP，然后调度机用主接口上的IP地址转给real server
  * 否则用的VIP转给real server会冲突,因为real server也有VIP


##### （3）TUN模式（tunnel）
通过隧道方式,调度机和服务器不在同一个局域网内,不常使用

#### 3.ip地址转换方式
* SNAT
这个需要指定ip
</br>
* Auto map
会自动根据外出的接口，自动进行SNAT转换

***

### 配置

#### 1.ipvsadm命令

LVS内置在内核中的，但要使用该管理命令需要安装相关软件

* 对集群的操作:-A -E -D
```shell
ipvsadm -A -t 192.168.4.5:80 -s rr
#-A创建集群,-t对TCP协议有效(根据想转发的协议决定),ip地址为虚拟服务器地址
#-s scheduling-method 调度算法
```

* 对真实服务器的操作:-a -e -d
```shell
ipvsadm -a -t 192.168.4.5:80 -r 192.168.2.100:80 -m -w 2
#-r,将真实服务器加入到集群中
#-m(masquerading,NAT模式),-g(gatewaying,DR模式,默认),-i(ipip encapsulation,隧道模式)
#-w设置权重,当使用的覅度算法使用权重时才有意义
```

* 其他操作:
```shell
ipvsadm -C        #清除所有
ipvsadm -Ln       #列出所有集群,-n显示端口号
ipvsadm --save -n > /etc/sysconfig/ipvsadm    #永久保存所有规则,开机之后重启服务即可
```

***

### 部署LVS-NAT模式

#### 1.开启调度器的路由转发功能
```shell
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
```

#### 2.创建一个集群
```shell
ipvsadm -A -t VIP:端口 -s 调度算法
```

#### 3.添加真实服务器(真实服务器要设好网关)
```shell
ipvsadm -a -t VIP:端口 -r RIP:端口 -m
...
```

#### 4.保存规则

***

### 部署LVS-DR模式

#### 1.在调度机上配置VIP

```shell
#为了避免冲突,VIP必须配置在网卡的虚拟接口上(即子网卡,能够实现一个网卡多个IP)

#vim /etc/sysconfig/network-scripts/ifcfg-eth0:0
  TYPE=Ethenet
  BOOTPROTO=none    //可以是DHCP
  NAME=eth0:0
  DEVICE=eth0:0
  ONBOOT=yes
  IPADDR=192.168.4.15
  PREFIX=24        //子网掩码
#重启network服务
```

#### 2.在真实服务器上配置VIP
```shell
#为了避免冲突,VIP设置在lo虚拟网卡中,结合抑制arp
#vim /etc/sysconfig/network-scripts/ifcfg-lo:0
  NAME=lo:0
  DEVICE=lo:0
  ONBOOT=yes
  IPADDR=192.168.4.15
  PREFIX=32
#重启network服务

#抑制arp
#vim /etc/sysctl.conf
  net.ipv4.conf.all.arp_ignore=1    
  net.ipv4.conf.lo.arp_ignore=1    
#arg_ignore=1表示只响应目的IP与接收网卡的IP一样,即只回复 接收到arp请求的网卡 上的信息
#all和lo都要设置,因为选择其中较大的值
  net.ipv4.conf.all.arp_announce=2
  net.ipv4.conf.lo.arp_announce=2
#arg_announce=2表示arp时选择自身的网卡IP地址,防止选到VIP,发生错误
#sysctl -p 立即读取/etc/sysctl.conf中的参数
```

#### 3.调度机开启路由转发功能

#### 4.创建一个集群
```shell
  ipvsadm -A -t VIP:端口 -s 调度算法
```

#### 5.添加真实服务器
```shell
  ipvsadm -a -t VIP:端口 -r RIP:端口  -g   //默认就是-g,可以不写
  ...
```

#### 6.保存规则
