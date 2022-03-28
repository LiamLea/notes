# cgroup

[toc]

### 概述

#### 1.cgroups（control groups）特性

对进程进行**分组**，然后可以 **监视**  和 **限制** **指定组** 对各种**资源的使用**
内核的cgroup接口 就是一个 **伪文件系统（cgroupfs）**

##### （1）基本概念

* service
  * 就是systemd中的service unit
* scope
  * 它与 service 单元类似，只不过是通过systemd的接口创建的
* slice
  * 是一个管理单元，scope和systemd unit会被放在某个slice中
  * 一个scope、一个service 等 都是一个cgroup组

##### （2）cgroup driver

|cgroup driver|cgroupfs|systemd|
|-|-|-|
|本质区别|直接管理cgroup|通过systemd管理cgroup|
|好处||通过syetemd管理更稳定，因为systemd还管理系统其他进程的cgroup|
|目录组织：</br>`/sys/fs/cgroup/<rource_type>/<parent_cgroup>/<sub_cgroup1>/<sub_cgroup2>/...`|cgroup随便命名|parent_cgroup的命名：`xx.slice`|

##### （2）目录组织

* cgroup目录：`/sys/fs/cgroup/`
* 下层结构： `<rource_type>/<parent_cgroup>/<sub_group>/...`
* 比如：
  * `/sys/fs/cgroup/cpu/system.slice/docker-3838563ee95339a55d1f500d48a63b448a5720f8fc1d0698d63af2b75fc1ba70.scope/cgroup.procs`
    * 能够获取进程号，即3833这个容器哪些进程的cpu资源被管理了
  * `/sys/fs/cgroup/memory/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod6625a5c4ae4990a796f5805ced3a4cf7.slice/docker-13f7f25881cca679ee64c1878cc661a41ed008f4a6c53c8a2b7f5ff8a253b673.scope/`


#### 2.kmem（kernel memory）
* 概念
内核使用的内存
* 主要包括
  * stack pages（创建进程使用的内存开销）
  * slab pages（slab cache，内核用于缓存的内存，这里会用的比较多）
* 作用
开启kmem后，kmem的使用量就会被计入（就可以限制该pod使用的内核内存，主要是缓存使用）
* 现状
在内核4.0之前，不稳定，会造成内存泄漏

***

### 使用

#### 1.查看cgroup版本

* 查看支持的cgroup版本
```shell
grep cgroup /proc/filesystems
```

* 查看使用的cgroup版本
```shell
mount | grep groups

#根据type后面的类型来判断：
#...type cgroup2
```

* 查看是否开启了kmem
```shell
cat /boot/config-`uname -r`|grep CONFIG_MEMCG
#如果存在：CONFIG_MEMCG_KMEM=y  ，则表示开启
```

#### 2.查看cgroup的使用情况
```shell
systemd-cgls
systemd-cgtop
```

#### 3.查看内存使用量

##### （1）查看内存使用情况
```shell
$ cat <path>/memory.stat

cache 107950080   #单位：字节
rss 396238848     #单位：字节
...
total_cache 107950080   #cgroup是分层的，所以这里加上了所有子层
total_rss 396238848     #cgroup是分层的，所以这里加上了所有子层
...
```

##### （2）查看kernel内存使用量（关闭后就为0）
```shell
$ cat <path>/memory.kmem.usage_in_bytes
```

##### （3）查看当前内存使用量
`memory.usage_in_bytes = rss + cache + memory.kmem.usage_in_bytes`
```shell
$ cat <path>/memory.usage_in_bytes
```

##### （4）docker stats查出来的值（不包含cache）
`rss + memory.kmem.usage_in_bytes + cache - inactive_file（即memory.usage_in_bytes - inactive_file）`
当内存使用量增加，kmem中用于缓存的内存会被拿过来使用

#### 4.关闭cgroup的kmem
```shell
$ vim /etc/default/grub

GRUB_CMDLINE_LINUX="cgroup.memory=nokmem"

$ update-grub
```
