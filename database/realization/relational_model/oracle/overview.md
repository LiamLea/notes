# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.基础概念](#1基础概念)
        - [（1）数据库](#1数据库)
        - [（2）数据库实例（SID）](#2数据库实例sid)
        - [（3）数据库服务名](#3数据库服务名)
        - [（4）数据库域名](#4数据库域名)
        - [（5）全局数据库名](#5全局数据库名)
        - [（6）表空间](#6表空间)
      - [2.单机版oracle有两类进程](#2单机版oracle有两类进程)
      - [3.重要目录](#3重要目录)
    - [使用](#使用)
      - [1.基本操作](#1基本操作)
      - [2.基础查询](#2基础查询)

<!-- /code_chunk_output -->

### 概述

#### 1.基础概念

##### （1）数据库
##### （2）数据库实例（SID）
数据库实例名是用于和操作系统进行联系的标识
* 一个实例只能操作一个数据库，有一系列的后台进程
* 一个数据库可以被多个实例操作（比如：oracle rac）

##### （3）数据库服务名
* 连接数据库时需要指定，因为一台主机上可能有多个数据库，用服务名指定连接哪个数据库
* 如果数据库有域名
数据库服务名就是全局数据库名
* 如果数据库没有域名
数据库服务名与数据库名相同

##### （4）数据库域名
数据库域名主要用于oracle分布式环境中的复制

##### （5）全局数据库名
全局数据库名 = 数据库名 + 数据库域名

##### （6）表空间
每个数据库至少有一个表空间（称之为system表空间）
每个表空间由磁盘上的一个或多个文件组成，这些文件叫数据文件
一个数据文件只能属于一个表空间

#### 2.单机版oracle有两类进程
* 与监听器有关的进程（`tnslsnr`）
* 与实例有关的进程（`*_<INSTANCE_NAME>`）

#### 3.重要目录
* admin目录
记录Oracle实例的配置, 运行日志等文件, 每个实例一个目录
SID: System IDentifier的缩写, 是Oracle实例的唯一标记. 在Oracle中 **一个实例只能操作一个数据库** . 如果安装多个数据库, 那么就会有多个实例, 我们可以通过实例SID来区分. 由于Oracle中一个实例只能操作一个数据库的原因oracle中也会使用SID来作为库的名称

* oradata目录
存放数据文件

* init.ora文件

***

### 使用

#### 1.基本操作
* 登录oracle
```shell
su - oracle
sqlplus 账号/密码
sqlplus / as sysdba       #表示匿名登录，以sysdba身份登录
```

* 查询
```shell
select instance_name from v$instance;       #查看数据库有多少实例
```

* 启闭数据库服务
```shell
sqlplus / as sysdba
startup
shutdown immediate
```

* 启闭监听器
```shell
lsnrctl start
lsnrctl stop
```

#### 2.基础查询
* 数据库名
```shell
select name from v$database;
```
* 实例名
```shell
select instance_name from v$instance;
#或者
ps aux | grep pmon
```
* 数据库域名
```shell
select name from v$parameter where name = 'db_domain';
```
