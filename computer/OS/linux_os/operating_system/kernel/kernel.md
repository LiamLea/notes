# kernel

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kernel](#kernel)
    - [概述](#概述)
      - [1.namespaces特性](#1namespaces特性)
        - [（1）6中namespace](#16中namespace)

<!-- /code_chunk_output -->

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
