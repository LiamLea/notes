# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.安装pyspark（yarn的所有节点都需要）](#1安装pysparkyarn的所有节点都需要)
        - [(1) 本地模式](#1-本地模式)
        - [(2) yarn client模式](#2-yarn-client模式)
        - [(3) yarn cluster模式](#3-yarn-cluster模式)
        - [(4) 配置](#4-配置)

<!-- /code_chunk_output -->


### 概述

#### 1.安装pyspark（yarn的所有节点都需要）

* 根据使用的spark版本确定pyspark版本
```shell
conda create -n pyspark pyspark=<version>
```

* 这样做的目的是:
  * 保证python版本、库都**一致**，如果不一致的话，写的代码可能在有些节点上无法运行

##### (1) 本地模式
```python
from pyspark import SparkConf,SparkContext

import  os

# 代码中的环境变量
#   指定使用什么用户去连接hdfs（指定最高权限用户，比如我的环境是hdfs，或者创建新用户）
os.environ['HADOOP_USER_NAME'] = "hdfs"

if __name__ == '__main__':
    conf  = SparkConf().setAppName("WordCount")
    conf.set("spark.hadoop.dfs.client.use.datanode.hostname", "true")
    sc = SparkContext(conf=conf)
```

##### (2) yarn client模式

```python
from pyspark import SparkConf,SparkContext

import  os
import sys

# 部署端环境变量
#  hadoop的配置文件目录
os.environ['HADOOP_CONF_DIR'] = "/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"
#  hadoop的配置文件目录
os.environ['YARN_CONF_DIR'] = "/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"

# 配置driver
#   driver和executors使用的python解释器
os.environ['PYSPARK_PYTHON'] = "/home/hdfs/miniconda3/envs/pyspark/bin/python"
#   driver和executors的python版本要一致
os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable
#   当使用client模式时，指定driver的ip，如果使用默认的，可能executor无法连接到driver
os.environ['SPARK_LOCAL_IP'] = "172.16.0.179"

# 代码中的环境变量
#   指定使用什么用户去连接hdfs（指定最高权限用户，比如我的环境是hdfs，或者创建新用户）
os.environ['HADOOP_USER_NAME'] = "hdfs"

if __name__ == '__main__':
    # 配置driver
    conf  = SparkConf().setAppName("WordCount").setMaster("yarn")
    #conf.set("spark.submit.deployMode", "cluster")
    #conf.set("spark.files", "xx")
    #conf.set("spark.submit.pyFiles", "xx.py")
    conf.set("spark.hadoop.dfs.client.use.datanode.hostname", "true")
    sc = SparkContext(conf=conf)
```

##### (3) yarn cluster模式
* 比如使用pycharm，添加如下: Configurations

  * Spark home: `/home/liamlea/miniconda3/envs/pyspark`
    * 设置为pyspark虚拟环境路径，因为需要使用spark-submit

  * Application: `file:///home/liamlea/Workspace/codes/practices/python/spark_test` 
    * 设置要执行的代码的路径

  * Cluster manager: yarn
  * deploy Mode: cluster
  * Run with python env: /home/hdfs/miniconda3/envs/pyspark/bin/python
    * 安装了pyspark的python环境

  * 使driver运行为cluster模式，有些配置需要前提配置: spark configuration
    * 其他配置可通过`SparkConf().set`在代码中配置
    ```shell
    #空格隔开
    #spark.submit.pyFiles=
    spark.pyspark.python="/home/hdfs/miniconda3/envs/pyspark/bin/python"
    ```
  * 设置部署机的环境变量: shell options -> env: 
    ```shell
    HADOOP_CONF_DIR="/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"
    YARN_CONF_DIR="/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"
    ```

```python
from pyspark import SparkConf,SparkContext

import  os
# 代码中的环境变量
#   指定使用什么用户去连接hdfs（指定最高权限用户，比如我的环境是hdfs，或者创建新用户）
os.environ['HADOOP_USER_NAME'] = "hdfs"

if __name__ == '__main__':

    conf  = SparkConf().setAppName("WordCount")
    sc = SparkContext(conf=conf)
```

##### (4) 配置
[参考](https://spark.apache.org/docs/latest/configuration.html)