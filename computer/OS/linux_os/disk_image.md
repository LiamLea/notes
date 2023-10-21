# disk image


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [disk image](#disk-image)
    - [概述](#概述)
      - [1.disk image](#1disk-image)
      - [2.disk image分类](#2disk-image分类)
        - [(1) ISO](#1-iso)
        - [(2) raw image](#2-raw-image)
        - [(3) virtual disk image](#3-virtual-disk-image)
    - [使用](#使用)
      - [1.挂载ISO](#1挂载iso)
      - [2.自制raw image](#2自制raw-image)
        - [(1)创建一个镜像文件](#1创建一个镜像文件)
        - [(2)与回环设备关联](#2与回环设备关联)
        - [(3) 如果没有文件系统：  进行分区和格式化](#3-如果没有文件系统--进行分区和格式化)
        - [(4)挂载](#4挂载)
        - [(5) 卸载](#5-卸载)
      - [3.制作虚拟机磁盘](#3制作虚拟机磁盘)
        - [(1) 创建一个虚拟机，并在其中操作，然后把这个盘作为后端盘](#1-创建一个虚拟机并在其中操作然后把这个盘作为后端盘)
        - [(2) 对虚拟机剩余空间进行写零操作](#2-对虚拟机剩余空间进行写零操作)
        - [(3) 对qcow2镜像进行压缩，生成新的镜像](#3-对qcow2镜像进行压缩生成新的镜像)

<!-- /code_chunk_output -->

### 概述

#### 1.disk image

是一个存储设备的 结构和数据 的快照

#### 2.disk image分类

##### (1) ISO
* 用于模拟光学介质

##### (2) raw image
* 用于完全拷贝磁盘结构、文件系统、数据等

##### (3) virtual disk image
* 用于虚拟化磁盘，具有相关特性
* 比如：
    * qcow2
    * VHD
    * CMDK

***

### 使用

#### 1.挂载ISO
```shell
mount -o loop <ISO_path> <path>
```

#### 2.自制raw image

##### (1)创建一个镜像文件
* 用`dd`命令拷贝一个或者创建一个空的raw image

##### (2)与回环设备关联

* 回环设备可以将文件当块设备使用

```shell
# 查看空闲的回环设备
$ losetup -f
/dev/loop14

# 将文件与回环设备关联
$ losetup /dev/loop14 <raw_image>

# 查看和回环设备关联的文件
$ losetup -a    
```
##### (3) 如果没有文件系统：  进行分区和格式化
* 如果不是新建的raw image，跳过这步
```shell
fdisk /dev/loop14
mkfs.xfs /dev/loop14
```

##### (4)挂载
```shell
mount /dev/loop14 <path>
```

##### (5) 卸载
* 卸载
```shell
umount /dev/loop14
```

* 解除和回环设备的关联
```shell
losetup -d /dev/loop14
```

#### 3.制作虚拟机磁盘

##### (1) 创建一个虚拟机，并在其中操作，然后把这个盘作为后端盘

##### (2) 对虚拟机剩余空间进行写零操作
```shell
# 基本原理是向磁盘中写入一个全0的文本文件，直到磁盘被填充满，然后将文件删除
dd if=/dev/zero of=/zero.dat
```

##### (3) 对qcow2镜像进行压缩，生成新的镜像
```shell
qemu-img convert -c -O qcow2 <input_file1> <output_file>       
# -c:compress,压缩
# -O:out_format
```