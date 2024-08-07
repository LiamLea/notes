# ceph command

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ceph command](#ceph-command)
    - [orchestrator module：`ceph orch`](#orchestrator-moduleceph-orch)
      - [1.获取整个集群状态](#1获取整个集群状态)
      - [2.管理host：`ceph orch host`](#2管理hostceph-orch-host)
        - [（1）特殊的host标签（最新版本）：](#1特殊的host标签最新版本)
      - [3.管理service：`ceph orch <ACTION> <service_type>`](#3管理serviceceph-orch-action-service_type)
        - [（1）查看服务状态](#1查看服务状态)
        - [（2）配置daemon的placement并启动：`ceph orch apply <service_type>`](#2配置daemon的placement并启动ceph-orch-apply-service_type)
      - [4.管理存储设备：`ceph orch device`](#4管理存储设备ceph-orch-device)
      - [5.管理daemon：`ceph orch daemon`](#5管理daemonceph-orch-daemon)
        - [（1）查看daemon状态](#1查看daemon状态)
        - [（2）添加service](#2添加service)
    - [配置相关：`ceph config`](#配置相关ceph-config)
      - [1.查看配置](#1查看配置)
      - [2.进行配置](#2进行配置)
    - [mgr module相关: `ceph mgr`](#mgr-module相关-ceph-mgr)
    - [OSD相关（osd需要特别关注）](#osd相关osd需要特别关注)
      - [1.osd相关](#1osd相关)
      - [2.pool相关](#2pool相关)
      - [3.pg相关](#3pg相关)
    - [权限相关](#权限相关)
      - [1.列出所有账号、密码和权限](#1列出所有账号-密码和权限)
    - [debug](#debug)
      - [1.查看集群状态和原因](#1查看集群状态和原因)

<!-- /code_chunk_output -->

[不同版本的文档，需要去github上查看](https://github.com/ceph/ceph/tree/hammer/doc)

### orchestrator module：`ceph orch`

#### 1.获取整个集群状态
```shell
ceph status

#参考（https://docs.ceph.com/en/pacific/rados/operations/health-checks/）
ceph health detail
```

#### 2.管理host：`ceph orch host`
```shell
#查看主机信息
ceph orch host ls

#给host打标签
ceph orch host label add <HOST> <LABEL>

#添加host
ceph orch host add <HOST> --labels <LABEL>

#删除host
ceph orch host rm <HOST>
```

##### （1）特殊的host标签（最新版本）：
|label|说明|
|-|-|
|_no_schedule|不会调度daemon到这个节点上|
|_no_autotune_memory|不会自动对daemon的内存进行调整|
|_admin|会拷贝`/etc/ceph/ceph.conf`和`/etc/ceph/ceph.client.admin.keyring`这两个文件到这个节点上，从而能够使用ceph等客户端命令控制集群|

#### 3.管理service：`ceph orch <ACTION> <service_type>`

##### （1）查看服务状态
```shell
ceph orch ls      #查看所有服务的信息

ceph orch ls <service_type>   #查看相关服务的信息
                              #比如：ceph orch ls mon
                              #ceph orch ls
```

##### （2）配置daemon的placement并启动：`ceph orch apply <service_type>`

```shell
#只指定数量，会自动放置到合适的位置
ceph orch apply <service_type> <NUM>
#直接指明了daemonset放置在哪些node上
ceph orch apply <service_type> <HOST1,HOST2,HOST3,...>

#常用选项：
--unmanaged   #表示不自动部署，手动部署：ceph orch daemon add ...
```

#### 4.管理存储设备：`ceph orch device`

```shell
#查看加入到集群中的磁盘或者通过osd.all-available-devices服务自动发现的磁盘
ceph orch device ls   #--hostname=xx --wide --refresh
```

#### 5.管理daemon：`ceph orch daemon`

##### （1）查看daemon状态
```shell
ceph orch ps
```

##### （2）添加service
```shell
ceph orch daemon add <service_type> [<args>]
```

***

### 配置相关：`ceph config`

#### 1.查看配置
```shell
#查看所有的配置（有些版本无法列出来）
ceph config dump

#查看daemon的id
#会列出daemon在node上的分布，从而能够获取到daemon的id
ceph node ls all

#下面方式查出的配置最准确，因为是运行时的
#查看指定daemon的 所有的配置
ceph config show show-with-defaults <type>.<id>

#查看指定daemon的 指定的配置
ceph config show <type>.<id>
```

#### 2.进行配置

* 注意：有些配置后，需要重启相关服务
  * 比如: mon_warn_on_pool_no_redundancy 需要重启osd和mon
```shell
#比如：ceph config set global mon_warn_on_pool_no_redundancy  false
ceph config set <section> <key> <value>
```

***

### mgr module相关: `ceph mgr`

```shell
#查看启动的模块
ceph mgr module ls

#启动指定模块
ceph mgr module enable <module>

#查看模块对外暴露的接口
ceph mgr services
```

***

### OSD相关（osd需要特别关注）

#### 1.osd相关

* 查看所有osd信息
```shell
#osd元信息（包括osd的版本、使用的objectstore等等）
ceph osd metadata <osd_id>

#osd状态信息
ceph osd dump
```

* 查看osd和host的关系
```shell
ceph osd tree   #当reweight=0时，表示该osd处于out状态（数据有没有完全迁出，需要查看pg状态）
#WEIGHT 表示该osd在pg中最初的权重
#REWEIGHT 表示重新设置osd的权重
```

* 查看osd和device的关系
```shell
ceph device ls
#如果上面这个命令，无法查询不到，尝试下面的命令：
ceph osd find <osd_id>  #<osd_id>就是数字
```

* 查看每个osd的存储资源使用情况
```shell
ceph osd df
```

* 调整OSD的权重
  * 手动调整
  ```shell
  ceph osd reweight <osd_id> <weight>
  ```

  * 自动调整
  ```shell
  #执行这个命令之前，先dry run一下：
  # ceph osd test-reweight-by-utilization
  ceph osd reweight-by-utilization <threshold|default=120> [<max_change|default=0.05> <max_osds|default=4>] [--no-increasing]

  #<threshold>，是一个百分数，范围：100-120: 选出需要重新设置权限的osd：osd的使用率 > 平均使用率（所有osd） * <threshold>
  #<max_change>: 权重的变化
  #<max_osds>: 对多少个osd重新设置权重
  #--no-increasing: 不提升权重，只降低权重
  ```

#### 2.pool相关

* 查看pool的基本信息
```shell
ceph osd pool ls detail
```

* 查看pool的使用情况（能看出ceoph存储资源的使用情况）
```shell
ceph osd pool autoscale-status
# SIZE            该pool存储的数据量（不包括副本的数据量）
# TARGET SIZE     期望该pool存储的数据量（不包括副本的数据量）
# RATE            是一个乘数（副本的数量），消耗真正的存储空间 = SIZE * RATE
# RAW CAPACITY    真正的存储空间大小（但是实际能够存储的数据量达不到，因为存在副本数据）
# RATIO           存储空间的使用率
```

* 删除有数据的pool
```shell
ceph config set mon mon_allow_pool_delete true
ceph osd pool rm <pool_name> <pool_name> --yes-i-really-really-mean-it
ceph config set mon mon_allow_pool_delete false
```

#### 3.pg相关
* 查看所有pg的状态统计
```shell
ceph pg stat
```

* 查看所有pg信息（包括状态等）
```shell
ceph pg ls
```

* 查看pg的active set和up set
```shell
ceph pg map <pg_id>
```

* 查看pg在osd上的分布情况
```shell
ceph osd utilization
```

* 查看某个pg的具体情况（能够看出失败的原因等）
```shell
ceph pg <pd_id> query
```

***

### 权限相关

#### 1.列出所有账号、密码和权限
```shell
ceph auth ls
```

***

### debug

#### 1.查看集群状态和原因
```shell
$ ceph status

#列出集群的状态
cluster:
  id:     20870fc4-c996-11eb-8c25-005056b80961
  health: HEALTH_OK     #如果状态不健康，下面会列出不健康的原因

#列出各个组件的状态
services:
  mon: 3 daemons, quorum node-01,node-02,node-03 (age 90m)
  mgr: node-01.lbvxfc(active, since 3M), standbys: node-02.czjeam
  mds: 2/2 daemons up, 2 standby
  osd: 6 osds: 6 up (since 8m), 6 in (since 8m)

#列出数据的状态
data:
  volumes: 2/2 healthy          #创建的文件系统的状态
  pools:   8 pools, 225 pgs
  objects: 3.13k objects, 8.1 GiB
  usage:   27 GiB used, 69 GiB / 96 GiB avail   #一共 96G，还剩 69G
  pgs:     225 active+clean
```

* 查看更详细的状态
```shell
ceph health detail
```
