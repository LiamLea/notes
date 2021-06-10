# overview

[toc]

### 概述

#### 1.术语
|简称|全称|说明|
|-|-|-|
|rados|reliable autonomic distributed object store（可靠的自治分布式对象存储）|ceph的存储系统|
|CRUSH|controlled replication under scalable hashing|可扩展散列下的受控复制，ceph用于计算对象存储的位置|

#### 2.架构

##### （1）ceph monitor（ceph-mon）
* 用于**服务发现**：维护集群组件的映射（包括monitor的映射，manager的映射、OSD映射等）
  * 组件之间的沟通需要使用这些映射，才能找到彼此，所以很重要
* 负责组件和客户端之间的认证

##### （2）ceph manager（ceph-mgr）
* 对外暴露接口，用于管理和查看ceph集群
* 用于获取ceph集群的指标和信息

##### （3）ceph OSD（ceph-osd，object storage daemon）
* 运行rados服务，处理数据（包括存储、处理副本、恢复等等）
* 提供其他OSD的状态给ceph-mon和ceph-mgr

##### （4）ceph MDS（ceph-mds，metadata server）
给ceph文件系统存储元数据（块存储和对象存储不使用ceph-mds）

##### （5）rados gateway（RGW）
对外提供对象存储接口，支持两种接口（S3和swift）

##### 3.目录规划
* 日志路径：`/var/log/ceph/`
* 数据路径：`/var/lib/ceph/`
