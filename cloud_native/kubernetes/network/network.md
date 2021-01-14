# network

[toc]

### 概述

#### 1.需要实现的目标
* 所有pods可以直接通信，无需NAT
* 所有nodes可以直接通信，无需NAT
* 同一个pod的内的容器共享netns

#### 2.需要考虑的网络模型

##### （1）container-to-container 网络
同一个pod内的containers共享同一个netns，所以没有container-to-container的网络，而是pod-to-pod的网络

##### （2）pod-to-pod 网络
* 同一台宿主机上的pod
  * 通过cni实现间pod通信
    即在root netns中创建一个bridge，其他netns添加veth，连接到该bridge上

![](./imgs/pod-to-pod_01.png)

* 跨宿主机间的pod
  * 通过隧道（比如：vxlan）

![](./imgs/pod-to-pod_02.gif)

##### （3）pod-to-service 网络
```shell
#需要设置数据包经过bridge，调用iptables时进行处理

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
```

* 数据包经过cbr0 bridge，会经过iptables处理
  * 比如：目标ip为某个service的ip，会转换成pod的ip
* 当数据包返回时，经过cbr0 bridge，由于iptables contrack保留了之前的状态，所以这边也会做相应转换
  * 比如：将pod的ip，转换成某个service的ip


##### （4）node-to-node 网络
通过tunnel（比如：vxlan、ipip等）
