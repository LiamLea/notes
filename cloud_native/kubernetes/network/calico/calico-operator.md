# calico opertor

[toc]

### 概述

#### 1.API group
`operator.tigera.io/v1`

***

### operator配置

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

    #配置ip pools（可配置多个）
    ipPools:
    - cidr: 10.244.0.0/16   #classless inter-domain routing，无类别域间路由（即kubeadm init时，设置的pod的cidr）
      blockSize: 26         #将一个ip pool分为多个更小的block（每个block的网段长度）
      encapsulation: VXLANCrossSubnet   #VXLAN、IPIP（需要开启bgp）、IPIPCrossSubnet
      natOutgoing: <bool | default=Enabled>    #访问集群外的地址会进行snat，将pod的ip转换为node的ip
      nodeSelector: all()    #指定该ip pool用于哪些node

    #默认是Enabled
    #关闭后，路由条目不是通过bgp协议更新了，而是通过数据存储中获取
    bgp: Disabled

    #配置mtu的值
    mtu: <int>    #不设置的话，默认calico会执行mtu自动检测，设置合适的值

    #设置支持host ports
    hostPorts: <bool | default=Enabled>

    #设置pod是否支持路由功能
    containerIPForwarding: <bool | default=Disabled>
```
