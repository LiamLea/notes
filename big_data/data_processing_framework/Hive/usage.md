# usage


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [usage](#usage)
    - [基础使用](#基础使用)
      - [1.DDL](#1ddl)
        - [(1) 基本语法](#1-基本语法)
        - [(2) 内表和外表](#2-内表和外表)
        - [(3) 分区表](#3-分区表)
        - [(4) 分桶表](#4-分桶表)
        - [(5) 分区和分桶结合](#5-分区和分桶结合)
        - [(6) 数据的导入导出](#6-数据的导入导出)

<!-- /code_chunk_output -->



### 基础使用

#### 1.DDL

##### (1) 基本语法
```shell
create database if not exists myhive;
use myhive;
desc database myhive;

#指定在hdfs中的路径: /user/hive/myhive2
create database myhive2 location '/myhive2';

drop database myhive2;
#如果有表需要加cascade参数
drop database myhive2 cascade;

#新创建的表会放在新的路径，旧的保持不变
ALTER DATABASE myhive2 SET LOCATION '/myhive_new';
```

* 自定义数据存储在hdfs中的分割符
```shell
create database ... raw format delimited fields terminated by '\t';
```

##### (2) 内表和外表

* 内部表
    * 删除时，元数据 和 存储数据 都会被删除
    ```shell
    CREATE TABLE <table_name> ...
    ```
* 外部表
    * 表和数据是相互独立的
    * 删除时，只删除元数据，存储数据不会被删除
    ```shell
    CREATE EXTERNAL TABLE <table_name> ... LOCATION ...
    ```

* 可以先有数据再也表，也可以先有表，再上传文件（内部表是不是这样的待验证）

* 相互转换
```shell
ALTER TABLE <table_name> tblproperties('EXTERNAL'='TRUE');
ALTER TABLE <table_name> tblproperties('EXTERNAL'='FALSE');
```

##### (3) 分区表

* 分区本质就是hdfs中的**多层子目录**，便于数据的管理和处理
```shell
CREATE TABLE ... PARTITIONED by (<key1> <type>, ...)

#插入数据时，指定各个key的值（不是每条数据指定，而是每次插入操作指定），key相同的为一个分区
LOAD DATA ... [PARTITION(<key1>=<value>,...)]
```

* 举例
    ```shell
    create table myhive.score2(id string, cid string, score int) partitioned by (year string, month string, day string);

    load data local inpath "/tmp/a.txt" into table myhive.score2 partition(year='2022', month='01', day='10');
    ```
    * 对应的目录结构就是

        ```
        /user/hive/warehouse/myhive.db/score2/
        |
        ----- year=2022
                |
                ------ month=01
                        |
                        -------day=10
        ```

##### (4) 分桶表
* 将表拆分到固定数量的文件中（本质就是hash）
* why
    * 可以根据某些字段时，快速定位数据所处文件，从而缩小数据处理的范围
    * 将具有某些相似特征的数据放在一起，便于处理

* 开启分桶的优化
```shell
#启动mapreduce job的数量和bucket的数量一致
set hive.enforce.bucketing=true;
```

* 创建分桶表
```shell
CREATE TABLE ... CLUSTERED by (<field>) into <num> buckets;
#根据<field>字段进行分桶，分为<num>个桶
```

* 只能通过insert方式加载数据
    * 因为LOAD方式只是文件的移动，不能进行计算（而分桶需要进行hash计算）
```shell
INSERT [OVERWRITE | INTO] TABLE <table_name> select ... from ... CLUSTER BY (<field>);
```

##### (5) 分区和分桶结合
先分区，每个分区再进行分桶

##### (6) 数据的导入导出

* 从文件加载数据
    * 文件的分割符要 和 表指定的分割符 一致
```shell
LOAD DATA [LOCAL] INPATH <file_path> [OVERWRITE] INTO TABLE <table_name>;

#LOCAL表示文件在操作系统上的路径，不加LOCAL表示 文件在hdfs中的路径（从hdfs中加载，源文件会消失，本质就是文件的移动）
#OVERWRITE表示覆盖已存在的数据，不加OVERWRITE表示 追加数据
```

* 从其他表加载数据
```shell
INSERT [OVERWRITE | INTO] TABLE <table_name> select ... from ...;

#OVERWRITE表示覆盖，INTO表示追加
```

* 数据导出
```shell
INSERT OVERWRITE [LOCAL] DIRECTORY '<dir>' select .... from ...;
#LOCAL表示文件在操作系统上的路径，不加LOCAL表示 文件在hdfs中的路径

#可以设置文件的分割符
INSERT OVERWRITE [LOCAL] DIRECTORY '<dir>' raw format delimited fields terminated by '\t' select .... from ...;
```