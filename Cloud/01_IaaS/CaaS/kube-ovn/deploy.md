# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [deploy](#deploy-1)
      - [1.下载安装脚本](#1下载安装脚本)
      - [2.修改配置](#2修改配置)
      - [3.安装](#3安装)
    - [和openstack集成](#和openstack集成)
      - [1.前提](#1前提)
      - [2.修改neutron和ovs配置（已安装的情况下）](#2修改neutron和ovs配置已安装的情况下)
        - [(1) 修改neutron配置](#1-修改neutron配置)
        - [(2) 修改openvswitch配置](#2-修改openvswitch配置)
        - [(3) 需要配置openstack网络](#3-需要配置openstack网络)
      - [2.neutron和ovs配置（初始化安装）](#2neutron和ovs配置初始化安装)
      - [3.测试](#3测试)

<!-- /code_chunk_output -->

### deploy

[参考](https://kubeovn.github.io/docs/v1.11.x/en/start/one-step-install/)

#### 1.下载安装脚本
```shell
wget https://raw.githubusercontent.com/kubeovn/kube-ovn/release-1.11/dist/images/install.sh
chmoc +x install.sh
```

#### 2.修改配置
```shell
vim install.sh
```
```yaml
#下面几个网段不能有重合
POD_CIDR="10.244.0.0/16"    #随便设置，跟其他网络不冲突即可    
POD_GATEWAY="10.244.0.1"    #根据POD_CIDR配置
SVC_CIDR="10.96.0.0/12"    #要和api-server中的service-cidr一致    
JOIN_CIDR="100.64.0.0/16" 

#下面也要根据上面的修改 进行更改
if [ "$DUAL_STACK" = "true" ]; then
  POD_CIDR="10.244.0.0/16,fd00:10:16::/64"                # Do NOT overlap with NODE/SVC/JOIN CIDR
  POD_GATEWAY="10.244.0.1,fd00:10:16::1"
  SVC_CIDR="10.96.0.0/12,fd00:10:96::/112"               # Do NOT overlap with NODE/POD/JOIN CIDR
  JOIN_CIDR="100.64.0.0/16,fd00:100:64::/64"             # Do NOT overlap with NODE/POD/SVC CIDR
  PINGER_EXTERNAL_ADDRESS="114.114.114.114,2400:3200::1"
  PINGER_EXTERNAL_DOMAIN="google.com."
  SVC_YAML_IPFAMILYPOLICY="ipFamilyPolicy: PreferDualStack"
```

#### 3.安装
```shell
./install.sh
```

***

### 和openstack集成

#### 1.前提
* openstack neutron需要使用OVN网络插件

#### 2.修改neutron和ovs配置（已安装的情况下）

##### (1) 修改neutron配置

* 修改所有网络节点的配置（即含有`/etc/kolla/neutron-server/ml2_conf.ini`文件的）
    * 如果开启了DVR，也需要修改计算节点
```shell
$ vim /etc/kolla/neutron-server/ml2_conf.ini

ovn_nb_connection = tcp:[192.168.137.176]:6641,tcp:[192.168.137.177]:6641,tcp:[192.168.137.178]:6641
ovn_sb_connection = tcp:[192.168.137.176]:6642,tcp:[192.168.137.177]:6642,tcp:[192.168.137.178]:6642
```

* 需要重启节点

##### (2) 修改openvswitch配置

* 所有节点
```shell
$ ovs-vsctl list open
$ ovs-vsctl set open . external-ids:ovn-remote=tcp:[192.168.137.176]:6642,tcp:[192.168.137.177]:6642,tcp:[192.168.137.178]:6642
$ ovs-vsctl set open . external-ids:ovn-encap-type=geneve
#本机地址，可以参考上述list的结果
$ ovs-vsctl set open . external-ids:ovn-encap-ip=192.168.137.200
```

##### (3) 需要配置openstack网络
* 删除旧的网络配置（按下述顺序）
  * 虚拟机（网卡）
  * 安全组
  * 路由器
  * 网络
* 重新配置

#### 2.neutron和ovs配置（初始化安装）

* enable ovn
  * 不能版本配置有所区别，具体参考文档
```shell
$ vim /etc/kolla/globals.yml

neutron_plugin_agent: "ovn"
neutron_ovn_distributed_fip: "no"
neutron_ovn_dhcp_agent: "yes"
```

* 配置neutron
```shell
$ vim /root/kolla-env/share/kolla-ansible/ansible/group_vars/all.yml

ovn_nb_connection: "tcp:[192.168.137.176]:6641,tcp:[192.168.137.177]:6641,tcp:[192.168.137.178]:6641"
ovn_sb_connection: "tcp:[192.168.137.176]:6642,tcp:[192.168.137.177]:6642,tcp:[192.168.137.178]:6642"
```

#### 3.测试

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: net2
---
apiVersion: kubeovn.io/v1
kind: Vpc
metadata:
  labels:
    ovn.kubernetes.io/vpc_external: "true"
  name: neutron-22040ed5-0598-4f77-bffd-e7fd4db47e93
spec:
  namespaces:
  - net2
---
kind: Subnet
apiVersion: kubeovn.io/v1
metadata:
  name: net2
spec:
  vpc: neutron-22040ed5-0598-4f77-bffd-e7fd4db47e93
  namespaces:
    - net2
  cidrBlock: 12.0.1.0/24
  natOutgoing: false
---
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  namespace: net2
spec:
  containers:
    - image: docker.io/kubeovn/kube-ovn:v1.8.0
      command:
        - "sleep"
        - "604800"
      imagePullPolicy: IfNotPresent
      name: ubuntu
  restartPolicy: Always
```