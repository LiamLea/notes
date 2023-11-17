# Hive


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Hive](#hive)
    - [概述](#概述)
      - [1.介绍](#1介绍)
      - [2.核心组件](#2核心组件)
      - [3.Metastore](#3metastore)
      - [4.hive中数据库和hdfs关系](#4hive中数据库和hdfs关系)

<!-- /code_chunk_output -->


### 概述

#### 1.介绍

将 SQL 转换成 MapReduce程序，处理结构化数据

#### 2.核心组件
* SQL解析器
* 元数据管理（即metastore）

#### 3.Metastore

* 数据位置
* 数据结构
* 等等

#### 4.hive中数据库和hdfs关系

hive中数据库的数据默认存储在 `hdfs://user/hive/warehouse`中
创建数据库时，可以指定存储在其他目录中