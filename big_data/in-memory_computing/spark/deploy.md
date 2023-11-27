# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [简单部署](#简单部署)
      - [1.spark on yarn](#1spark-on-yarn)
        - [(1) 两种模式](#1-两种模式)
        - [(2) 配置环境变量](#2-配置环境变量)
        - [(3) 运行程序](#3-运行程序)
    - [部署pyspark](#部署pyspark)
      - [1.安装pyspark](#1安装pyspark)
        - [(1) 在所有yarn节点上安装](#1-在所有yarn节点上安装)
        - [(2) 需要用到的python库，都需要在yarn节点中上安装](#2-需要用到的python库都需要在yarn节点中上安装)
        - [(3) 上传依赖到yarn（否则后面会很慢）](#3-上传依赖到yarn否则后面会很慢)
      - [2.运行](#2运行)
        - [(1) 本地模式](#1-本地模式)
        - [(2) yarn client模式](#2-yarn-client模式)
        - [(3) yarn cluster模式](#3-yarn-cluster模式)
        - [(4) 配置](#4-配置)

<!-- /code_chunk_output -->


### 简单部署

#### 1.spark on yarn

##### (1) 两种模式
* cluster模式 （推荐）
    * driver运行在YARN的ApplicationMaster中
    * 通讯效率高
* client模式
    * driver运行在客户端进程内，ApplicationMaster会和driver通信
    * 方便查看日志

##### (2) 配置环境变量
* HADOOP_CONF_DIR
  * 用于获取hdfs地址
* YARN_CONF_DIR
  * 用于获取yarn resource manager地址

```shell
$ cp conf/spark-env.sh.template conf/spark-env.sh
$ vim conf/spark-env.sh

HADOOP_CONF_DIR=/home/hdfs/hadoop-3.3.6/etc/hadoop
YARN_CONF_DIR=/home/hdfs/hadoop-3.3.6/etc/hadoop
```

##### (3) 运行程序

* java程序
```shell
./bin/spark-submit --class org.apache.spark.examples.SparkPi \
  --master yarn \
  --deploy-mode cluster \
  examples/jars/spark-examples*.jar 
```

* python
```shell
./bin/spark-submit  --master yarn   --deploy-mode cluster   examples/src/main/python/pi.py 100
```

***

### 部署pyspark

* 前提: 部署好hadoop和yarn集群

#### 1.安装pyspark

##### (1) 在所有yarn节点上安装
* 根据使用的spark版本确定pyspark版本
```shell
conda create -n pyspark pyspark=<version>
```

* 这样做的目的是:
  * 保证python版本、库都**一致**，如果不一致的话，写的代码可能在有些节点上无法运行

##### (2) 需要用到的python库，都需要在yarn节点中上安装
* 都需要在pyspark这个虚拟环境中安装
* 下面也要指定使用这个虚拟环境执行代码

##### (3) 上传依赖到yarn（否则后面会很慢）

* 找到依赖文件
```shell
ls /home/liamlea/miniconda3/envs/pyspark/lib/python3.11/site-packages/pyspark/jars
```

* 打包依赖文件
```shell
zip -j /tmp/yarn-archive.zip /home/liamlea/miniconda3/envs/pyspark/lib/python3.11/site-packages/pyspark/jars/*.jar
```

* 将yarn-archive.zip上传到hdfs的`/user/hdfs`目录下
```shell
$HADOOP_HOME/bin/hadoop fs -put /tmp/yarn-archive.zip /user/hdfs/
```

#### 2.运行

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
    spark.yarn.archive="hdfs://hadoop-01:9000/user/hdfs/yarn-archive.zip"
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