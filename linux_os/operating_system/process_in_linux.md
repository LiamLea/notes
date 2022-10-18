# process in linux

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [process in linux](#process-in-linux)
    - [概述](#概述)
      - [1.init（pid=1）和kthreadd（pid=2）进程](#1initpid1和kthreaddpid2进程)
      - [2.常见内核进程](#2常见内核进程)

<!-- /code_chunk_output -->

### 概述

#### 1.init（pid=1）和kthreadd（pid=2）进程

init和kthreadd都是 内核在启动时创建，没有父进程，所以ppid=0

#### 2.常见内核进程
|进程名|描述|
|-|-|
|kswap|管理虚拟内存|
