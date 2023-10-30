# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.使用OVN的效果](#1使用ovn的效果)
      - [2.OVN架构](#2ovn架构)
    - [Northbound](#northbound)
    - [southbound](#southbound)
        - [(1) 数据流](#1-数据流)

<!-- /code_chunk_output -->

### 概述

#### 1.使用OVN的效果
![](./imgs/overview_01.png)
* HV: hypervisor，即部署了OVN的设备
* 同一个颜色表示同一个vlan
* 物理连接很简单，通过SDN实现复杂的逻辑连接

#### 2.OVN架构
![](./imgs/overview_02.png)
![](./imgs/overview_03.png)

* Northbound DB
  * 存储配置信息（类似声明式API）
  * 存储逻辑网络配置，即配置 虚拟出的设备和连接（不具体到某台机器的配置）
* Southbound DB
  * 目的是使得这些虚拟设备在各个物理机上连接起来（即建立隧道等）
  * 存储 具体机器的网络配置 和 具体的数据流
    * 即 哪些虚拟的设备(比如端口等) 配置在 哪些具体的机器上
    * 其他一些虚拟的设备 每台都要配置

* northd
  * 在Northbound DB和Southbound DB中间进行转换

* ovn-controller
  * 是OVN的agent，每个hypervisor上都有一个
  * 用于读取southerbound DB数据，配置OVS

* CMS (Cloud Management System)
  * 用于操作OVN的客户端

***

### Northbound

* 列出配置信息（逻辑网络）

```python
$ ovn-nbct show

"""
展示了 逻辑网络和连接 （即需要创建的虚拟设备和连接）

format:

<device_type> <id> <alias>
- <port>
        <type>
        <addresses> or <remote_port>
"""

switch 87f5c3c8-7275-4e46-8506-416d75e9d24b (neutron-9bd921d6-d451-4c25-802a-42f6b9991db8) (aka public1)
    port provnet-91270315-0043-4282-8c10-4804b15105d4
        type: localnet
        addresses: ["unknown"]
    port a9eb8a65-b994-4589-9e77-16b374eefe77
        type: router
        router-port: lrp-a9eb8a65-b994-4589-9e77-16b374eefe77
    port 835757c0-e56d-4dd1-b9e0-0e97c49ff2eb
        type: localport
        addresses: ["fa:16:3e:f6:fd:34"]
switch b0dd1c61-5dbc-4a02-a7b8-86f15a339ee9 (neutron-8c0f90c1-3b87-4aae-ae73-a87e98eb8849) (aka demo-net)
    port cb234a44-e63d-40c0-b615-e0e2471eab82
        addresses: ["unknown"]
    port 927abadc-1f68-481a-a009-ec2fd6985c50
        type: localport
        addresses: ["fa:16:3e:12:6b:10 3.1.5.1"]
    port 4a31cedb-095d-49d9-afbc-4f3627f69195
        type: router
        router-port: lrp-4a31cedb-095d-49d9-afbc-4f3627f69195
switch 3038d4e6-3dd0-485c-ba19-06622e03657d (ovn-default)
    port coredns-555d9f6546-nxmdd.kube-system
        addresses: ["00:00:00:0E:4D:40 10.244.0.9"]
    port kube-ovn-pinger-95x6v.kube-system
        addresses: ["00:00:00:46:5C:65 10.244.0.10"]
    port kube-ovn-pinger-kp6nl.kube-system
        addresses: ["00:00:00:E4:E5:5A 10.244.0.12"]
    port kube-ovn-pinger-zns6f.kube-system
        addresses: ["00:00:00:3F:4E:F3 10.244.0.11"]
    port ovn-default-ovn-cluster
        type: router
        router-port: ovn-cluster-ovn-default
    port ubuntu.default
        addresses: ["00:00:00:F0:E3:A9 10.244.0.2"]
    port coredns-555d9f6546-g88mb.kube-system
        addresses: ["00:00:00:8F:BC:A3 10.244.0.8"]
switch eb4092e2-c0c7-4da9-9dea-b3b12ccecfe6 (subnet1)
    port ubuntu.test
        addresses: ["00:00:00:62:31:48 10.66.0.2"]
    port subnet1-ovn-cluster
        type: router
        router-port: ovn-cluster-subnet1
switch 2221dbcb-d91c-4709-a5e1-820d2c936648 (join)
    port join-ovn-cluster
        type: router
        router-port: ovn-cluster-join
    port node-master-3
        addresses: ["00:00:00:B6:B3:BB 100.64.0.3"]
    port node-master-1
        addresses: ["00:00:00:2F:04:AA 100.64.0.2"]
    port node-master-2
        addresses: ["00:00:00:F6:EB:66 100.64.0.4"]
router d6c69fd5-58f6-4415-a288-7b20c9aacee3 (ovn-cluster)
    port ovn-cluster-ovn-default
        mac: "00:00:00:E8:AD:19"
        networks: ["10.244.0.1/16"]
    port ovn-cluster-subnet1
        mac: "00:00:00:14:E7:D9"
        networks: ["10.66.0.1/16"]
    port ovn-cluster-join
        mac: "00:00:00:27:E6:BD"
        networks: ["100.64.0.1/16"]
router 20594965-2b2e-4b01-8dc3-dd35f532a785 (neutron-6b412af2-5e61-461e-b93e-1549c4f45251) (aka demo-router)
    port lrp-4a31cedb-095d-49d9-afbc-4f3627f69195
        mac: "fa:16:3e:88:d0:36"
        networks: ["3.1.5.254/24"]
    port lrp-a9eb8a65-b994-4589-9e77-16b374eefe77
        mac: "fa:16:3e:43:5a:89"
        networks: ["10.172.1.59/24"]
        gateway chassis: [openstack-1]
    nat 0bd54b92-46fc-40cf-a20b-3179e18dbefc
        external ip: "10.172.1.59"
        logical ip: "3.1.5.0/24"
        type: "snat"

```

***

### southbound

* 列出虚拟设备与机器的绑定关系
```python
$ ovn-sbctl show

"""
展示了 虚拟设备与机器的绑定关系
一个chassis就是一个intergration bridge（用于内部连接和隧道连接，即将br-int和br-tun合并为一个br-int）

format:

Chassis <host_id>
    hostname: <hostname>
    Encap: <encapsulation_protocol>
        ip: <host_ip>
    - Port_Binding <port_name>
"""

Chassis "e18d0f09-f2c7-4f25-9c82-fd392c2d826d"
    hostname: master-2
    Encap geneve
        ip: "10.172.1.201"
        options: {csum="true"}
    Port_Binding coredns-555d9f6546-nxmdd.kube-system
    Port_Binding ubuntu.test
    Port_Binding kube-ovn-pinger-95x6v.kube-system
    Port_Binding node-master-2
Chassis openstack-1
    hostname: openstack-1
    Encap geneve
        ip: "10.172.1.241"
        options: {csum="true"}
    Port_Binding "cb234a44-e63d-40c0-b615-e0e2471eab82"
    Port_Binding cr-lrp-a9eb8a65-b994-4589-9e77-16b374eefe77
Chassis "91dfd8e5-15ca-4d67-9b5e-e814d5769998"
    hostname: master-3
    Encap geneve
        ip: "10.172.1.235"
        options: {csum="true"}
    Port_Binding node-master-3
    Port_Binding kube-ovn-pinger-zns6f.kube-system
Chassis "71960acb-6ee2-43fc-9faf-be4221ab289a"
    hostname: master-1
    Encap geneve
        ip: "10.172.1.132"
        options: {csum="true"}
    Port_Binding kube-ovn-pinger-kp6nl.kube-system
    Port_Binding node-master-1
    Port_Binding ubuntu.default
    Port_Binding coredns-555d9f6546-g88mb.kube-system
Chassis openstack-2
    hostname: openstack-2
    Encap geneve
        ip: "10.172.1.46"
        options: {csum="true"}
    Port_Binding "3f761cc6-3f49-443a-8232-2721550b6bba"
```

##### (1) 数据流

* 列出整个数据流
```shell
$ ovn-sbctl lflow-list
```

* 列出有哪些datapath（即数据流）
```shell
$ ovn-sbctl count-flows
```

* 某个datapath的数据流
```shell
$ ovn-sbctl lflow-list <datapath>
```
