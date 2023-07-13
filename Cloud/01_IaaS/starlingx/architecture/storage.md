# storage

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [storage](#storage)
    - [概述](#概述)
      - [1.有三类存储](#1有三类存储)
      - [2.controoler-fs包括](#2controoler-fs包括)
      - [3.数据同步技术：drbd（distributed replicated block device）](#3数据同步技术drbddistributed-replicated-block-device)
    - [使用](#使用)
      - [1.查看存储](#1查看存储)

<!-- /code_chunk_output -->

### 概述

#### 1.有三类存储

|存储|说明|
|-|-|
|controller-fs|controller节点上需要同步的文件系统|
|host-fs|host节点上（包括controller）不需要同步的文件系统|
|storage backend|k8s后端（即pvc）使用的存储|

#### 2.controoler-fs包括

|文件系统名|用途|
|-|-|
|platform|用于平台文件的存储|
|database|用于postgres（即平台数据）|
|docker-registry|用于镜像仓库|
|etcd|用于etcd|
|Ceph-mon|用于ceph-mon|
|extension|保留给未来使用|


#### 3.数据同步技术：drbd（distributed replicated block device）

* 原理：
在两台主机上，通过分区创建两个块设备（主从关系），进行数据同步，只有主设备能被挂载

* 配置文件：`/etc/drbd.conf`

* 查看命令

```shell
$ drbd-overview

#drbd编号                    #当前节点的状态/另一个节点的状态          #当前节点的数据状态/另一个节点的数据状态
0:drbd-pgsql/0               Connected Primary/Secondary            UpToDate/UpToDate C r----- /var/lib/postgresql          ext4 20G  119M 19G  1%
1:drbd-rabbit/0              Connected Primary/Secondary            UpToDate/UpToDate C r----- /var/lib/rabbitmq            ext4 2.0G 6.2M 1.9G 1%

#节点状态：
# WFConnection Primary  表示该节点是primary节点，正在等待连接（wait for connection）
# Connected Primary     表示该节点是primary节点，已经被连接

#数据状态：
# UpToDate  表示数据已经同步
# OutOfDate 表示数据还未同步
```

***

### 使用

#### 1.查看存储

* 查看k8s后端使用的存储
```shell
system storage-backend-list
system storage-backend-show <uuid>
```
