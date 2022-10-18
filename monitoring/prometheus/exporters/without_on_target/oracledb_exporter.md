
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [容器启动](#容器启动)
- [二进制安装](#二进制安装)
  - [1.安装指定版本的 Oracle Instant Client Basic](#1安装指定版本的-oracle-instant-client-basic)
  - [2.安装oracledb_exporter](#2安装oracledb_exporter)
  - [3.设置连接信息](#3设置连接信息)
  - [（1）第一种设置连接信息方式](#1第一种设置连接信息方式)
  - [（2）第二种设置连接信息方式](#2第二种设置连接信息方式)
  - [4.启动](#4启动)

<!-- /code_chunk_output -->

[参考地址](https://github.com/iamseth/oracledb_exporter)

### 容器启动
```shell
docker run -d --name oracledb_exporter -p 9161:9161 -e DATA_SOURCE_NAME=<USERNAME>/<PASSWD>@//<IP>:<PORT>/<SERVICE_NAME> iamseth/oracledb_exporter
```

***

### 二进制安装

#### 1.安装指定版本的 Oracle Instant Client Basic

#### 2.安装oracledb_exporter

#### 3.设置连接信息
不能使用sysdba用户连接
#### （1）第一种设置连接信息方式
* 切换到oracle用户
因为需要有TNS_ADMIN变量，这个变量会指出tnsnames.ora所在的目录（`$ORACLE_HOME/network/admin`）
* 设置连接信息
```shell
export DATA_SOURCE_NAME="<USERNAME>/<PASSWD>@<SERVICE_NAME>"
```

#### （2）第二种设置连接信息方式
* 设置连接信息
```shell
export DATA_SOURCE_NAME="<USERNAME>/<PASSWD>@//<IP>:<PORT>/<SERVICE_NAME>"
```

#### 4.启动
```shell
./oracledb_exporter
```
