# KVM

[toc]

### 概述

#### 1.KVM（kernel virtual machine）


#### 2.构建KVM虚拟化服务器平台
|依赖技术|说明|所需软件|
|-|-|-|
|kvm（kernel virtual machine）|能够 将linux 转换成 hypervisor（需要CPU的支持,采用硬件辅助虚拟化技术）|kvm_intel内核模块|
|qemu（quick emulation）|是一个虚拟化的仿真工具,通过ioctl与内核kvm交互完成对硬件的虚拟化支持|qemu-kvm|
|libvirt（library virtualization）|虚拟化管理工具，提供接口对qemu、kvm等进行管理|libvirt-daemo</br>libvirt-daemon-driver-qemu（libvirtd 连接 qemu 的驱动）</br>libvirt-client|

##### （1）主要软件包
* qemu-kvm	:为 kvm 提供底层仿真支持
* libvirt-daemon	:libvirtd 守护进程,管理虚拟机
* libvirt-client	:用户端软件,提供客户端管理命令
* libvirt-daemon-driver-qemu	:libvirtd 连接 qemu 的驱动
* virt-manager	:图形管理工具

##### （2）虚拟化服务：libvirtd
##### （3）图形管理虚拟化工具:virt-manager
##### （4）虚拟机的磁盘镜像文件格式:qcow2

#### 3.一台KVM虚拟机的组成

##### （1）xml配置文件(虚拟机配置文件)
定义虚拟机的名称、UUID、CPU、内存、虚拟磁盘、网卡等各种参数设置(`/etc/libvirt/qemu/`)

##### （2）磁盘镜像文件
保存虚拟机的操作系统及文档数据,镜像路径取决于xml配置文件中的定义(`/var/lib/libvirt/images/`)


***

### virsh管理命令
```shell
virsh  console  虚拟机名字      //真机直接管理相应虚拟机
virsh nodeinfo          //查看KVM节点(服务器)信息
virsh list [--all]      //列出虚拟机
virsh net-list [--all]  //列出虚拟网络
virsh autostart win2008     //将虚拟机设置为开机自启
virsh autostart --disable win2008   
virsh start 虚拟机名称
virsh destroy 虚拟机名称  //强制关机,都采用这种关机方式
virsh dumpxml 虚拟机名   //查看虚拟机配置文件信息,可以利用此命令导出配置文件信息
```

***

### 复制一台虚拟机
1.将虚拟机nsd01的磁盘文件复制一份,修改磁盘文件的名称
    cp  /var/lib/libvirt/images/nsd01.qcow2  /var/lib/libvirt/images/nsd02.qcow2    //复制磁盘文件

2.将虚拟机nsd01的xml文件复制一份,修改内容
    virsh dumpxml nsd01 > /xmlfile/nsd02.xml  #导出虚拟机xml文件
    vim  /xmlfile/haha.xml
      <name>nsd02</name>   //修改虚拟主机名
      UUID:   <uuid></uuid>     //删除整行内容
      file='/var/lib/libvirt/images/nsd02.qcow2'   //设置虚拟磁盘文件路径  
      <mac address='52:54:00:32:a3:aa'/>    //删除整行内容

 3.导入虚拟机信息
    virsh define /xmlfile/haha.xml     //导入虚拟机信息

 可以将第2步和第3步合为一步:virsh edit nsd01 ,直接修改保存即可

 4.删除虚拟机
]# virsh undefine  nsd02  //删除虚拟机nsd02,仅会删除/etc/libvirt/qemu/下的xml文件
