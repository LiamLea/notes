# config

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [config](#config)
    - [概述](#概述)
      - [1.配置文件（优先级由高到低）](#1配置文件优先级由高到低)
      - [2.配置文件格式](#2配置文件格式)
      - [3.查看配置](#3查看配置)
    - [老版本](#老版本)

<!-- /code_chunk_output -->

### 概述
[参考](https://docs.ceph.com/en/latest/rados/configuration/ceph-conf/)

#### 1.配置文件（优先级由高到低）
* `$CEPH_CONF`
* `-c path/path`
* `/etc/ceph/$cluster.conf`
* `~/.ceph/$cluster.conf`
* `./$cluster.conf`

#### 2.配置文件格式

* 有一下section

```shell
#全局配置，影响所有daemons和clients
[global]

#影响所有ceph-mon daemons
[mon]

#影响所有ceph-mgr daemons
[mgr]

#影响所有ceph-osd daemons
[osd]

#影响所有ceph-mds daemons
[mds]

#影响所有clients（e.g. mounted Ceph File Systems, mounted Ceph Block Devices等）
[client]
```

#### 3.查看配置

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

***

### 老版本

* 老版的修改
* 修改（需要修改指定osd所在的主机上的ceph.conf）
```shell
$ vim /etc/ceph/ceph.conf
osd_backfill_full_ratio = 0.9
```
* 重启
```shell
#start ceph-osd id=<K>
#stop ceph-osd id=<K>
#restart ceph-mon id=nari-controller03
```
* 查看
```shell
ceph daemon {daemon-type}.{id} config show
#ceph daemon osd.0 config show
```
