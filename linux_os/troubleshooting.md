# troubleshooting


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [troubleshooting](#troubleshooting)
      - [1.too many open files](#1too-many-open-files)
        - [（1）检查进程和线程数](#1检查进程和线程数)
        - [（2）检查打开的文件数](#2检查打开的文件数)
        - [（3）检查inotify](#3检查inotify)

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
