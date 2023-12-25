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
      - [3.复杂数据类型](#3复杂数据类型)
        - [(1) array类型](#1-array类型)
        - [(2) map类型](#2-map类型)
        - [(3) struct类型](#3-struct类型)
      - [4.查询操作](#4查询操作)
        - [(1) 基本查询](#1-基本查询)
        - [(2) 数据抽样](#2-数据抽样)
        - [(3) 虚拟列](#3-虚拟列)
      - [5.更新和删除操作](#5更新和删除操作)
      - [6.常用函数](#6常用函数)
        - [(1) 查看有哪些函数和其具体用法](#1-查看有哪些函数和其具体用法)
        - [(2) if](#2-if)
        - [(3) coalesce](#3-coalesce)
        - [(4) case](#4-case)
        - [(5) nullif](#5-nullif)
      - [7.分桶更多操作](#7分桶更多操作)
        - [(1) 进行数据采样](#1-进行数据采样)
        - [(2) 查询优化](#2-查询优化)
      - [8.提升查询效率](#8提升查询效率)
        - [(1) 单表](#1-单表)
        - [(2) 多表 (join)](#2-多表-join)
        - [(3) 查看 某条查询语句 是否会进优化](#3-查看-某条查询语句-是否会进优化)
      - [9.索引](#9索引)
        - [(1) 原始索引（已不支持）](#1-原始索引已不支持)
        - [(2) row group index](#2-row-group-index)
        - [(3) bloom filter index](#3-bloom-filter-index)

<!-- /code_chunk_output -->



### 基础使用

#### 1.DDL

##### (1) 基本语法
```SQL
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
```SQL
create database ... 
row format delimited 
fields terminated by '\t';
```

* 修改表
```SQL
#重命名表
ALTER TABLE <table_name> RENAME TO <table_name>;

#设置表的属性
ALTER TABLE <table_name> SET TBLPROPERTIES(<property>=<value>, ...);

#添加列
ALTER TABLE <table_name> ADD COLUMNS(<field> <type>, ...);

#重命名列
ALTER TABLE <table_name> CHANGE <field> <new_field_name> <type>;
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
    * 可以先有数据再也表，也可以先有表，再上传文件
    ```shell
    CREATE EXTERNAL TABLE <table_name> ... LOCATION ...

    #可以指定格式，比如parquet
    CREATE EXTERNAL TABLE <table_name> ... STORED AS PARQUET LOCATION ...
    ```
    
* 相互转换
```SQL
ALTER TABLE <table_name> tblproperties('EXTERNAL'='TRUE');
ALTER TABLE <table_name> tblproperties('EXTERNAL'='FALSE');
```

##### (3) 分区表

* 分区本质就是hdfs中的**多层子目录**，便于数据的管理和处理
```SQL
CREATE TABLE ... PARTITIONED by (<key1> <type>, ...)

#插入数据时，指定各个key的值（不是每条数据指定，而是每次插入操作指定），key相同的为一个分区
LOAD DATA ... [PARTITION(<key1>=<value>,...)]
```

* 举例
    ```SQL
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

* 基本操作
```SQL
#添加分区
ALTER TABLE <table_name> ADD PARTITION(year="2023");

#修改分区名（hdfs中的文件夹不会改名，而是修改了元数据中的映射）
ALTER TABLE <table_name> PARTITION(year="2020") RENAME TO PARTITION(year="2021");

#删除分区（只是删除元数据中的记录，数据本身还在hdfs中）
ALTER TABLE <table_name> DROP PARTITION(year="2021");
```

##### (4) 分桶表
* 将表拆分到固定数量的文件中（本质就是hash）
* why
    * 可以根据某些字段时，快速定位数据所处文件，从而缩小数据处理的范围
    * 将具有某些相似特征的数据放在一起，便于处理

* 开启分桶的优化
```SQL
#启动mapreduce job的数量和bucket的数量一致
set hive.enforce.bucketing=true;
```

* 创建分桶表
```SQL
CREATE TABLE ... CLUSTERED by (<field>) into <num> buckets;
#根据<field>字段进行分桶，分为<num>个桶
```

* 只能通过insert方式加载数据
    * 因为LOAD方式只是文件的移动，不能进行计算（而分桶需要进行hash计算）
```SQL
INSERT [OVERWRITE | INTO] TABLE <table_name> select ... from ... CLUSTER BY (<field>);
```

##### (5) 分区和分桶结合
先分区，每个分区再进行分桶

##### (6) 数据的导入导出

* 从文件加载数据
    * 文件的分割符要 和 表指定的分割符 一致
```SQL
LOAD DATA [LOCAL] INPATH <file_path> [OVERWRITE] INTO TABLE <table_name>;

#LOCAL表示文件在操作系统上的路径，不加LOCAL表示 文件在hdfs中的路径（从hdfs中加载，源文件会消失，本质就是文件的移动）
#OVERWRITE表示覆盖已存在的数据，不加OVERWRITE表示 追加数据
```

* 从其他表加载数据
```SQL
#OVERWRITE表示覆盖，INTO表示追加
INSERT [OVERWRITE | INTO] TABLE <table_name> select ... from ...;
```

* 根据查询结果创建表
```SQL
CREATE TABLE <table_name> AS
SELECT ...;
```

* 数据导出
```SQL
INSERT OVERWRITE [LOCAL] DIRECTORY '<dir>' select .... from ...;
#LOCAL表示文件在操作系统上的路径，不加LOCAL表示 文件在hdfs中的路径

#可以设置文件的分割符
INSERT OVERWRITE [LOCAL] DIRECTORY '<dir>' 
row format delimited 
fields terminated by '\t' 
select .... from ...;
```

#### 3.复杂数据类型

##### (1) array类型
```SQL
#work_locations这个array中的元素使用逗号隔开
CREATE TABLE myhive.test_array(name string, work_locations array<string>) 
ROW FORMAT DELIMITED 
COLLECTION ITEMS TERMINATED BY ',';

SELECT * FROM myhive.test_arrary where ARRAY_CONTAINS (work_locations, 'beijing');
```

##### (2) map类型
```SQL
#members的形式: k1:v1#k2:v2#k3:v3
CREATE TABLE myhive.test_map(id int, name string, members map<string, string>, age int)
ROW FORMAT DELIMITED
COLLECTION ITEMS TERMINATED BY '#';
MAP KEYS TERMINATED BY ':';

SELECT members['k1'] FROM myhive.test_map;
#map_keys和map_values返回的是array
SELECT map_keys(members) FROM myhive.test_map;
SELECT map_values(members) FROM myhive.test_map;
SELECT size(members) FROM myhive.test_map;
```

##### (3) struct类型
可以在一个列中划分多个子列
```SQL
CREATE TABLE myhive.test_struct(id string, info struct<name: string, age: int>)
ROW FORMAT DELIMITED 
COLLECTION ITEMS TERMINATED BY ':';

SELECT info.name, info.age FROM myhive.test_struct;
```

#### 4.查询操作

##### (1) 基本查询
参考MYSQL

##### (2) 数据抽样

* 基于桶抽样
```SQL
#先将数据分为<num2>个桶，然个取出其中<num1>个桶的数据
#有两种分桶方式：一是按照用户指定的列进行分桶，二是随即分桶
SELECT ... FROM <table_name>
TABLESAMPLE(BUCKET <num1> OUT OF <num2> ON(<field_name> | rand()))
```

* 基于数据块抽样
```SQL
#抽取一定数量的数据（比如 100行 或 10% 或 1G） 
SELECT ... FROM <table_name>
TABLESAMPLE(<num> ROWS | <num> PERCENT | <num>(K|M|G))
```

##### (3) 虚拟列

* INPUT_FILE_NAME
    * 显示数据所在的具体文件

* BLOCK_OFFSET_INSIDE_FILE
    * 显示数据所在文件的偏移量

* ROW_OFFSET_INSIDE_BLOCK
    * 显示数据所在HDFS块的偏移量
    * 需要 `SET hive.exec.rowoffset=true`才可以使用

```shell
select name,INPUT_FILE_NAME from myhive.user;
```

#### 5.更新和删除操作
不能更新和删除 某条记录，只能删除分区或者表
```sql
alter table <table> drop partition(...);
```

#### 6.常用函数

##### (1) 查看有哪些函数和其具体用法
```SQL
show functions;
describe function extended <function_name>;
```

##### (2) if
```SQL
select if(username is NULL, "不知道名字", username) from users;
```

##### (3) coalesce
返回第一字段不是NULL的数据，如果都是NULL，则返回NULL

```SQL
#返回username不是NULL的数据，如果username和birthday都是NULL，则返回NULL
select coalesce(username, birthday) from users;
```

##### (4) case
```SQL
CASE [<a>] when <b> THEN <c> 
[WHEN <d> THEN <e>]
[ELSE <f>]
END;

select username, 
case username when "周杰伦" then "知名歌星" else "未知" end 
from users;

select username, 
case when username is null then "未知" else username end 
from users;
```

##### (5) nullif

```SQL
#如果<a>和<b>相等则返回NULL，否则返回<a>
nullif(<a>, <b>);
```

#### 7.分桶更多操作

##### (1) 进行数据采样
* 采样函数: 
```sql
tablesample(bucket x out of y on column)

/*
    x:  从第几个桶开始进行采样
    y:  抽样比例(总桶数/y = 分多少个桶)
    column: 分桶的字段, 可以省略的

    注意:
        x 不能大于 y
        y 必须是表的分桶数量的倍数或者因子


案例: 
    1) 假设 A表有10个桶,  请分析, 下面的采样函数, 会将那些桶抽取出来
         tablesample(bucket 2 out of 5 on xxx)
       
       会抽取几个桶呢?    总桶 / y =  分桶数量    2
       抽取第几个编号的桶?  (x+y)
           2,7
    2)  假设 A表有20个桶,  请分析, 下面的采样函数, 会将那些桶抽取出来
   		 tablesample(bucket 4 out of 4 on xxx)
   	   
   	   会抽取几个桶呢?    总桶 / y =  分桶数量    5
       抽取第几个编号的桶?  (x+y)
           4,8,12,16,20

         tablesample(bucket 4 out of 40 on xxx)
         从编号为4的桶中抽取 1/2 的数据
*/
```

##### (2) 查询优化
参考 提升查询效率

#### 8.提升查询效率

优化需要足够的**资源**才有效果，因为资源不够的话可能无法并行（反而没有优化前快）

##### (1) 单表
使用bucket

##### (2) 多表 (join)

默认是reduce join（可能存在问题: 数据倾斜 和 导致reduce压力较大）

* 小表和大表
    * 采用map join
        * 在进行join的时候, 将小表的数据放置到每一个读取大表的mapTask的内存中, 让mapTask每读取一次大表的数据都和内存中小表的数据进行join操作, 将join上的结果输出到reduce端即可, 从而实现在map端完成join的操作
        * 开启map join
        ```sql
        set hive.auto.convert.join=true;  -- 是否开启map Join
	    set hive.auto.convert.join.noconditionaltask.size=512000000; -- 设置小表最大的阈值(设置block cache 缓存大小)
        ```

* 中表和大表
    * 中型表: 与小表相比 大约是小表3~10倍左右
    * 解决方案:
        1. 能提前过滤就提前过滤掉(一旦提前过滤后, 会导致中型表的数据量会下降, 有可能达到小表阈值)
        1. 如果join的字段值有大量的null, 可以尝试添加随机数(保证各个reduce接收数据量差不多的, 减少数据倾斜问题)
        1. 基于分桶表的: bucket map join
        ```properties
        bucket map join的生效条件:
        1） set hive.optimize.bucketmapjoin = true;  --开启bucket map join 支持
        2） 一个表的bucket数是另一个表bucket数的整数倍
        3） bucket列 == join列
        4） 必须是应用在map join的场景中

        注意：如果表不是bucket的，则只是做普通join
        ```

* 大表和大表
    * 解决方案:
        1. 能提前过滤就提前过滤掉(减少join之间的数量, 提升reduce执行效率)
        1. 如果join的字段值有大量的null, 可以尝试添加随机数(保证各个reduce接收数据量差不多的, 减少数据倾斜问题)
        1. SMB Map join (sort merge bucket map join)
        ```properties
        实现SMB map join的条件要求: 
        1） 一个表的bucket数等于另一个表bucket数(分桶数量是一致)
        2） bucket列 == join列 == sort 列
        3） 必须是应用在bucket map join的场景中
        4) 开启相关的参数:
            set hive.optimize.bucketmapjoin = true;  --开启bucket map join 支持

            -- 开启SMB map join
            set hive.auto.convert.sortmerge.join=true;
            set hive.auto.convert.sortmerge.join.noconditionaltask=true;

            -- 写入数据强制排序
            set hive.enforce.sorting=true;

            -- 开启自动尝试SMB连接
            set hive.optimize.bucketmapjoin.sortedmerge = true;
        ```

##### (3) 查看 某条查询语句 是否会进优化

* 通过查看查询计划
```sql
example 
...;

/*
查找关键字: map join
*/
```

#### 9.索引
当分区和分桶受限，可以使用索引进行优化

##### (1) 原始索引（已不支持）
可以根据某一列或某几列构建索引
数据更新后，需要手动更新索引表

##### (2) row group index
只能应用在**ORC**中
向表中加载数据时，必须对 需要使用索引的字段进行**排序**

* 开启（创建表时）
```sql
'orc.create.index'='true'
```

##### (3) bloom filter index

只能应用在**ORC**中
只能进行等值索引，会列出每个stripe中 索引字段的 **所有不同的值**
一般对于**join字段**，使用该索引
* 开启（创建表时）
```sql
'orc.bloom.filter.columns'='pcid'
```