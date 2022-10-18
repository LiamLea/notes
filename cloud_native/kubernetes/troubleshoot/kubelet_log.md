# kubelet log分析

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kubelet log分析](#kubelet-log分析)
    - [代码模块](#代码模块)
      - [1.`kubelet.go`](#1kubeletgo)
      - [2.`server.go`](#2servergo)
      - [3.`kubelet_node_status.go`、](#3kubelet_node_statusgo)
      - [4.`pod_workers.go`](#4pod_workersgo)
        - [5.`eviction_manager`](#5eviction_manager)

<!-- /code_chunk_output -->

### 代码模块

#### 1.`kubelet.go`
与 kubelet进程 有关的日志

#### 2.`server.go`
与 apiserver 有关的日志

#### 3.`kubelet_node_status.go`、
与 node状态 有关的日志

#### 4.`pod_workers.go`
与 pod状态 有关的日志

##### 5.`eviction_manager`
与 驱逐pod 有关的日志
