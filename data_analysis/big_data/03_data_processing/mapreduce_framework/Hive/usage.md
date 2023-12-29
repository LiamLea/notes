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
        - [(6) nvl](#6-nvl)
        - [(7) isnull和isnotnull](#7-isnull和isnotnull)
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
      - [10.特殊字符的处理](#10特殊字符的处理)
        - [(1) 对特殊字符进行处理](#1-对特殊字符进行处理)
        - [(2) 使用特殊的文件格式](#2-使用特殊的文件格式)
    - [优化](#优化)
      - [1.hive的并行优化](#1hive的并行优化)
      - [2.hive小文件合并](#2hive小文件合并)
      - [3.矢量化查询](#3矢量化查询)
      - [4.读取零拷贝](#4读取零拷贝)
      - [5.数据倾斜优化](#5数据倾斜优化)
        - [(1) 数据倾斜](#1-数据倾斜)
        - [(2) 判断是否产生数据倾斜](#2-判断是否产生数据倾斜)
        - [(3) group by 数据倾斜优化](#3-group-by-数据倾斜优化)
        - [(4) join 数据倾斜优化](#4-join-数据倾斜优化)
        - [(5) union 优化](#5-union-优化)
        - [(6) 关联优化器(共享shuffle)](#6-关联优化器共享shuffle)

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
#如果username和birthday都是NULL，则返回NULL，否则返回该条记录
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

##### (6) nvl
```sql
#如果value值为null，则返回default_value，否则返回value
nvl(T value, T default_value)
```

##### (7) isnull和isnotnull

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

开启hive自动使用索引: `SET hive.optimize.index.filter=true`

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

#### 10.特殊字符的处理

比如一个数据存在`\n`，则hive读取时，则会看成两行数据

##### (1) 对特殊字符进行处理

比如将`\n`转义称`\\n`

##### (2) 使用特殊的文件格式

比如: 使用sqoop采集数据时，可以用avro、ORC等格式存储数据，读取数据时，一个字段看成一个对象，而不是文本，即使其中有`\n`也不会影响，因为插入的时候数据是一个个对象，而不是字符串

***

### 优化

#### 1.hive的并行优化

* 并行编译
```sql
# hive在同一时刻只能编译一个会话中SQL, 如果有多个会话一起来执行SQL, 此时出现排队的情况, 只有当这一个会话中SQL全部编译后, 才能编译另一个会话的SQL, 导致执行效率变慢

# 是否开启并行编译 设置为true 
# 最大允许同时有多少个SQL一起编译 设置为0表示无限制
hive.driver.parallel.compilation
hive.driver.parallel.compilation.global.limit
```

* 并行执行
```sql
# 在运行一个SQL的时候, 这个SQL形成的执行计划中, 可能会被拆分为多个阶段, 当各个阶段之间没有依赖关系的时候, 可以尝试让多个阶段同时运行, 从而提升运行的效率, 这就是并行执行

# 是否开启并行执行
set hive.exec.parallel=true;
# 最大允许并行执行的数量
set hive.exec.parallel.thread.number=16;
```

#### 2.hive小文件合并

* 小文件的影响
  * hdfs:
    * 每一个小文件, 都会有一份元数据
    * 当小文件过多后, 会导致出现大量的元数据存储namenonde的内存中, 从而导致namenode内存使用率增大
  * MR:
    * 在运行MR的时候, 每一个文件至少是一个文件切片, 也就意味至少需要运行一个mapTask
    * 当小文件过多后, 就会导致产生更多的mapTask, 而每一个mapTask只处理极少的数据, 导致资源被大量占用, 运行的时间都没有申请资源时间长

* hive输出尽可能少的文件
```sql
hive.merge.mapfiles : 是否开启map端小文件合并 (适用于MR只有map没有reduce, map输出结果就是最终结果)
hive.merge.mapredfiles : 是否开启reduce端小文件合并操作
hive.merge.size.per.task: 合并后输出文件的最大值 ,默认是128M
hive.merge.smallfiles.avgsize: 判断输出各个文件平均大小, 当这个大小小于设置值, 认为出现了小文件问题,需要进行合并操作

/*

比如说: 设置合并文件后, 输出最大值128M, 设置平均值为 50M
	假设一个MR输出一下几个文件: 
		 1M,10M,5M,3M,150M,80M,2M  平均值:35.xxx
		
		发现输出的多个文件的平均值比设定的平均值要小, 说明出现小文件的问题, 需要进行合并, 此时会合并结果为:
		128M,123M

*/
```

#### 3.矢量化查询
* 让hive在读取数据的时候, 一批一批的读取, 默认是一条一条的读, 一条条的处理
* 前提条件: 表的文件存储格式必须为ORC
```sql
set hive.vectorized.execution.enabled=true;
```

#### 4.读取零拷贝
* 在hive读取数据的时候, 只需要读取跟SQL相关的列的数据即可, 不使用列, 不进行读取, 从而减少读取数据, 提升效率
* 提前条件: 表的文件存储格式必须为ORC
```sql
set hive.exec.orc.zerocopy=true;
```

#### 5.数据倾斜优化

##### (1) 数据倾斜

* what
  * 在运行过程中,有多个reduce, 每一个reduce拿到的数据不是很均匀
  * 导致其中某一个或者某几个reduce拿到数据量远远大于其他的reduce拿到数据量, 此时认为出现了数据倾斜问题

* 影响
  * 执行效率下降(整个执行时间, 就看最后一个reduce结束时间)
  * 由于其中某几个reduce长时间运行, 资源长期被占用, 一旦超时, YARN强制回收资源, 导致运行失败
  * 资源利用率低

##### (2) 判断是否产生数据倾斜

* 查看job日志
  * 观察是否有执行较慢的reduce
* 

##### (3) group by 数据倾斜优化

* 方案一: combiner
  * 在每个map任务中提前进行reduce，再将结果发送给reduce
  ```sql
  # 开启map端提前聚合操作(combiner)
  set hive.map.aggr=true;
  ```

* 方案二: 负责均衡（大combiner）
  * 采用两个MR来解决
    * 第一个MR负责将数据均匀落在不同reduce上, 进行聚合统计操作, 形成一个局部的结果
    * 在运行第二个MR读取第一个MR的局部结果, 按照相同key发往同一个reduce的方案, 完成最终聚合统计操作
  ```sql
  set hive.groupby.skewindata=true;
  # 一旦使用方案二, hive不支持多列上的采用多次distinct去重操作, 一旦使用, 就会报错
  ```

##### (4) join 数据倾斜优化

* 方案一: map join、bucket map join、SMB map join

* 方案二: 
  * 将那些容易产生倾斜的key的值, 从这个环境中, 排除掉, 这样自然就没有倾斜问题, 讲这些倾斜的数据单独找一个MR来处理即可
  * 编译期解决方案:
    * 需要提前知道哪些key会发生倾斜
    ```sql
    set hive.optimize.skewjoin.compiletime=true;

    CREATE TABLE list_bucket_single (key STRING, value STRING)
    -- 倾斜的字段和需要拆分的key值
    SKEWED BY (key) ON (1,5,6)
    --  为倾斜值创建子目录单独存放
    [STORED AS DIRECTORIES];
    ```
  * 运行期解决方案:
    * 在执行的过程中, hive会记录每一个key出现的次数, 当出现次数达到设置的阈值后, 认为这个key有倾斜的问题, 直接将这个key对应数据排除掉, 单独找一个MR来处理即可
    ```sql
    # 是否开启运行期倾斜解决join
    set hive.optimize.skewjoin=true;
    # 当key出现多少个的时候, 认为有倾斜
    set hive.skewjoin.key=100000;
    ```

##### (5) union 优化

* 此项配置减少对Union all子查询中间结果的二次读写
* 此项配置一般和join的数据倾斜组合使用
```sql
set hive.optimize.union.remove=true;
```

##### (6) 关联优化器(共享shuffle)
```properties
配置:
	set hive.optimize.correlation=true;

说明:
	在Hive的一些复杂关联查询中，可能同时还包含有group by等能够触发shuffle的操作，有些时候shuffle操作是可以共享的，通过关联优化器选项，可以尽量减少复杂查询中的shuffle，从而提升性能。
	
	
比如: 
	select  id,max(id)  from itcast_ods.web_chat_ems group by id;
	union all
	select  id,min(id)  from itcast_ods.web_chat_ems group by id;
```