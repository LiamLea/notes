# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.Hadoop MapReduce](#1hadoop-mapreduce)
        - [(1) 基本架构](#1-基本架构)
        - [(2) 执行过程](#2-执行过程)

<!-- /code_chunk_output -->

### 概述

#### 1.Hadoop MapReduce

##### (1) 基本架构

* client
    * 提交作业
    * 查看状态

* JobTracker (master)
    * 接受MapReduce任务
    * 分配任务给Worker
    * 监控任务
    * 处理错误

* TaskTracker (worker)
    * 管理本地的Map和Reduce任务
    * 管理中间输出

* Task
    * 一个独立的进程，运行Map/Reduce函数

##### (2) 执行过程
![](./imgs/hpmp_01.png)
![](./imgs/hpmp_02.png)
![](./imgs/hpmp_03.png)