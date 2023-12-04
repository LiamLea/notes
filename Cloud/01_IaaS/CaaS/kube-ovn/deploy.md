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
      - [2.版本要求](#2版本要求)
      - [3.修改neutron和ovs配置（已安装的情况下）](#3修改neutron和ovs配置已安装的情况下)
        - [(1) 修改neutron配置](#1-修改neutron配置)
        - [(2) 修改openvswitch配置](#2-修改openvswitch配置)
        - [(3) 需要配置openstack网络](#3-需要配置openstack网络)
      - [4.neutron和ovs配置（初始化安装）](#4neutron和ovs配置初始化安装)
      - [5.测试](#5测试)
        - [(1) 进一步验证](#1-进一步验证)

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

#### 2.版本要求
ovn-controller版本要尽量一致，大版本一定要一样，否则会不兼容

* 查看openstack侧ovn-controller版本
```shell
docker exec -it ovn_controller
ovn-controller --version
```

* 查看kube-ovn侧ovn-controller版本
```shell
kubectl exec -it -n kube-system ovn-central-86b6bcff56-pwqdt -- /bin/bash
ovn-controller --version
```

#### 3.修改neutron和ovs配置（已安装的情况下）

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

#### 4.neutron和ovs配置（初始化安装）

* enable ovn
  * 不同版本配置有所区别，具体参考文档
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

#### 5.测试

* 查看vpc
```shell
$ kubectl get vpc

NAME                                           ENABLEEXTERNAL   STANDBY   SUBNETS                                                                                                  NAMESPACES
neutron-6b412af2-5e61-461e-b93e-1549c4f45251   false            true      ["net2","neutron-8c0f90c1-3b87-4aae-ae73-a87e98eb8849","neutron-9bd921d6-d451-4c25-802a-42f6b9991db8"]   
ovn-cluster                                    false            true      ["join","ovn-default","subnet1"]            
```

* 将namespace加入vpc
```shell
kubectl create ns net2
kubetl edit vpc neutron-6b412af2-5e61-461e-b93e-1549c4f45251
```
```yaml
...
spec:
  namespaces:
  - net2
...
```

* 创建subnet
```yaml
kind: Subnet
apiVersion: kubeovn.io/v1
metadata:
  name: net2
spec:
  vpc: neutron-6b412af2-5e61-461e-b93e-1549c4f45251
  namespaces:
    - net2
  cidrBlock: 10.67.0.0/24
  gateway: 10.67.0.1
  natOutgoing: false
```

* 查看subnet是否创建成功
  * 如果配置正确但未成功，重启 ovn-controller
```shell
kubectl get subnet
#看V4AVAILABLE是否有可用地址，如果没有证明创建的有问题
```

* 创建pod
  * 如果配置正确但未成功，重启 ovn-controller
  * 还不成功，重启机器
```yaml
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

* 验证
  * 查看subnet是否生效
  ```shell
  kubectl get pods -n net2 -o wide
  ```
  * 从pod中ping openstack的虚拟机
  ```shell
  kubectl exec -n net2  -it ubuntu /bin/bash
  ping <vm_ip>
  ```

##### (1) 进一步验证
在openstack中创建网络，查看ovn-controller日志是否有报错
```shell
cat /var/log/kolla/openvswitch/ovn-controller.log

#比如: 下面这个日志就说明openstack侧ovn-controller和kube-ovn侧的不兼容
#2023-12-03T08:35:51.087Z|00022|lflow|WARN|error parsing match "ip && ip4.dst == 10.172.1.54 && inport == "lrp-ee28436d-8c55-4f2c-8e08-7afee95d2ea8" && flags.loopback == 1 && flags.use_snat_zone == 1 && is_chassis_resident("cr-lrp-ee28436d-8c55-4f2c-8e08-7afee95d2ea8")": Syntax error at `flags.use_snat_zone' expecting field name.
```