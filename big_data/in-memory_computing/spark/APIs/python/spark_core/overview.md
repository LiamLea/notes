# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [基本使用](#基本使用)
      - [1.配置](#1配置)
      - [2.创建RDD](#2创建rdd)
        - [(1) 指定分区数](#1-指定分区数)
        - [(2) 使用序列](#2-使用序列)
        - [(2) 从文件读取数据](#2-从文件读取数据)
      - [3.Operator (算子)](#3operator-算子)
        - [(1) transformation operators](#1-transformation-operators)
        - [(2) action operators](#2-action-operators)

<!-- /code_chunk_output -->


### 基本使用

```python
from pyspark import SparkConf,SparkContext

#创建SparkContext对象
conf  = SparkConf().setAppName("WordCount")
sc = SparkContext(conf=conf)

#创建RDD，指定分区数为3
rdd = sc.parallelize([1,2,3,4,5,6,7,8,8,10], 3)

#收集该RDD的所有分区，转化为本地集合
result = rdd.collect()
```

#### 1.配置

[参考](https://spark.apache.org/docs/latest/configuration.html)

比如对hdfs客户端进行配置，使用hostname连接hdfs
```python
conf  = SparkConf().setAppName("WordCount")
conf.set("spark.hadoop.dfs.client.use.datanode.hostname", "true")
```

#### 2.创建RDD

##### (1) 指定分区数
如果指定的分区数过大，spark也不会采用

* 数据是怎么进行分区的
```python
print(rdd.glom().collect())
```

##### (2) 使用序列
```shell
rdd = sc.parallelize([1,2,3,4,5,6,7,8,8,10], 3)
```

##### (2) 从文件读取数据

* textFile
    * item: 文件的一行内容 就是 列表的一个item
    * 分区：将列表划分为一定数量的子集
```python
rdd = sc.textFile("hdfs://hadoop-01:9000/user/hdfs/input")
```

* wholeTextFile
    * item: 二元组，元组的第一部分是文件的路径，元组的第二部分是文件的内容
    * 分区：将列表划分为一定数量的子集

#### 3.Operator (算子)
* 算子: 分布式集合对象的API

##### (1) transformation operators

* 特点
    * old RDD -> new RDD
    * Lazy Evaluation
        * 只有调用了Action算子，才会对之前的 转换算子进行调用

* `map(func: Callable[[T], U])`
    * 遍历item，执行`func(item)`（返回任意类型）

    ```python
    def add(input):
        return (input,1)
        #return input+10

    rdd = sc.parallelize([0,1,2,3,4,5,6,7,8,9,10])
    rdd1 = rdd.map(add)
    ```

* `flatMap(func: Callable[[T], Iterable[U]])`
    * 遍历item，执行`func(item)`（返回可迭代类型），再对结果进行flat
        * 如果内嵌的是列表，则flat所有列表元素，如果内嵌的是dict，flat的是key，value会被丢弃
    ```python
    def add(input):
        return [input, input + 1]
    rdd = sc.parallelize([0,1,2,3,4,5,6,7,8,9,10])
    rdd1 = rdd.flatMap(add)
    #rdd1: [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11]
    ```

* `reduceByKey(func: Callable[[V, V], V])`
    * 针对 二元组 （即能够`for k,v in item`）
    * 根据key进行分组，每组中迭代执行`func(group[0], group[1])`，直至该group中只有一个item
    ```python
    def add(x, y):
        return x + y
    rdd = sc.parallelize([("a",1),("b",1),("a",2),("a",1),("c",5)])
    rdd1 = rdd.reduceByKey(add)
    #rdd1: [('b', 1), ('a', 4), ('c', 5)]
    ```

* `groupByKey()`
    * 针对 二元组 （即能够`for k,v in item`）
    * 根据key进行分组，可以通过keyfunc**先对key进行处理**

* `groupBy(func: Callable[[T], K])`
    * 遍历item，func(item)的返回值作为key，然后将这个item放入这个key对应的序列中
    ```python
    def div(x):
        return x % 2
    rdd = sc.parallelize([1, 1, 2, 3, 5, 8])
    rdd1 = rdd.groupBy(div)
    rdd2 = rdd1.map(lambda t: (t[0], list(t[1])))
    #rdd1: [(0, <pyspark.resultiterable.ResultIterable object at 0x7f42a812b590>), (1, <pyspark.resultiterable.ResultIterable object at 0x7f42a812b610>)]
    #rdd2: [(0, [2, 8]), (1, [1, 1, 3, 5])]
    ```

* `mapValues(func: Callable[[V], U])`
    * 针对 二元组 （即能够`for k,v in item`）
    * 遍历二元组，执行`func(item[1])`的操作
    ```python
    def add(input):
        return input+10
    rdd = sc.parallelize([("a",1),("b",1),("a",2),("a",1),("c",5)])
    rdd1 = rdd.mapValues(add)
    #rdd1: [('a', 11), ('b', 11), ('a', 12), ('a', 11), ('c', 15)]
    ```

* `filter(func: Callable[[T], bool])`
    * 遍历item，保留func(item)为true的

* `distinct()`
    * 去重

* `union(<rdd>)`
    * 合并两个rdd，不去重
* `intersection(<rdd>)`
    * 求交集

* `join(<rdd>)`
    * <rdd>的item必须是 二元组
    * 内连接
    * 全外连接: `fullOuterJoin(<rdd>)`
    * 左外连接: `leftOuterJoin(<rdd>)`
    * 右外连接: `rightOuterJoin(<rdd>)`
    ```python
    rdd1 = sc.parallelize([("1", "liyi"), ("2","lier"), ("3", "lisan")])
    rdd2 = sc.parallelize([("1", "20"), ("2", "21"), ("4", "19")])

    rdd3 = rdd1.join(rdd2)
    rdd4 = rdd1.fullOuterJoin(rdd2)
    rdd5 = rdd1.leftOuterJoin(rdd2)

    #rdd3: [('2', ('lier', '21')), ('1', ('liyi', '20'))]
    #rdd4: [('2', ('lier', '21')), ('3', ('lisan', None)), ('4', (None, '19')), ('1', ('liyi', '20'))]
    #rdd5: [('2', ('lier', '21')), ('3', ('lisan', None)), ('1', ('liyi', '20'))]
    ```

* `sortBy(func: Callable[[T], S], ascending=True)`
    * 只能保证**一个分区**内的数据是有序的
    * 遍历item，根据func(item)的返回值进行排序

* `sortByKey(ascending=True)`
    * 只能保证**一个分区**内的数据是有序的
    * 针对 二元组 （即能够`for k,v in item`）
    * 按照key进行排序，可以通过keyfunc**先对key进行处理**

##### (2) action operators

* 特点
    * RDD -> 非RDD