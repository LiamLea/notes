# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.架构](#1架构)
        - [（1）应用层](#1应用层)
        - [（2）mysql server层](#2mysql-server层)
        - [（3）存储引擎层](#3存储引擎层)
      - [2.并发控制（加锁）](#2并发控制加锁)
        - [（1）读锁和写锁](#1读锁和写锁)
        - [（2）锁的粒度](#2锁的粒度)
      - [3.charset和collate](#3charset和collate)
      - [4.内存](#4内存)
        - [（1）InnoDB buffer pool](#1innodb-buffer-pool)

<!-- /code_chunk_output -->

### 概述

#### 1.架构
![](./imgs/overview_01.png)

##### （1）应用层
* 处理连接
* 认证
* 授权

##### （2）mysql server层
* 管理服务和管理工具
* SQL接口
  * 用于接收客户端的SQL语句
* SQL解析器
  * 解析SQL语句
* 优化器
  * 优化解析后的SQL语句
* 缓存
  * 会将select的结果保存在缓存中（where等条件判断是需要cpu计算的，所以不是取数据时计算的，而是取出数据后计算的）
  * 当接收SQL会先在缓存中找，如果找不到才会进行解析和优化，去数据库查

##### （3）存储引擎层
* 存储引擎可以被用在 表 上，一个数据库中可以包含多个不同存储引擎的表

#### 2.并发控制（加锁）

##### （1）读锁和写锁

* 读锁（共享锁）
即可以对一个资源加多个共享锁
```sql
select ... lock in share mode;
```
* 写锁（排他锁）
即加了排他锁后，就无法加其他的任何锁
```sql
select ... for update;
insert ...;
delete ...;
update ...;
```
* select 不加锁

##### （2）锁的粒度
* 行锁
  * 开销较小
  * 并发量较小
</br>
* 表锁
  * 开销更大
  * 并发量更大

#### 3.charset和collate
|charset|collate|说明|
|-|-|-|
|utf8|utf8_bin|3字节utf8编码，区分大小|
|utf8|utf8_general_ci|3字节utf8编码，不区分大小写|
|utf8mb4|utf8mb4_bin|4字节utf8编码（可以存储表情），区分大小|
|utf8mb4|utf8mb4_general_ci|4字节utf8编码（可以存储表情），不区分大小|

#### 4.内存

##### （1）InnoDB buffer pool
The InnoDB buffer pool is a memory area that holds cached InnoDB data for tables, indexes, and other auxiliary buffers.
a recommended innodb_buffer_pool_size value is 50 to 75 percent of system memory.
A buffer pool that is too small may cause excessive churning as pages are flushed from the buffer pool only to be required again a short time later.

A buffer pool that is too large may cause swapping due to competition for memory.
