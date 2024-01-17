# SQL


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SQL](#sql)
    - [使用](#使用)
      - [1.使用SQL client](#1使用sql-client)
        - [(1) 配置](#1-配置)
        - [(2) 基本命令](#2-基本命令)
      - [2.DDL](#2ddl)
        - [(1) 建表](#1-建表)
        - [(1) 设置workmark](#1-设置workmark)
      - [3.connector](#3connector)
        - [(1) kafka](#1-kafka)
      - [4.catalog (类似于hive的metastore)](#4catalog-类似于hive的metastore)
        - [(1) 类型](#1-类型)
    - [查询](#查询)
      - [1. 多维分析（多个groupby）](#1-多维分析多个groupby)
        - [(1) GROUPING SETS](#1-grouping-sets)
      - [2.窗口表值函数（TVF）聚合](#2窗口表值函数tvf聚合)
        - [(1) 滚动窗口](#1-滚动窗口)
        - [(2) 滑动窗口](#2-滑动窗口)
        - [(3) 累积窗口](#3-累积窗口)
        - [(4) GROUPING SETS](#4-grouping-sets)
      - [3.over聚合](#3over聚合)
      - [4.topN](#4topn)
      - [5.去重](#5去重)
      - [6.join](#6join)
        - [(1) regular join](#1-regular-join)
        - [(2) interval join](#2-interval-join)
        - [(3) lookup join](#3-lookup-join)
      - [7.SQL hints（查询时临时修改表参数）](#7sql-hints查询时临时修改表参数)
      - [8.系统函数](#8系统函数)
      - [9.module操作](#9module操作)

<!-- /code_chunk_output -->

### 使用

#### 1.使用SQL client
```shell
./flink-1.18.0/bin/sql-client.sh -s yarn-sessison  -i <init.sql>
```

##### (1) 配置
[参考](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/dev/table/config/)
```SQL
SET 'sql-client.execution.result-mode'=tableau;
SET 'table.exec.resource.default-parallelism'=1;
SET 'table.exec.state.ttl'=1000;
```

##### (2) 基本命令
```sql
show jobs;

stop job <job_id> with savepoint;

--从savepoint恢复
SET execution.savepoint.path='hdfs://hadoop102:8020/sp/savepoint-37f5e6-0013a2874f0a';
--提交作业后重置
RESET execution.savepoint.path
```

#### 2.DDL

##### (1) 建表
```sql
CREATE TABLE [IF NOT EXISTS] [catalog_name.][db_name.]table_name
  (
    { <physical_column_definition> | <metadata_column_definition> | <computed_column_definition> }[ , ...n]
    [ <watermark_definition> ]
    [ <table_constraint> ][ , ...n]
  )
  [COMMENT table_comment]
  [PARTITIONED BY (partition_column_name1, partition_column_name2, ...)]
  WITH (key1=val1, key2=val2, ...)
  [ LIKE source_table [( <like_options> )] | AS select_query ]
```

* physical_column_definition
    * 常规列，创建表时指定的
* metadata_column_definition
    * 定义元数据信息，值来自输入
    ```sql
    #比如
    `record_time` TIMESTAMP_LTZ(3) METADATA FROM 'timestamp'

    #如果字段名一样，不需要写FROM ...
    `timestamp` TIMESTAMP_LTZ(3) METADATA
    ```
* computed_column_definition
    * 由其他列运算得到
* watermark_definition
    * 定义watermark
* 可以定义主键: PRIMARY KEY
* with
    * 指定相关参数，对接外部系统等

##### (1) 设置workmark
```sql
CREATE TABLE ws (
  id INT,
  vc INT,
  pt AS PROCTIME(), --处理时间
  et AS cast(CURRENT_TIMESTAMP as timestamp(3)), --事件时间
  WATERMARK FOR et AS et - INTERVAL '5' SECOND   --watermark
) WITH (
  'connector' = 'datagen',
  'rows-per-second' = '10',
  'fields.id.min' = '1',
  'fields.id.max' = '3',
  'fields.vc.min' = '1',
  'fields.vc.max' = '100'
)
```

#### 3.connector

##### (1) kafka
* 需要先将相关的依赖移动到lib目录下

* 创建Kafka的映射表
```sql
CREATE TABLE t1( 
  `event_time` TIMESTAMP(3) METADATA FROM 'timestamp',
  --列名和元数据名一致可以省略 FROM 'xxxx', VIRTUAL表示只读
  `partition` BIGINT METADATA VIRTUAL,
  `offset` BIGINT METADATA VIRTUAL,
id int, 
ts bigint , 
vc int )
WITH (
  'connector' = 'kafka',
  'properties.bootstrap.servers' = 'hadoop103:9092',
  'properties.group.id' = 'atguigu',
-- 'earliest-offset', 'latest-offset', 'group-offsets', 'timestamp' and 'specific-offsets'
  'scan.startup.mode' = 'earliest-offset',
  -- fixed为flink实现的分区器，一个并行度只写往kafka一个分区
'sink.partitioner' = 'fixed',
  'topic' = 'ws1',
  'format' = 'json'
) 
```

* 插入和查询
```sql
insert into t1(id,ts,vc) select * from source

select * from t1
```

#### 4.catalog (类似于hive的metastore)

##### (1) 类型

* GenericInMemoryCatalog
* JdbcCatalog
    * 自动创建表的映射，不能自己创建表的
* HiveCatalog（建议）
    * 不仅能自动创建表的映射，还能自己创建表，并且持久化
    ```sql
    --写入 flink sql的初始化脚本，这样不用每次执行了
    --在该catalog创建的库和表都持久化了，不用每次都创建了
    CREATE CATALOG myhive WITH (
    'type' = 'hive',
    'default-database' = 'default',
    'hive-conf-dir' = '/opt/module/hive/conf'
    );
    ```
* 用户自定义 Catalog

***

### 查询

#### 1. 多维分析（多个groupby）

##### (1) GROUPING SETS
    * 还支持Rollup（上卷）、Cube（下钻），与GROUPING SETS类似
```sql
SELECT
  supplier_id
, rating
, product_id
, COUNT(*)
FROM (
VALUES
  ('supplier1', 'product1', 4),
  ('supplier1', 'product2', 3),
  ('supplier2', 'product3', 3),
  ('supplier2', 'product4', 4)
)

AS Products(supplier_id, product_id, rating)  
GROUP BY GROUPING SETS(
  (supplier_id, product_id, rating),
  (supplier_id, product_id),
  (supplier_id, rating),
  (supplier_id),
  (product_id, rating),
  (product_id),
  (rating),
  ()
);
```

#### 2.窗口表值函数（TVF）聚合

* 将一个窗口看作是一个表

##### (1) 滚动窗口
```sql
SELECT 
window_start, 
window_end, 
id , SUM(vc) 
sumVC
FROM TABLE(
  TUMBLE(TABLE ws, DESCRIPTOR(et), INTERVAL '5' SECONDS))
GROUP BY window_start, window_end, id;
```

##### (2) 滑动窗口
* 要求： 窗口长度=滑动步长的整数倍（底层会优化成多个小滚动窗口）
```sql
SELECT window_start, window_end, id , SUM(vc) sumVC
FROM TABLE(
  HOP(TABLE ws, DESCRIPTOR(et), INTERVAL '5' SECONDS , INTERVAL '10' SECONDS))
GROUP BY window_start, window_end, id;
```

##### (3) 累积窗口
* 累积窗口会在一定的统计周期内进行累积计算
* 累积步长（step）：在统计的过程中多就输出一次
* 注意： 窗口最大长度 = 累积步长的整数倍
```sql
SELECT 
window_start, 
window_end, 
id , 
SUM(vc) sumVC
FROM TABLE(
  CUMULATE(TABLE ws, DESCRIPTOR(et), INTERVAL '2' SECONDS , INTERVAL '6' SECONDS))
GROUP BY window_start, window_end, id;
```

##### (4) GROUPING SETS
```sql
SELECT 
window_start, 
window_end, 
id , 
SUM(vc) sumVC
FROM TABLE(
  TUMBLE(TABLE ws, DESCRIPTOR(et), INTERVAL '5' SECONDS))
GROUP BY window_start, window_end,
rollup( (id) )
--  cube( (id) )
--  grouping sets( (id),()  )
;
```

#### 3.over聚合
```sql
SELECT
  agg_func(agg_col) OVER (
    [PARTITION BY col1[, col2, ...]]
    ORDER BY time_col
    range_definition),
  ...
FROM ...
```

* 统计每个传感器前10秒到现在收到的水位数据条数
```sql
SELECT 
    id, 
    et, 
    vc,
count(vc) OVER w AS cnt,
sum(vc) OVER w AS sumVC
FROM ws
WINDOW w AS (
    PARTITION BY id
    ORDER BY et
    RANGE BETWEEN INTERVAL '10' SECOND PRECEDING AND CURRENT ROW
)
```

* 统计每个传感器前5条到现在数据的平均水位
```sql
SELECT 
    id, 
    et, 
    vc,
avg(vc) OVER w AS avgVC,
count(vc) OVER w AS cnt
FROM ws
WINDOW w AS (
    PARTITION BY id
    ORDER BY et
    ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
)
```

#### 4.topN
```sql
SELECT [column_list]
FROM (
SELECT [column_list],
ROW_NUMBER() OVER ([PARTITION BY col1[, col2...]]
ORDER BY col1 [asc|desc][, col2 [asc|desc]...]) AS rownum
FROM table_name)
WHERE rownum <= N [AND conditions]
```

#### 5.去重
* 对每个传感器的水位值去重
```sql
    select 
        id,
        et,
        vc,
        row_number() over(
            partition by id,vc 
            order by et 
        ) as rownum
    from ws
)
where rownum=1;
```

#### 6.join

##### (1) regular join
* 等值inner join
```sql
SELECT *
FROM ws
INNER JOIN ws1
ON ws.id = ws1.id
```

##### (2) interval join
```sql
SELECT *
FROM ws,ws1
WHERE ws.id = ws1. id
AND ws.et BETWEEN ws1.et - INTERVAL '2' SECOND AND ws1.et + INTERVAL '2' SECOND 
```

##### (3) lookup join

关联外部维度表
```sql
CREATE TABLE Customers (
  id INT,
  name STRING,
  country STRING,
  zip STRING
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mysql://hadoop102:3306/customerdb',
  'table-name' = 'customers'
);

-- order表每来一条数据，都会去mysql的customers表查找维度数据

SELECT o.order_id, o.total, c.country, c.zip
FROM Orders AS o
  JOIN Customers FOR SYSTEM_TIME AS OF o.proc_time AS c
    ON o.customer_id = c.id;
```

#### 7.SQL hints（查询时临时修改表参数）
```sql
select * from ws1/*+ OPTIONS('rows-per-second'='10')*/;
```

#### 8.系统函数

[参考](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/dev/table/functions/systemfunctions/)

#### 9.module操作
加载其他module（比如hive module），可以扩展flink sql的能力
```sql
--查看已加载的module
show modules;

--加载module
LOAD MODULE <module_name> ...;

--卸载module
UNLOAD MODULE <module_name>;
```