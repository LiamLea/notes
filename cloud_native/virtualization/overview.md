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
