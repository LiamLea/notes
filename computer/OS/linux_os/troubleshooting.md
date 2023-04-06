# troubleshooting


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [troubleshooting](#troubleshooting)
      - [1.too many open files](#1too-many-open-files)
        - [（1）检查进程和线程数](#1检查进程和线程数)
        - [（2）检查打开的文件数](#2检查打开的文件数)
        - [（3）检查inotify](#3检查inotify)
      - [2.kdump的使用（用于debug kernal）](#2kdump的使用用于debug-kernal)
        - [(1) 测试kdump是否可以](#1-测试kdump是否可以)
        - [(2) 查看生成的crash日志](#2-查看生成的crash日志)
        - [(3) 根据crash日志进行debug](#3-根据crash日志进行debug)

<!-- /code_chunk_output -->


#### 1.too many open files

##### （1）检查进程和线程数

* 系统范围（一般不会是瓶颈）
```shell
#检查进程数
ps -elf | wc -l
cat /proc/sys/kernel/pid_max

#检查线程数
ps -eLf | wc -l
cat /proc/sys/kernel/threads-max
```

* 用户范围（不要用root用户查看）
```shell
#一个用户最多能同时打开的进程数（对root无效）
ulimit -u
```

##### （2）检查打开的文件数
* 系统范围（一般不会是瓶颈）
```shell
cat /proc/sys/fs/file-nr
#三个值：
# 当前已分配
# 当前已经分配但未被使用
# 最大值
```

* 用户范围（不要用root用户查看）
```shell
#一个 进程最多能打开的文件描述符数量
ulimit -n
```

##### （3）检查inotify
```shell
#检查实例数
find /proc/*/fd/ -type l -lname "anon_inode:inotify" -printf "%hinfo/%f\n" | xargs grep -cE "^inotify" | column -t -s: | sort -nk2 | wc -l
cat /proc/sys/fs/inotify/max_user_instances

#检查watch数
find /proc/*/fd/ -type l -lname "anon_inode:inotify" -printf "%hinfo/%f\n" | xargs grep -cE "^inotify" | column -t -s: | sort -nk2
cat /proc/sys/fs/inotify/max_user_watches
```

#### 2.kdump的使用（用于debug kernal）

[原理](https://opensource.com/article/17/6/kdump-usage-and-internals): 就是当kernel panic时，会运行第二个kernel（比如通过kexec命令），然后记录第一个kernel的相关信息

##### (1) 测试kdump是否可以

* 开启system request
```shell
echo 1 > /proc/sys/kernel/sysrq
```

* 模拟系统crash
```shell
echo h > /proc/sysrq-trigger        #查看帮助(会打印到系统日志中)
echo c > /proc/sysrq-trigger
```

##### (2) 查看生成的crash日志
```shell
ls /var/log/<date>/
```

##### (3) 根据crash日志进行debug

* 安装debug工具
```shell
yum -y install crash
yum -y install kernel-debuginfo-$(uname -r)
```

* 进行debug
  * crash常用debug命令

  |命令|说明|
  |-|-|
  |ps|当时正在运行的进程|
  |vm|当时虚拟内存中加载的内容|
  |files|当时打开的文件|
  |log|当时的日志（和`vmcore-dmesg.txt`内容一样）|

```shell
crash /usr/lib/debug/lib/modules/3.10.0-1160.el7.x86_64/vmlinux  /var/crash/127.0.0.1-2023-04-04-12\:07\:10/vmcore
```
