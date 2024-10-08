# calico opertor

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [calico opertor](#calico-opertor)
    - [概述](#概述)
      - [1.API group](#1api-group)
    - [operator配置](#operator配置)
      - [1.ImageSet](#1imageset)
      - [2.Installation](#2installation)

<!-- /code_chunk_output -->

### 概述

#### 1.API group
`operator.tigera.io/v1`

***

### operator配置

[参考](https://projectcalico.docs.tigera.io/reference/installation/api)

#### 1.ImageSet
指定使用的镜像（用默认的就行）
```yaml
apiVersion: operator.tigera.io/v1
kind: ImageSet
spec:
  images:
  - image: calico/node
    digest: xx
  - image: calico/kube-controllers
    digest: xx
  - image: calico/typha
    digest: xx
#...
```

#### 2.Installation

**注意**：
* 当已经安装了，然后修改相关配置后，需要考虑影响，从而做相关操作（比如删除网卡或重启网络）

* 有些配置在这里改不会生效，需要修改其他文件（比如切换隧道模式，要修改ippool）

* cross subnet:
  * It only applies overlay networking (encapsulation) between nodes that are in different subnets, reducing the need for IP address translation

```yaml
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:

  #指定仓库信息
  registry: harbor.test.com
  imagePath: calico

  #配置网络
  calicoNetwork:

    #配置ip pools（当比Kubeadm init指定的pod网段小，可以配置多个ippool）
    #每个ippool都需要指定隧道模式（不同的ippool可以用不同的隧道模式）
    ipPools:
    - cidr: 10.244.0.0/16   #classless inter-domain routing，无类别域间路由（只要跟宿主机网络不冲突即可）
      blockSize: 26         #将一个ip pool分为多个更小的block（每个block的网段长度）
      encapsulation: IPIP   #VXLAN、IPIP（需要开启bgp）、IPIPCrossSubnet
      natOutgoing: <bool | default=Enabled>    #访问集群外的地址会进行snat，将pod的ip转换为node的ip
      nodeSelector: all()    #指定该ip pool用于哪些node

    #配置如何发现 用于路由的ip（一定要指定，否则默认随机，可能选到其他的ip）
    nodeAddressAutodetectionV4:
      cidrs:
      - "3.1.4.0/24"

    #默认是Enabled
    #关闭后，路由条目不是通过bgp协议更新了，而是通过数据存储中获取
    bgp: Enabled

    #配置mtu的值
    mtu: <int>    #不设置的话，默认calico会执行mtu自动检测，设置合适的值

    #设置支持host ports
    hostPorts: <bool | default=Enabled>

    #设置pod是否支持路由功能
    containerIPForwarding: <bool | default=Disabled>
```
