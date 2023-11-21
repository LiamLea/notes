# ironic


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [ironic](#ironic)
    - [概述](#概述)
      - [1.流程概述](#1流程概述)
        - [(1) PXE详细流程](#1-pxe详细流程)
        - [(2) 部署用户镜像 (PXE完成后)](#2-部署用户镜像-pxe完成后)
    - [deploy](#deploy)
      - [1.修改配置](#1修改配置)
      - [2.部署](#2部署)
    - [使用](#使用)
      - [1.下载并上传deploy kernel和ramdisk](#1下载并上传deploy-kernel和ramdisk)
      - [2.创建flavor](#2创建flavor)
      - [3.创建节点](#3创建节点)
        - [(1) 创建节点](#1-创建节点)
        - [(2) 创建该节点上用于PXE装机的网口](#2-创建该节点上用于pxe装机的网口)
        - [(3) 节点元数据设置 (可选的)](#3-节点元数据设置-可选的)
      - [4.使该节点avaliable](#4使该节点avaliable)
      - [5.检查该节点验证状态](#5检查该节点验证状态)
      - [6.deploy instance](#6deploy-instance)
    - [troubleshooting](#troubleshooting)
      - [1.debug deploy](#1debug-deploy)
        - [(1) 设置deploy image的root密码](#1-设置deploy-image的root密码)
      - [2.node需要支持ipmi控制boot device](#2node需要支持ipmi控制boot-device)

<!-- /code_chunk_output -->

### 概述

#### 1.流程概述

[具体参考](https://docs.openstack.org/ironic/zed/user/architecture.html)

* 通过ipmi管理机器
* 通过dnsmasq提供DHCP、TFTP、HTTP服务，进行PXE装机
* 通过临时内核（即deploy kernel） 运行指定 镜像

##### (1) PXE详细流程
* 通过**neutron-dhcp**组件，提供**dnsmasq**服务
    * 只要有一个subnet开启了DHCP功能，则neutron-dhcp组件中就有一个dnsmasq服务（这个服务可能当该subnet中创建虚拟机时，才启动）
    * dnsmasq**动态**读取DHCP option的配置
        * 当进行deploy bare-metal时，这个文件才会动态更新
        * dnsmasq动态读取的配置比如: `--dhcp-optsfile=/var/lib/neutron/dhcp/12d490a4-b678-449d-9964-3468cce9040f/opts`
    * 会根据 相关配置和bare-metal的信息，来动态配置**DHCP option**
        * TFTP地址、HTTP地址
        * **PXE引导文件**
            * 这个文件很重要，不同的boot mode、cpu架构、pxe或是ipxe 需要不同的引导文件，如果返回的不对，则无法装机

                * ipxe
                    * boot.ipxe都支持
                * pxe
                    * 能够支持uefi boot mode的引导文件: snponly.efi、pxelinux.0等
                    * 能够支持BIOS (leagcy) boot mode的引导文件: undionly.kpxe、bootx64.efi等
        * 比如:
        ```python
        #根据节点不同的boot mode返回的pxe引导文件不一样
        #默认boot mode为uefi，返回的
        #   tag:port-e45ac34b-351b-488e-8447-6f1b7059adf9,tag:!ipxe,67,snponly.efi
        #当标记node的boot mode为BIOS(leagcy)，返回的则是undionly.kpxe
        tag:port-82eabc97-dd1d-4826-b8b4-c35e6d41127c,tag:!ipxe,67,undionly.kpxe
        tag:port-82eabc97-dd1d-4826-b8b4-c35e6d41127c,255,172.16.1.100
        tag:port-82eabc97-dd1d-4826-b8b4-c35e6d41127c,66,172.16.1.100
        tag:port-82eabc97-dd1d-4826-b8b4-c35e6d41127c,tag:ipxe,67,http://172.16.1.100:8089/boot.ipxe
        tag:port-82eabc97-dd1d-4826-b8b4-c35e6d41127c,150,172.16.1.100
        ```
* bare-metal根据获取的信息去TFTP (PXE) 或 HTTP (iPXE) 下载指定文件
* 根据配置的deploy kernel和deploy ramdisk进行PXE装机
    * 运行临时的操作系统

##### (2) 部署用户镜像 (PXE完成后)
* 临时的操作系统上会运行IPA(ironic-python-agent) 这个程序
    * ironic-controller控制这个程序来安装用户镜像
    * 当安装成功后，IPA会通知ironic-controller

***

### deploy

[参考](https://docs.openstack.org/kolla-ansible/train/reference/bare-metal/ironic-guide.html)

#### 1.修改配置

```shell
vim /etc/kolla/globals.yml
```
```yaml
enable_ironic: "yes"

#默认为{{ network_interface }}，即内部通信网卡
ironic_dnsmasq_interface: "eth1"

#使用public网络（这里的作用待确认）
ironic_cleaning_network: "public1"

#分配给bare metal的ip
ironic_dnsmasq_dhcp_ranges:
- range: "10.10.10.100,10.10.10.110,255.255.255.0"
  routers: "10.10.10.254"

#enable iPXE
enable_ironic_ipxe: "yes"
ironic_ipxe_port: "8089"

#ironic inspector相关配置
#ironic inspector使用的pxe引导文件
ironic_dnsmasq_boot_file: pxelinux.0
#ironic inspector内核的参数
ironic_inspector_kernel_cmdline_extras: ['ipa-lldp-timeout=90.0', 'ipa-collect-lldp=1']
```

#### 2.部署
```shell
kolla-ansible -i ./multinode deploy
```

***

### 使用

#### 1.下载并上传deploy kernel和ramdisk
```shell
curl https://tarballs.openstack.org/ironic-python-agent/dib/files/ipa-centos7-master.kernel \
  -o /etc/kolla/config/ironic/ironic-agent.kernel

curl https://tarballs.openstack.org/ironic-python-agent/dib/files/ipa-centos7-master.initramfs \
  -o /etc/kolla/config/ironic/ironic-agent.initramfs

openstack image create --disk-format aki --container-format aki --public \
  --file /etc/kolla/config/ironic/ironic-agent.kernel deploy-vmlinuz

openstack image create --disk-format ari --container-format ari --public \
  --file /etc/kolla/config/ironic/ironic-agent.initramfs deploy-initrd
```

#### 2.创建flavor
```shell
#根据机器真实情况设置
export RAM_MB=1024
export CPU=2
export DISK_GB=100

openstack flavor create my-baremetal-flavor \
  --ram $RAM_MB --disk $CPU --vcpus $DISK_GB \
  --property resources:CUSTOM_BAREMETAL_RESOURCE_CLASS=1 \
  --property resources:VCPU=0 \
  --property resources:MEMORY_MB=0 \
  --property resources:DISK_GB=0
```

#### 3.创建节点

##### (1) 创建节点
```shell
  openstack baremetal node create --driver ipmi --name baremetal-node \
  --driver-info ipmi_port=623 --driver-info ipmi_username=admin \
  --driver-info ipmi_password='Pass@w0rd' \
  --driver-info ipmi_address=172.16.1.50 \
  --resource-class baremetal-resource-class --property cpus=$CPU  \
  --property memory_mb=$RAM_MB --property local_gb=$DISK_GB \
  --property cpu_arch=x86_64 \
  --driver-info deploy_kernel=609c74d0-6e16-4553-9ef4-50d6a441ae2b \
  --driver-info deploy_ramdisk=682729b4-c14a-41d7-8c13-bbfa92d2fc85 \
  --property capabilities='boot_mode:bios'

#--property capabilities='boot_mode:bios'指定boot mode为BIOS (leagcy)
#   其他值 boot_mode:uefi
#   虽然该节点的boot leagcy设置的是UEFI and Leacy，但是通过抓包发现，Option 93=0（表示boot mode是BIOS），所以这里需要明确指定一下
#   参考: https://docs.openstack.org/ironic/zed/install/advanced.html#boot-mode-support
```

##### (2) 创建该节点上用于PXE装机的网口
```shell
export NODEID="1133a249-1898-4098-8d58-2fe89a09dc55"
openstack baremetal port create 08:94:EF:9B:CC:EE \
  --node $NODEID \
  --physical-network physnet1
```

##### (3) 节点元数据设置 (可选的)

* [deploy内核参数](https://docs.openstack.org/ironic/zed/admin/interfaces/boot.html)
* [镜像信息](https://docs.openstack.org/ironic/zed/admin/interfaces/deploy.html)

#### 4.使该节点avaliable
```shell
openstack baremetal node manage $NODEID
openstack baremetal node provide $NODEID
```

#### 5.检查该节点验证状态
```shell
openstack baremetal node validate $NODEID
```
* 只要关注: 
    * boot、management、network、power为True就行了
    * deploy如果没有通过节点的metadata，就会为Fasle，当有deploy时，有instance被分配到该节点就会为True

```
+------------+--------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Interface  | Result | Reason                                                                                                                                                    |
+------------+--------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| bios       | False  | Driver ipmi does not support bios (disabled or not implemented).                                                                                          |
| boot       | True   |                                                                                                                                                           |
| console    | False  | Driver ipmi does not support console (disabled or not implemented).                                                                                       |
| deploy     | False  | Node 1133a249-1898-4098-8d58-2fe89a09dc55 failed to validate deploy image info. Some parameters were missing. Missing are: ['instance_info.image_source'] |
| inspect    | False  | Driver ipmi does not support inspect (disabled or not implemented).                                                                                       |
| management | True   |                                                                                                                                                           |
| network    | True   |                                                                                                                                                           |
| power      | True   |                                                                                                                                                           |
| raid       | False  | Driver ipmi does not support raid (disabled or not implemented).                                                                                          |
| rescue     | False  | Driver ipmi does not support rescue (disabled or not implemented).                                                                                        |
| storage    | True   |                                                                                                                                                           |
+------------+--------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+

```

#### 6.deploy instance
```shell
openstack server create --image cirros --flavor my-baremetal-flavor \
 --network public1 demo
```

***

### troubleshooting

#### 1.debug deploy

[参考](https://docs.openstack.org/ironic-python-agent/zed/admin/troubleshooting.html)

##### (1) 设置deploy image的root密码

* 官方提供的deploy kernel默认开启了[dynamic-login](https://github.com/openstack/diskimage-builder/tree/master/diskimage_builder/elements/dynamic-login)功能

* 将root密码进行加密
```shell
$ openssl passwd -1 -stdin <<< cangoal | sed 's/\$/\$\$/g'
#对$进行转义
$$1$$NdWMb6x7$$F66z7yk1d5NHUeMoxn/st/
```

* 修改配置文件: `/etc/ironic/ironic.conf`
```shell
$ vim /etc/kolla/ironic-conductor/ironic.conf
#将rootpwd="$$1$$NdWMb6x7$$F66z7yk1d5NHUeMoxn/st/"添加到kernel_append_params（老版本是pxe_append_params）中
```

* 重启ironic-conductor容器

* 进行instance部署
    * 就可以使用root/cangoal登陆到deploy image中进行debug

#### 2.node需要支持ipmi控制boot device

* node能够通过ipmi去控制boot device（比如pxe、disk等）
* 如果不支持，需要手动进BIOS调
    * 将disk启动放在pxe前面
    * 重新安装instance时，需要disk格式化了，否则会从disk启动，无法从pxe启动