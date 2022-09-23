[toc]

### 系统调用

#### 1.打开文件（返回文件描述符）: `open()`

打开一个文件，进行io操作

* 设置文件打开状态（常用flags）

|flag|说明|
|-|-|
|O_SYNC|设置为**同步I/O**，即每次**write等待**数据都同步到磁盘（默认每次write写到内存后返回）|

#### 2.关闭文件: `close()`
* **不会保证**数据sync到了磁盘
  * 当往已有数据的文件中写数据，close时会进行flush，所以速度会比较慢

#### 3.I/O:`read()/write()`
* 一次I/O就是调用一次 write/read系统调用
* 在linux中，I/O操作是**异步**的，为了提高性能
  * 即先 写入/读取 到**内存**中，所以`I/O request size < 可用内存的大小`
  * 当open文件时的状态包括sync，则每次write都会同步数据到磁盘

#### 4.将内存中的数据flush到磁盘：`fsync()`、`fdatasync( )`、`sync()`
* `fsync()`
  *  Allows a process to flush **all blocks** that belong to a specific open file to disk
* `fdatasync( )`
  * Very similar to fsync( ), but doesn’t flush the inode block of the file（即metadata信息）
* `sync()`
  * Allows a process to flush all **dirty buffers** to disk



* 在linux中，I/O操作先将数据写入内存，所以需要fsync一下，将数据flush到磁盘
