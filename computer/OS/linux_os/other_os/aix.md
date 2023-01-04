# aix

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [aix](#aix)
    - [常用命令](#常用命令)
      - [1.基本命令](#1基本命令)
      - [2.磁盘和文件系统](#2磁盘和文件系统)
      - [3.查看硬件6](#3查看硬件6)

<!-- /code_chunk_output -->

### 常用命令

#### 1.基本命令
* uname
```shell
uname
  -s        #获取kernel-name名
  -v        #获取system版本
```

* oslevel
获取更准确的system版本

#### 2.磁盘和文件系统
* lsfs

* lspv
显示磁盘


#### 3.查看硬件6
* lsdev
```shell

lsdev
  #按照name class subclass type展示硬件
  #F:format，能够查看有哪些class
  -F 'name class subclass type'

  #列出指定类的硬件
  #比如：lsdev -c disk
  -Cc <CLASS>
```
