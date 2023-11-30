# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.DataFrame](#1dataframe)
    - [使用](#使用)
      - [1.创建dataframe](#1创建dataframe)
        - [(1) rdd -> dataframe](#1-rdd---dataframe)
        - [(2) pandas dataframe -> dataframe](#2-pandas-dataframe---dataframe)
      - [2.文件 <-> dataframe](#2文件---dataframe)
        - [(1) 读取文件](#1-读取文件)
        - [(2) 写入文件](#2-写入文件)
      - [3.使用dataframe](#3使用dataframe)
      - [4.使用DSL语法分析dataframe](#4使用dsl语法分析dataframe)
        - [(1) 对Column处理的函数](#1-对column处理的函数)
      - [5.使用SQL分析dataframe](#5使用sql分析dataframe)
        - [(1) 将dataframe转换为表](#1-将dataframe转换为表)
        - [(2) 使用SQL](#2-使用sql)
        - [(3) 举例](#3-举例)
      - [6. DataFrame数据清洗](#6-dataframe数据清洗)
      - [7.使用Hive创建的库](#7使用hive创建的库)
        - [(1) spark启动hiveserver2](#1-spark启动hiveserver2)
    - [自定义函数](#自定义函数)
      - [1.UDF](#1udf)

<!-- /code_chunk_output -->


### 概述

#### 1.DataFrame
是一个**表结构**（二维），用于处理结构化数据
* StructType对象 描述 整个表的结构
* StructField对象 描述 一个列的信息

***

### 使用

#### 1.创建dataframe

注意：只有二维的数据结构才能转换为dataframe

##### (1) rdd -> dataframe

```python
from pyspark.sql.types import StructType,StringType,IntegerType

"""
c.csv:
1,liyi,11
2,lier,80
...
"""
rdd = sc.textFile("c.csv")
#第二个map将id转换为int类型
rdd1 = rdd.map(lambda x: x.split(",")).map(lambda x: (int(x[0]), x[1], x[2]))

#定义dataframe结构（即表结构）
schema = StructType().add("id", IntegerType(), nullable=False).\
    add("name", StringType()).\
    add("score",StringType())

#创建dataframe
df = spark.createDataFrame(rdd1, schema=schema)

#或者
#df = rdd1.toDF(schema=schema)

df.printSchema()
df.show()
```

##### (2) pandas dataframe -> dataframe

```python
pdf = pandas.DataFrame (
    {
        "id": [1,2,3],
        "name": ["liyi","lier","lisan"],
        "score": [88, 71,96]
    }
)

schema = StructType().add("id", IntegerType(), nullable=False).\
    add("name", StringType()).\
    add("score",StringType())

df = spark.createDataFrame(pdf, schema=schema)

df.printSchema()
df.show()
```

#### 2.文件 <-> dataframe

|文件类型|说明|
|-|-|
|text|一行就是一列，不能进行分割|
|json|一条json数据必须在一行（形如: `{<field_1>:<value_1>, <field_2>:<value_2>}`）|
|csv|可以通过分割符（默认为逗号）分割|
|parquet||
|jdbc|能够连接数据库读取|
|table和saveAsTable|如果设置了hive，则会写入hive|

##### (1) 读取文件
```python
#将spark.read.<format>和createDataFrame这两个函数结合了
#需要看option有哪些参数时，可以进入这个方法去看：spark.read.<format>

df = spark.read.format(<format>).\
    schema(schema=schema).\
    option(<key>, <value>).\
    load(<path>)
```

* text
```python
schema = StructType().add("dara", StringType())

df = spark.read.format("text").\
    schema(schema=schema).\
    load("c.csv")
```

* json
    * json文件
    ```json
    {"name": "liyi","id": "1"}
    {"name": "lier","id": "2"}
    ```
    * 代码
    ```python
    df = spark.read.format("json").\
    load("c.json")
    ```

* csv
```python
"""
c.csv:
id,name,score
1,liyi,11
2,lier,80
...
"""

df = spark.read.format("csv").\
    option("sep",",").\
    option("header", True).\
    option("encoding", "utf-8").\
    schema("id INT,name STRING,score INT").\
    load("c.csv")
```

* parquet
```python
df = spark.read.format("parquet").\
load("c.parquet")
```

##### (2) 写入文件
```python
#需要看option有哪些参数时，可以进入这个方法去看：<df>.write.<format>
#mode有error（默认）、append、overwrite等

df.write.mode().format(<format>).\
    option(<key>, <value>).\
    save(<path>)
```

#### 3.使用dataframe

* 获取column对象
```python
id_column = df['id']
```

#### 4.使用DSL语法分析dataframe
```python
df.select("id","name").show()

df.filter("id<2").show()
df.filter(df["id"]<2).show()

df.where("id<2").show()
df.where(df["id"]<2).show()

df.groupBy("subject").count()
```

##### (1) 对Column处理的函数

* 这个库里有大量的 对Column处理的函数（比如：split等）
```python
from pyspark.sql import functions
```

#### 5.使用SQL分析dataframe

##### (1) 将dataframe转换为表
```python
#创建一个临时视图
df.createTempView(<table_name>)

#创建一个全局视图（能够跨越多个sparkSession）
#使用时的表名就是: global_temp.<table_name>
df.createGlobalTempView(<table_name>)
```

##### (2) 使用SQL
```python
spark.sql("""
select * from <table_name>
""").show()
```

##### (3) 举例
```python
from pyspark.sql import functions

df.groupBy("moive_id").\
    agg(
        functions.count("movie_id").alias("cnt"),
        functions.round(founctions.avg("rank"), 2).alias("avg_rank")
    ).where("cnt>100").\
    orderBy("avg_rank", ascending=False).\
    limit(10).\
    show()
```

#### 6. DataFrame数据清洗
```python
#也可以传入一些列名，根据指定的列去左操作

#去重
df.dropDuplicates()

#去除有空值的
df.dropna()

#对空值进行填充
df.fillna({"name": "unknown"})
```

#### 7.使用Hive创建的库

* 首先获取metastore的监听地址
```shell
ps aux | grep -i metastore
ss -tulnp | grep <pid>
```

* spark使用hive

```python
import os
#设置用户，否则连接hdfs会有权限问题
os.environ['HADOOP_USER_NAME'] = "hdfs"

conf = SparkConf().setAppName("test")
#配置metastore地址
conf.set("hive.metastore.uris", "thrift://hadoop-01:9083")

#一定要enableHiveSupport()
spark  = SparkSession.builder.\
    config(conf=conf).\
    enableHiveSupport().\
    getOrCreate()

sc = spark.sparkContext

#如果没有连上hive，只能查到default库
spark.sql("""
show databases;
""").show()
```

##### (1) spark启动hiveserver2
```shell
./sbin/start-thriftserver.sh \
    --hiveconf hive.server2.thrift.port=10001 \
    --hiveconf hive.metastore.uris="thrift://hadoop-01:9083"
```

* 使用datagrid连接
    * 数据源选择spark
    * 用户设为hdfs
        * 因为该环境，只有hdfs用户有权限访问hdfs文件系统

***

### 自定义函数

python现在只支持：UDF(user-defined function)，不支持UDAF(user-defined aggregation function)、UDTF(user-defined table-generating function)
* 通过RDD进行聚合实现UDAF

#### 1.UDF

```python
rdd = sc.parallelize(range(1,10)).map(lambda x: [x])
df = rdd.toDF(schema=["num"])

#定义UDF
def num_times(x):
    return x*10

#注册UDF
udf2 = spark.udf.register("udf1", num_times, IntegerType())


#通过SQL方式使用
df.createTempView("test")
spark.sql("""
select udf1(num) from test;
""").show()

#通过DSL方式使用
df.select(udf2("num")).show()
```