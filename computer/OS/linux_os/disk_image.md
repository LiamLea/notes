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
      - [3.对raw image进行扩容](#3对raw-image进行扩容)
        - [(1) 获取image的基本信息](#1-获取image的基本信息)
        - [(2) 对image扩容](#2-对image扩容)
        - [(3) 对文件系统扩容](#3-对文件系统扩容)
        - [(4) 挂载](#4-挂载)
      - [4.对raw image进行压缩](#4对raw-image进行压缩)
        - [(1) 挂载raw image](#1-挂载raw-image)
        - [(2) 剩余空间进行写零操作](#2-剩余空间进行写零操作)
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
mount -o loop <ISO_path> <mount_path>
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

* 如果有文件系统可以直接挂载
```shell
mount -o loop <image_path> <mount_path>
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

#### 3.对raw image进行扩容

##### (1) 获取image的基本信息
* 分区情况
```shell
fdisk -l <image>
```

* 文件系统类型
```shell
file -s <image>
```

##### (2) 对image扩容
* 使用qemu-img或dd命令
```shell
qemu-img resize <image> +<size>
```

##### (3) 对文件系统扩容
* 根据上面查到的文件系统类型进行扩容（比如ext）
```shell
resize2fs <image>
```

##### (4) 挂载
```shell
mount -o loop <image_path> <mount_path>
```

#### 4.对raw image进行压缩

##### (1) 挂载raw image
```shell
mount -o loop <image_path> <mount_path>
```

##### (2) 剩余空间进行写零操作
```shell
# 基本原理是向磁盘中写入一个全0的文本文件，直到磁盘被填充满，然后将文件删除
dd if=/dev/zero of=/<mount_path>/zero.dat
```

##### (3) 对qcow2镜像进行压缩，生成新的镜像
* 注意： **文件系统的大小**没有变，只是**镜像的大小**变化了
  * 比如挂载后会发现文件系统有2个G，实现镜像只有1G，如果不压缩，则镜像大小也会是2G
```shell
qemu-img convert -c -f raw -O qcow2 <input> <output>

# -c: compress,压缩
# -f: input_format
# -O: out_format

#再将qcow2转为raw
#<output>为上一个命令输出的文件
qemu-img convert -f qcow2 -O raw <output> <output2>
```