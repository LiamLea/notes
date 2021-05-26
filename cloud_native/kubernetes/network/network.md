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
  * 可以通过 **overlay网络（即tunnel）**（比如：vxlan）

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

#### 3.实现cross-node pods的通信方式

|方式|特点|优点|缺点|
|-|-|-|-|
|overlay network|封装数据包|不依赖底层网络，只需要底层网络能通就行|1.轻微的性能影响</br>2.在cluster外部的网络，没有到pod的ip的路由|
|none-overlay network|不封装数据包（直接路由）|1.性能更好</br>2.在cluster外部的网络能够直接访问pod ip，不需要通过service、ingress等|1.依赖底层网络，需要构建路由表（比如calico就是利用的BGP）</br>2.pod的ip必须在整个网络中是唯一的  |
|cross-subnet overlay network|跨subnet时，才进行封装（上述两者的结合）|性能优于overlay network|需要构建路由表（通过BGP）|

* cross-subnet overlay实现的方式
```shell
$ ip r

...

#这些node都是在3.1.4.0/24这个网段，所以这些node上的pod网络，不需要经过封装，而是直接走ens192这个网卡
10.244.49.192/26 via 3.1.4.231 dev ens192 proto 80 onlink
10.244.84.128/26 via 3.1.4.232 dev ens192 proto 80 onlink
...

#不在同一个网段的node上的pod网络，需要经过封装，走的是vxlan.calico这个网卡
#bridge fdb show，能看出这个node的地址为3.1.4.214
#66:0a:21:41:0a:c1 dev vxlan.calico dst 3.1.4.214 self permanent
10.244.150.64/26 via 10.244.150.64 dev vxlan.calico onlink
...

```

#### 4.node在不同网段的解决方案
1.Calico can be configured to create IP-in-IP tunnel endpoints on each node for every subnet that is hosted on the node. Any packet that originated by the pod and is egressing the node, is encapsulated with the IP-in-IP header and the node IP address is used as the source. This way, the infrastructure router does not see the pod IP addresses.

The IP-in-IP tunneling brings in extra network throughput and latency due to additional packet processing at each endpoint to encapsulate and decapsulate packets. On bare metal, the overhead is not significant as certain network operations can be offloaded to the network interface cards. However, on virtual machines, the overhead can be significant and also affected by the number of CPU cores and network I/O technologies that are configured and used by the hypervisors. The additional packet encapsulation overhead can also be significant when smaller maximum transmission unit (MTU) sizes are used since it can introduce packet fragmentation. Jumbo frames must be enabled whenever possible.

2.The second option is to make the infrastructure router aware of the pod network. You can do this by enabling BGP on the router and adding the nodes in the cluster as BGP peers. These steps allow the router and the hosts to exchange the route information between each other. The size of the cluster in this scenario can come into play as in the BGP mesh. Every node in the cluster is a peer of the router after enabling BGP on the router.
