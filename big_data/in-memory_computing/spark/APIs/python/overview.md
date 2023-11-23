# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.安装pyspark（yarn的所有节点都需要）](#1安装pysparkyarn的所有节点都需要)
        - [(1) 基本使用](#1-基本使用)
        - [(2) 配置](#2-配置)

<!-- /code_chunk_output -->


### 概述

#### 1.安装pyspark（yarn的所有节点都需要）

* 根据使用的spark版本确定pyspark版本
```shell
conda create -n pyspark pyspark=<version>
```

* 这样做的目的是:
  * 保证python版本、库都**一致**，如果不一致的话，写的代码可能在有些节点上无法运行

##### (1) 基本使用

* PYSPARK_PYTHON
  * driver和executors使用的python解释器
  * 所以一定要指定，否则不知道使用我们创建的虚拟环境
* PYSPARK_DRIVER_PYTHON
  * 当使用client模式时指定（否则用默认的）
  * driver和executors的python版本要一致

* 当需要在yarn上运行spark时，需要指定：
  * HADOOP_CONF_DIR
    * hadoop的配置文件目录
  * YARN_CONF_DIR
    * yarn的配置文件目录

* HADOOP_USER_NAME
  * 指定使用什么用户去连接hdfs（指定最高权限用户，比如我的环境是hdfs，或者创建新用户）


* 当使用client模式时，指定driver的ip
  * SPARK_LOCAL_IP
  * 如果使用默认的，可能executor无法连接到driver
  * 使用pycharm将spark运行在yarn上时，只能使用client模式

```python
from pyspark import SparkConf,SparkContext

import  os
import sys

os.environ['PYSPARK_PYTHON'] = "/home/hdfs/miniconda3/envs/pyspark/bin/python"
# os.environ['PYSPARK_DRIVER_PYTHON'] = sys.executable
os.environ['HADOOP_CONF_DIR'] = "/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"
os.environ['YARN_CONF_DIR'] = "/home/liamlea/Workspace/big-data/hadoop-3.3.6/etc/hadoop"
os.environ['HADOOP_USER_NAME'] = "hdfs"
os.environ['SPARK_LOCAL_IP'] = "172.16.0.179"

if __name__ == '__main__':
    conf  = SparkConf().setAppName("WordCount").setMaster("yarn")
    # conf.set("spark.submit.deployMode", "cluster")
    # conf.set("spark.submit.pyFiles", "xx.py")
    conf.set("spark.hadoop.dfs.client.use.datanode.hostname", "true")
    sc = SparkContext(conf=conf)
```

##### (2) 配置
[参考](https://spark.apache.org/docs/latest/configuration.html)