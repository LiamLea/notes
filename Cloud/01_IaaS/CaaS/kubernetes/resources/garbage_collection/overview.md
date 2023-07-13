# garbage collection

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [garbage collection](#garbage-collection)
    - [概述](#概述)
      - [1.GC的对象](#1gc的对象)
      - [2.对象的关系：owner和dependents](#2对象的关系owner和dependents)
      - [3.finalizers](#3finalizers)
      - [4.删除方式](#4删除方式)
        - [（1）后台删除（默认）](#1后台删除默认)
        - [（2）前台删除](#2前台删除)
        - [（3）孤儿资源](#3孤儿资源)
      - [5.容器和镜像的回收](#5容器和镜像的回收)
        - [（1）镜像回收](#1镜像回收)
        - [（2）容器回收](#2容器回收)

<!-- /code_chunk_output -->

### 概述

[参考文档](https://kubernetes.io/docs/concepts/architecture/garbage-collection/)

#### 1.GC的对象

* failed pods
* completed jobs
* owner reference指向的对象不存在或正在被删除的对象（孤儿资源）
* 未使用的容器和镜像
* 回收策略为deletetion的pv


#### 2.对象的关系：owner和dependents

通过owner reference来建立对象之前的关系

#### 3.finalizers
是对象的一个属性，定义需要满足什么样的条件才能删除该对象
finalizers是一个列表，列表里存放需要满足的条件
每当满足其中一个条件，就会从列表中删除该条件，直到列表为空，才会删除该对象


#### 4.删除方式

##### （1）后台删除（默认）
立即删除指定的对象，然后慢慢删除 依赖该对象的其他对象（通过其他对象的owner reference找出）

##### （2）前台删除
先删除 依赖该对象的其他对象，然后再删除该对象

##### （3）孤儿资源
只删除指定的对象，不删除依赖该对象的其他对象（则这些对象被称为孤儿资源）



#### 5.容器和镜像的回收
kubelet会定期检查，进行容器和镜像的回收

##### （1）镜像回收

磁盘使用率超过上限阈值（image-gc-high-threshold）将触发垃圾回收
垃圾回收将删除最近最少使用的镜像，直到磁盘使用率满足下限阈值（image-gc-low-threshold）

##### （2）容器回收
根据下面三个参数进行容器的回收（kubelet只回收自己管理的容器）
`minimum-container-ttl-duration`、`maximum-dead-containers-per-container`、`maximum-dead-containers`
