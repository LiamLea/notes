# GPS


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [GPS](#gps)
    - [概述](#概述)
      - [1.概念介绍](#1概念介绍)
        - [(1) NEMA (National Marine Electronics Association)](#1-nema-national-marine-electronics-association)
      - [2.软件介绍](#2软件介绍)
        - [(1) geoclue](#1-geoclue)
        - [(2) gpsd](#2-gpsd)
        - [(3) gpsfake](#3-gpsfake)
    - [gpsfake使用](#gpsfake使用)
      - [1.安装](#1安装)
      - [2.设置数据](#2设置数据)
      - [3.启动gpsfake](#3启动gpsfake)
      - [4.验证](#4验证)

<!-- /code_chunk_output -->

### 概述

#### 1.概念介绍

##### (1) NEMA (National Marine Electronics Association)
* 是GPS导航设备统一的RTCM标准协议，定义了GPS相关的一系列标准（包括：卫星数据格式、定位格式等）

#### 2.软件介绍

##### (1) geoclue

* 用于获取gps信息，并提供给相关应用使用
    * linux中没有统一获取gps信息的方式，所以geoclue这里提供了同一的方式，但是有些应用不从geoclue获取
* geoclue可以从gpsd获取位置信息，但需要做一些额外的配置

##### (2) gpsd
用于从gps设备`/dev/xx`读取gps信息，然后通过网络暴露出来

##### (3) gpsfake

用于模拟gps设备，然后启动gpsd

***

### gpsfake使用

#### 1.安装
```shell
apt-get install gpsd gpsd-clients python3-gps
systemctl stop gpsd
systemctl stop gpsd.socket
systemctl disable gpsd
systemctl disable gpsd.socket
```

* 有的版本有个bug需要修改
```shell
$ vim /etc/apparmor.d/usr.sbin.gpsd
...
/tmp/gpsfake-*.sock rw,
/dev/pts/* rw,
...

$ sudo systemctl restart apparmor
```

#### 2.设置数据
生成NMEA格式数据，[参考](https://www.nmeagen.org/)

#### 3.启动gpsfake

* 通过两种方式
    * 网络
    * 串行设备
```shell
#会从/tmp/output-3.nmea读取nmea格式的数据，然后启动一个gpsd服务
#-c 1表示1秒产生一次
gpsfake -c 1 /tmp/output-3.nmea
```

#### 4.验证

* 获取gpsd服务的信息，包括:
    * 监听的地址
    * 串行设备的路径
    * 位置信息等等
```shell
gpsmon
```

* 通过串行设备获取gps数据
```shell
gpscat /dev/pts/3
```

* 通过网络获取gps数据
```shell
gpspipe -r 127.0.0.1:2947
```