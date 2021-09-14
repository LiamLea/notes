# kernel

[toc]

### 概述

#### 1.namespaces特性
能够使进程间的资源相互隔离

##### （1）6中namespace

|namespace|说明|
|-|-|
|uts|unix timesharing system，主机名和域名的隔离|
|user|用户的隔离|
|mnt|mount，文件系统的隔离|
|pid|进程的隔离|
|ipc|进程间通信的隔离|
|net|网络的隔离|

#### 2.cgroups（control groups）特性
对进程进行**分组**，然后可以 **监视**  和 **限制** **指定组** 对各种**资源的使用**

##### （1）基本概念

* service
  * 就是systemd中的service unit
* scope
  * 它与 service 单元类似，只不过是通过systemd的接口创建的
* slice
  * 是一个管理单元，scope和systemd unit会被放在某个slice中
  * 一个scope、一个service 等 都是一个cgroup组

##### （2）目录组织
如果是cgroupfs这个drriver，目录会有些不一样（`/var/lib/lxc/`）
* cgroup目录：`/sys/fs/cgroup/`
* 下层结构： `<rource_type>/<slice_name>/<group>/`
* 比如：`/sys/fs/cgroup/cpu/system.slice/docker-3838563ee95339a55d1f500d48a63b448a5720f8fc1d0698d63af2b75fc1ba70.scope/cgroup.procs`
  * 能够获取进程号，即3833这个容器哪些进程的cpu资源被管理了
