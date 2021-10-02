# ceph file system

[toc]

### 概述

#### 1.cephfs
基于RADOS对外提供文件系统
需要至少两个pool：一个pool用于存储data（可以有多个data pool），另一个pool用于存储metadata
数据的存取会被分成同等大小的chunk，每个chunk是一个object，存储在RADOS中，元数据存在另一个pool（通过MDS服务提供）
![](./imgs/overview_02.png)

#### 2.术语

* fscid
file system cluster id，用于标识每个ceph的文件系统

* rank
是一个数字，从0开始，相当于active mds的编号
在一个文件系统中，rank的数量就是当前active mds的数量（即正在提高服务的mds的数量），数量越多，mds性能越好，因为工作负载被分担了

#### 3.fileout（布局）
fileout是cephfs中文件的属性，决定了文件的内容在RADOS中存储
```shell
getfattr -n ceph.file.layout <file_path>
```
* layout有以下几个属性

|属性|说明|
|-|-|
|pool|指定存储在哪个data pool中|
|object_size|指定文件的内容被分成多大的chunk（每个chunk存储为一个RADOS object）|

***

### 使用

#### 1.创建文件系统
可以利用下面的方式创建多个文件系统，但是需要开启支持多文件系统配置
```shell
#默认是开启的
ceph fs flag set enable_multiple true
```

* 方式一

```shell
#创建两个pool
ceph osd pool create cephfs_data
ceph osd pool create cephfs_metadata

#创建fs
#会自动将这两个pool会与cephfs这个application关联
#会自动部署MDS服务
ceph fs new <fs_name> <metadata_pool> <data_pool>
```


* 方式二

自动创建两个pool，其他都和方式一 一样
```shell
ceph fs volume create <fs_name>
```

#### 2.挂载cephfs

##### （1）前提准备
* 生成ceph.conf文件
  * 也可以不生成，通过<mon_ip_list>指定地址
```shell
ceph config generate-minimal-conf
```

* 创建user并获取secret key
  * 可以将key写入文件：`ceph.client.<USER>.keyring`，也可以不写入，通过secret=<USER_SECRET>指定
  * 可以不创建user，使用admin用户
```shell
ceph fs authorize <fs_name> client.<USER> <path> rw

#ceph fs authorize cephfs client.test-user / rw
```

##### （2）使用kernel client

```shell
#需要安装mount.ceph这个helper：yum -y install ceph-common

#<mon_ip_list>：3.1.5.51:6789,3.1.5.52:6789,3.1.5.53:6789
#当存在/etc/ceph.conf和/etc/etc/ceph/ceph.client.<USER_NAME>.keyring时，<mon_ip_list>和secret=<SECRET>可以省略
mount -t ceph <mon_ip_list>:<path> <mount_point> -o name=<USER_NAME>,secret=<USER_SECRET>,fs=<fs_name>
```


#### 3.管理文件系统
```shell
ceph fs ls
ceph fs dump

ceph fs set <fd_name> <key> <value>
#max_mds <num | default=1>      ranks的数量（即active mds的数量），数量越多，mds的负载就会被分担，进而能够提高mds的性能
#standby_count_wanted <num | default=1>     设置副本数
```

#### 4.删除文件系统
```shell
ceph fs rm <fs_name> --yes-i-readlly-mean-it
```
