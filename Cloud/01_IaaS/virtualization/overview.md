# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.hypervisor（虚拟层，管理程序）](#1hypervisor虚拟层管理程序)
      - [2.两类hypervisor](#2两类hypervisor)
        - [（1）bare metal](#1bare-metal)
        - [（2）hosted](#2hosted)
      - [3. full virtulization vs paravirtulization](#3-full-virtulization-vs-paravirtulization)
        - [（1）paravirtualizatio常用的设备驱动标准： virtio](#1paravirtualizatio常用的设备驱动标准-virtio)
      - [4.其他](#4其他)
        - [（1）虚拟机分配](#1虚拟机分配)
        - [（2）物理cpu支持虚拟化](#2物理cpu支持虚拟化)
        - [（3）cpu分配](#3cpu分配)

<!-- /code_chunk_output -->

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


#### 3. full virtulization vs paravirtulization

||full virtualization|paravirtualization|
|-|-|-|
|本质区别|需要模拟真实的物理设备，导致性能很差（虚拟机的device driver不知道自己是虚拟机）|虚拟机的device driver知道自己是虚拟机，会和hypervisor配合，从而性能会提高很多|
|额外依赖|无|虚拟机依赖特殊的设备驱动（比如virtio），才能识别虚拟的设备|

![](./imgs/overview_01.png)

##### （1）paravirtualizatio常用的设备驱动标准： virtio
virtio是磁盘和网络设备驱动的标准，用于半虚拟化
virtio和e1000等比较，virtio是半虚拟化设备驱动，e1000是完全虚拟化的，所以virtio性能更好

#### 4.其他

##### （1）虚拟机分配
虚拟机是具体分配在某个物理机上的，不会跨物理机，所以虚拟机的CPU和memory也是用的同一台物理机上的

##### （2）物理cpu支持虚拟化
支持虚拟化的cpu会有`ring -1`级别，这样虚拟机就能够跑在`ring 0`级别上了，就感知不到自己是虚拟机了

##### （3）cpu分配
无法给 一个虚拟机 分配 比其宿主机逻辑核 更多的cpu核
给 多个虚拟机 分配的cpu总核数 可以超过 其宿主机逻辑核数
