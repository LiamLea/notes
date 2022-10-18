# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.使用OVN的效果](#1使用ovn的效果)
      - [2.OVN架构](#2ovn架构)

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
  * 存储上层所期望的状态（类似声明式API）
* Southbound DB
  * 存储逻辑流（即逻辑连接）
* northd
  * 在Northbound DB和Southbound DB中间进行转换
* controller
  * 将逻辑流转换为物理流（即进行网络配置）
