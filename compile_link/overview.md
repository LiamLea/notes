# compile and link

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [compile and link](#compile-and-link)
    - [概述](#概述)
      - [1.c语言编译四步（通常说的编译包含指的是前三步）](#1c语言编译四步通常说的编译包含指的是前三步)
    - [动态库](#动态库)
      - [1.查看 gcc和系统 的动态链接库搜索路径](#1查看-gcc和系统-的动态链接库搜索路径)
      - [2.系统动态链接库的相关文件](#2系统动态链接库的相关文件)
        - [（1）配置文件：/etc/ld.so.conf](#1配置文件etcldsoconf)
        - [（2）缓存文件：/etc/ld.so.cache](#2缓存文件etcldsocache)
      - [3.查看系统动态链接的情况](#3查看系统动态链接的情况)
    - [troubleshooting](#troubleshooting)
      - [1.header version和current version不匹配](#1header-version和current-version不匹配)

<!-- /code_chunk_output -->

### 概述

#### 1.c语言编译四步（通常说的编译包含指的是前三步）
* preprocessing（预处理）
  * 去除注释
  * 填充宏
  * 填充included文件

* compiling（编译）
  * 生成汇编代码

* assembly（汇编）
  * 将编码转换成二进制机器码

* linking（链接）
  * 将所有目标代码链接到一个文件中

***

### 动态库

#### 1.查看 gcc和系统 的动态链接库搜索路径
* gcc动态链接库搜索路径
```shell
gcc -print-search-dirs
```

* 系统动态链接库搜索路径
```shell
ldconfig -v
```

#### 2.系统动态链接库的相关文件

##### （1）配置文件：/etc/ld.so.conf
用于增加 动态链接 的 搜索路径

默认会搜索：`/lib`、`/lib64`、`/usr/lib`、`/usr/lib64`等

##### （2）缓存文件：/etc/ld.so.cache
为了加速动态链接库的调用

#### 3.查看系统动态链接的情况
* 查看动态链接的加载情况（**非常重要**）
  * 搜素路径 和 加载了哪些动态链接
  * 是否加载成功（看有没有报错信息）
  * 看加载顺序
```shell
ldconfig -v
```

* 查看程序所需要的动态库
```shell
ldd <FILE>
```

* 更新动态库缓存和创建链接文件
```shell
ldconfig
```

* 查看缓存了哪些动态库
```shell
ldconfig -p
```


***

### troubleshooting

#### 1.header version和current version不匹配
编译器搜索的动态库路径 和 系统搜索的动态库路径不一样，当存在一个动态链接存在两个版本时，就可能出现这种情况
