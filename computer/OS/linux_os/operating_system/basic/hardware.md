# harware


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [harware](#harware)
    - [概述](#概述)
      - [1.系统uuid相关](#1系统uuid相关)
        - [（1）system-serial_number](#1system-serial_number)
        - [（2）system-uuid 和 machine-id区别](#2system-uuid-和-machine-id区别)
      - [2.DMI(desktop mamanger interface)](#2dmidesktop-mamanger-interface)

<!-- /code_chunk_output -->

### 概述

#### 1.系统uuid相关

##### （1）system-serial_number
是服务器的序列码，写在服务器的外部

##### （2）system-uuid 和 machine-id区别
* system-uuid
写在BIOS中的，在操作系统中无法修改，重装系统也还是不变（/sys/class/dmi/id/product_uuid）
</br>
* machine-id
安装操作系统时生成的，可以直接修改（/etc/machine-id）

#### 2.DMI(desktop mamanger interface)
桌面管理接口，生成一个行业标准的框架，用于收集和管理当前设备的环境信息（硬件和相关软件等）
```shell
#该命用于显示dmi管理的信息
dmidecode               #显示全部环境信息

-t 类型     
#查看有哪些类型：
#   通过man dmidecode可以查看支持哪些类型
#   0 BIOS
#   1 system
#   ... ...
#   8 connector
#   9 slot
#   16 memory array

-s 关键字
#查看有哪些关键字：
#   dmidecode -t --help

```