# overview

[toc]

### 概述

#### 1.常用的三种存储形式
![](./imgs/overview_01.png)

##### （1）block storage（块存储）
通过 大小相同的block 组织数据，通过block id索引数据
* 可以跨多种环境存储数据（比如：linux、windows等）

##### （2）file storage（文件存储）
通过 层级结构 组织数据，通过file id（server name + directory path + filename）索引数据
* 无法在多个文件服务器之间分散工作负载


##### （3）object storage（对象存储）
通过 key-value方式 组织数据，通过key索引数据
metadata用于描述该对象

* 对象不能被修改
