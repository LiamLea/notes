# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.架构](#1架构)

<!-- /code_chunk_output -->


### 概述

#### 1.架构
![](./imgs/overview_01.png)

* Cluster Manager
    * 集群资源管理，托管运行各个任务的driver
* Worker Node
    * 单机资源管理
* driver
    * 单任务管理
* Executor
    * 单任务执行