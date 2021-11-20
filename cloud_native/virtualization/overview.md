# overview

[toc]

### 概述

#### 1.hypervisor（虚拟层，管理程序）
模拟底层硬件
占用物理资源，并将资源分配给虚拟机
hypervisor可以装在操作系统上，也可以直接装在硬件上

#### 2.两类hypervisor

##### （1）bare metal
hypervisor装在裸机上，所以hypervisor本身也是操作系统

* vmware vSphere with ESXi

* KVM
  * linux内核自带的功能（需要加载kvm_intel模块）
  * 能够 将linux 转换成 hypervisor

* Microsoft Hyper-V

##### （2）hosted
hypervisor装在操作系统上（一般用于测试和实验环境）

* Oracle VM VirtualBox
* VMware Workstation
* qemu hypervisor


#### 3.虚拟机分配
虚拟机是具体分配在某个物理机上的，不会跨物理机，所以虚拟机的CPU和memory也是用的同一台物理机上的

#### 4.物理cpu支持虚拟化
支持虚拟化的cpu会有`ring -1`级别，这样虚拟机就能够跑在`ring 0`级别上了，就感知不到自己是虚拟机了

#### 5.cpu分配
无法给 一个虚拟机 分配 比其宿主机逻辑核 更多的cpu核
给 多个虚拟机 分配的cpu总核数 可以超过 其宿主机逻辑核数
