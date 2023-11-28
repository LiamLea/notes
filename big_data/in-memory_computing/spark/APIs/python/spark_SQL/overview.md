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
      - [2.读取文件 -> dataframe](#2读取文件---dataframe)
      - [3.使用dataframe](#3使用dataframe)
      - [4.使用DSL语法分析dataframe](#4使用dsl语法分析dataframe)
      - [5.使用SQL分析dataframe](#5使用sql分析dataframe)
        - [(1) 将dataframe转换为表](#1-将dataframe转换为表)
        - [(2) 使用SQL](#2-使用sql)

<!-- /code_chunk_output -->


### 概述

#### 1.DataFrame
是一个**表结构**（二维），用于处理结构化数据
* StructType对象 描述 整个表的结构
* StructField对象 描述 一个列的信息

***

### 使用

#### 1.创建dataframe

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

#### 2.读取文件 -> dataframe

```python
#将spark.read.<format>和createDataFrame这两个函数结合了
#需要看option有哪些参数时，可以进入这个方法去看：spark.read.<format>

df = spark.read.format(<format>).\
    schema(schema=schema).\
    option(<key>, <value>).\
    load(<path>)
```

|文件类型|说明|
|-|-|
|text|一行就是一列，不能进行分割|
|json|一条json数据必须在一行，只能解析一层|
|csv|可能通过分割符（默认为逗号）分割|

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
