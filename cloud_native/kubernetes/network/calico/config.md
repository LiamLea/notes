# config

[toc]

### calicoctl

有些是能够通过kubectl查看的，有些是不能的（安装了calico的apiserver就都可以了）
#### 1.查看pod的网卡信息
```shell
./calicoctl get WorkloadEndpoint -A
./calicoctl get WorkloadEndpoint -n kube-system -o yaml
./calicoctl get node -o yaml
```

***

### 配置bgp

#### 1.默认配置

bgp的默认配置查看容器内的：`/etc/calico/confd/config/bird.cfg`文件

#### 2.添加一条peer记录
当跨网段且存在nat gateway时，需要添加一下peer，否则bgp无法工作
比如：
|主机名|ip|说明|
|-|-|-|
|master-1|3.1.5.114||
|node-1|3.1.5.115||
|node-2|3.1.4.114|当从3.1.5.114访问3.1.4.114时，3.1.4.114看到的源ip是3.1.4.254|

* peer.yaml
```yaml
apiVersion: projectcalico.org/v3
kind: BGPPeer
metadata:
  name: node-2-peer
spec:
  peerIP: 3.1.4.254
  asNumber: 64512
  node: node-2
```

* 创建peer
```shell
calicoctl apply -f peer.yaml
```

* 再次查看`/etc/calico/confd/config/bird.cfg`文件
```shell
# ------------- Node-to-node mesh -------------

# For peer /host/master-1/ip_addr_v4
protocol bgp Mesh_3_1_5_114 from bgp_template {
  neighbor 3.1.5.114 as 64512;
  source address 3.1.4.114;  # The local address we use for the TCP connection
  passive on; # Mesh is unidirectional, peer will connect to us.
}



# For peer /host/node-1/ip_addr_v4
protocol bgp Mesh_3_1_5_115 from bgp_template {
  neighbor 3.1.5.115 as 64512;
  source address 3.1.4.114;  # The local address we use for the TCP connection
  passive on; # Mesh is unidirectional, peer will connect to us.
}


# For peer /host/node-2/ip_addr_v4
# Skipping ourselves (3.1.4.114)


# ------------- Global peers -------------
# No global peers configured.


# ------------- Node-specific peers -------------


# For peer /host/node-2/peer_v4/3.1.4.254
protocol bgp Node_3_1_4_254 from bgp_template {
  neighbor 3.1.4.254 as 64512;
  source address 3.1.4.114;  # The local address we use for the TCP connection
}

```

***

### 配置Felix

#### 1.FelixConfiguration配置文件

```shell
kubectl edit FelixConfiguration default
```
```yaml
apiVersion: crd.projectcalico.org/v1
kind: FelixConfiguration
metadata:
  name: default
spec:
  ...
```

***

### 配置calico-node

#### 1.配置用于路由的ip
直接指定ip，不通过自动发现（nodeAddressAutodetectionV4）

```shell
calicoctl patch node <node_name> \
  --patch='{"spec":{"bgp": {"ipv4Address": "10.0.3.127/24"}}}'
```
