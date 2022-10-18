# ulimit

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ulimit](#ulimit)
    - [概述](#概述)
      - [1.作用](#1作用)
      - [2.资源](#2资源)
      - [3.hard和soft](#3hard和soft)
      - [4.配置文件格式](#4配置文件格式)

<!-- /code_chunk_output -->

### 概述

#### 1.作用
用于**限制** **指定用户** 的 **资源使用**

#### 2.资源
|资源|说明|
|-|-|
|nproc|一个用户能打开的最大进程数/线程数（对root无效）|
|nofile|一个进程能打开的最大文件句柄数|

#### 3.hard和soft

|hard|soft|
|-|-|
|表示soft值最高设为hard的值|使用量不能超过soft指定的值|
|只有root用户能设置hard值|每个用户都能设置自己的soft值|

#### 4.配置文件格式
* 配置文件：`/etc/security/limits.conf`
```shell
#<domain>  <type>  <item>    <value>
*           hard    nproc     4096
*           soft    nproc     2048
liyi        soft    nproc     50
```
