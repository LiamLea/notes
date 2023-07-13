# kubelet log分析

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kubelet log分析](#kubelet-log分析)
    - [方法](#方法)
      - [1.追踪操作pod的日志](#1追踪操作pod的日志)
    - [代码模块](#代码模块)
      - [1.`kubelet.go`](#1kubeletgo)
      - [2.`server.go`](#2servergo)
      - [3.`kubelet_node_status.go`、](#3kubelet_node_statusgo)
      - [4.`pod_workers.go`](#4pod_workersgo)
      - [5.`eviction_manager`](#5eviction_manager)
      - [6.`reconciler.go`](#6reconcilergo)

<!-- /code_chunk_output -->

### 方法

#### 1.追踪操作pod的日志

* 首先利用pod名字，找到pod的uid
* 然后利用uid。追踪相关日志
  * 可以追踪到container id
  * 可以继续利用container id去containerd中继续追踪

***

### 代码模块

#### 1.`kubelet.go`
与 kubelet进程 有关的日志

#### 2.`server.go`
与 apiserver 有关的日志

#### 3.`kubelet_node_status.go`、
与 node状态 有关的日志

#### 4.`pod_workers.go`
与 pod状态 有关的日志

#### 5.`eviction_manager`
与 驱逐pod 有关的日志

#### 6.`reconciler.go`
同步数据（比如当node重启后，kubelet需要从etcd同步最新数据）
