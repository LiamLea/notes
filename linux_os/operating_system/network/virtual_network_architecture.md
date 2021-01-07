# virtual networking

[toc]

### bridge

#### 1.概述
* 虚拟交换机
* 所有接口都连接到该虚拟交换机上（包括物理接口）
* 流量外出时，走物理接口出

![](./imgs/bridge_01.png)

#### 2.设置
```shell
ip link add br0 type bridget
ip link set eth0 master br0
ip link set tap1 master br0
ip link set tap2 master br0
ip link set veth1 master br0
```
