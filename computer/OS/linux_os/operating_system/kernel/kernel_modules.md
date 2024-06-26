# kernel modules

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kernel modules](#kernel-modules)
    - [概述](#概述)
      - [1.启动时模块自动加载](#1启动时模块自动加载)
    - [使用](#使用)
      - [1.列出所有可加载的模块](#1列出所有可加载的模块)
      - [2.永久加载指定模块](#2永久加载指定模块)
      - [3.查看加载的module的参数](#3查看加载的module的参数)

<!-- /code_chunk_output -->

### 概述

#### 1.启动时模块自动加载
linux操作系统启动时，由systemd-modules-load.service服务，加载需要的模块

***

### 使用

#### 1.列出所有可加载的模块
```shell
find /lib/modules/$(uname -r) -type f -name '*.ko*'
```

* 查看module信息
```shell
modinfo <module_name>
```

#### 2.永久加载指定模块
* 查看systemd-modules-load服务
```shell
cat /usr/lib/systemd/system/systemd-modules-load.service
```
* 根据提示继续查看
```shell
man modules-load.d
```
* 从而知道如何知道如何永久加载
```shell
/etc/modules-load.d/*.conf
/run/modules-load.d/*.conf
/usr/lib/modules-load.d/*.conf
```

* 永久加载ip_gre模块
```shell
echo ip_gre >> /etc/modules-load.d/my.conf
```

#### 3.查看加载的module的参数
```shell
cat /sys/module/<module>/parameters/<parameter>
```
