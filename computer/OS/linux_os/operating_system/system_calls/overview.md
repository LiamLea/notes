# 系统调用

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [系统调用](#系统调用)
    - [I/O相关](#io相关)
      - [1.打开文件（返回文件描述符）: `open()`](#1打开文件返回文件描述符-open)
      - [2.关闭文件: `close()`](#2关闭文件-close)
      - [3.I/O操作:`read()/write()`](#3io操作readwrite)
      - [4.将内存中的数据flush到磁盘：`fsync()`、`fdatasync( )`、`sync()`](#4将内存中的数据flush到磁盘fsync-fdatasync--sync)

<!-- /code_chunk_output -->

### I/O相关

#### 1.打开文件（返回文件描述符）: `open()`

打开一个文件，进行io操作

* 设置文件打开状态（常用flags）

|flag|说明|
|-|-|
|O_SYNC|设置为**同步I/O**，即每次**write等待**数据都同步到磁盘（默认每次write写到内存后返回）|
|O_DIRECT|不通过内存，直接写入磁盘|

#### 2.关闭文件: `close()`
* **不会保证**数据sync到了磁盘
  * 当往已有数据的文件中写数据，close时会进行flush，所以速度会比较慢

#### 3.I/O操作:`read()/write()`
注意这里的I/O是指系统I/O，一次系统I/O可能会调用多次磁盘I/O，一次磁盘I/O会读取多个data block
* 一次I/O就是调用一次 write/read系统调用
* 在linux中，I/O操作是**异步**的，为了提高性能
  * 即先 写入/读取 到**内存**中，所以`I/O request size < 可用内存的大小`
  * 当open文件时的状态包括sync，则每次write都会同步数据到磁盘

#### 4.将内存中的数据flush到磁盘：`fsync()`、`fdatasync( )`、`sync()`
* `fsync()`
  *  Allows a process to flush **page cache** that belong to a specific open file to disk
* `fdatasync( )`
  * Very similar to fsync( ), but doesn’t flush the inode block of the file（即metadata信息）
* `sync()`
  * Allows a process to flush all **page cache** to disk
