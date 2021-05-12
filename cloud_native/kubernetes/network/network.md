# network

[toc]

### 概述

#### 1.需要实现的目标
|目标|方式|
|-|-|
| 同一个pod的内的容器通信 | 共享netns |
| 不同主机上的pods可以直接通信，无需NAT | 通过tunnel |
| pod与service的可以直接通信 | 通过iptables |
| 所有nodes可以通信 | 本身node就需要可以通信 |

#### 2.需要考虑的网络模型

##### （1）container-to-container 网络
同一个pod内的containers共享同一个netns，所以没有container-to-container的网络，而是pod-to-pod的网络

##### （2）pod-to-pod 网络
* 同一台宿主机上的pod
  * 通过cni实现间pod通信
    即在root netns中创建一个bridge，其他netns添加veth，连接到该bridge上

![](./imgs/pod-to-pod_01.png)

* 跨宿主机间的pod
  * 通过 **tunnel**（比如：vxlan）

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
本身就需要能够通信

***

### 网络配置

#### 1.网络插件的对比
|插件名|flannel|calico|cannel|
|-|-|-|-|
|特点|简单|性能好，可以设置网络策略|结合flannel和calico（不再维护）|
|实现方式|叠加网络（即封装）|通过BGP协议，没有进行封装，所以性能更好||

#### 1.flannel采用的技术

##### （1）vxlan
  叠加网络，利用隧道技术封装数据帧，从而能够实现很好的网络隔离

##### （2）host-gw（也就是虚拟网桥）
  物理网卡作为网关，当跨主机通信时，通过物理网卡路由
  特点：性能最好，但是需要物理主机都必须在同一网络内

##### （3)udp（性能差，现在已经不用）

#### 2.利用calico实现网络策略
安装calico后，会创建crd资源：NetworkPolicy
用户可以自动该资源创建规则，从而实现网络策略
