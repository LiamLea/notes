# process in linux

[toc]

### 概述

#### 1.init（pid=1）和kthreadd（pid=2）进程

init和kthreadd都是 内核在启动时创建，没有父进程，所以ppid=0

#### 2.常见内核进程
|进程名|描述|
|-|-|
|kswap|管理虚拟内存|
