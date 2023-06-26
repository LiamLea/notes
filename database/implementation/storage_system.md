# storage system


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [storage system](#storage-system)
    - [概述](#概述)
      - [1.存储体系](#1存储体系)
        - [(1) 文件系统](#1-文件系统)
        - [(2) 内存](#2-内存)
        - [(3) 磁盘HDD](#3-磁盘hdd)
      - [2.DBMS数据存储](#2dbms数据存储)
        - [(1) 映射关系](#1-映射关系)
        - [(2) 基本架构](#2-基本架构)

<!-- /code_chunk_output -->

### 概述

#### 1.存储体系

![](./imgs/ss_01.png)

##### (1) 文件系统
![](./imgs/ss_02.png)

##### (2) 内存
![](./imgs/ss_03.png)

##### (3) 磁盘HDD
物理存取算法考虑的关键：
* 降低I/O次数
* 降低寻道/旋转延迟时间：
    * 同一磁道连续存储
    * 同一柱面不同磁道并行存储
    * 多个磁盘并行存储

#### 2.DBMS数据存储

##### (1) 映射关系
![](./imgs/ss_04.png)

##### (2) 基本架构
![](./imgs/ss_05.png)