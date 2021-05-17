# network plugin

[toc]

### 概述

#### 1.network plugin的功能
* 需要提供NetworkPlugin 接口，能够配置和清除pod的网络
* 需要提供对kube-proxy的特定支持，比如：
  * 当network plugin使用的是linux bridge，iptables能够处理经过linux bridge的流量（当设置`net.bridge.bridge-nf-call-iptables=1`时）
  * 但是，当network plugin使用的是非linux bridge（比如open vswitch等），则iptables不能处理经过非linux bridge的流量，所以需要network plugin提供特定的支持，使得iptables能够处理这种流量

#### 2.常用的network plugins
|类别|说明|特点|
|-|-|-|
|cni plugins|只要能够实现 cni接口规范 的插件 都属于这个类型|功能丰富|
|kubenet||功能单一（不支持 cross-node网络 和 网络策略|

#### 3.CNI
container network interface，容器网络接口，是一种接口标准
定义了 网络插件 和 容器 之前的实现标准

***

### CNI配置

#### 1.kubelet关于cni的配置
```shell
#指定使用的网络插件类型为cni
--network-plugin=cni

#指定cni的配置文件目录（当有多个文件时，按照字典顺序，读取第一个文件）
--cni-conf-dir=/etc/cni/net.d   #默认：/etc/cni/net.d

#指定cni类型插件的二进制可执行文件的目录（在上面的配置文件中，会指定具体使用哪些插件，会在该目录下寻找这些插件的二进制文件）
--cni-bin-dir=/opt/cni/bin      #默认：/opt/cni/bin
```

#### 2.cni的配置

[参考](https://github.com/containernetworking/cni/blob/master/SPEC.md)

```json
{
  "name": "",
  "cniVersion": "",

  //使用的cni插件，即每个插件的配置
  "plugins": []
}
```

#### 3.常用的cni plugins
[由containernetworking维护的cni plugins](https://github.com/containernetworking/plugins/tree/master/plugins/meta)

##### （1）portmap
能够支持使用hostPort
```json
{
  "type": "portmap",
  "capabilities": {"portMappings": true}
}
```

##### （2）bandwidth
能够支持使用流量整形
```json
{
  "type": "bandwidth",
  "capabilities": {"bandwidth": true}
}
```
* 使用流量整形（创建pod时）
```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubernetes.io/ingress-bandwidth: 1M
    kubernetes.io/egress-bandwidth: 1M
...
```

其他cni plugins

##### （3）calico
```json
{
  "type": "calico",
  "datastore_type": "kubernetes", //使用kubernetes集群的存储（即etcd）

  // IPAM：ip address management
  //当创建pod时会从ip池中分配一个ip给该pod
  //当删除pod时，会回收该ip
  "ipam": {
    "type": "calico-ipam",
    "assign_ipv4" : "true",
    "assign_ipv6" : "false"
  },

  //设置container的配置
  "container_settings": {
      "allow_ip_forwarding": false  //net.ipv4.ip_forward=0
  },

  //能够使用k8s的 NetworkPolicy资源
  "policy": {
      "type": "k8s"
  },

  //kubernetes的信息
  "kubernetes": {
      "k8s_api_root":"https://10.96.0.1:443",
      "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
  }
}
```
