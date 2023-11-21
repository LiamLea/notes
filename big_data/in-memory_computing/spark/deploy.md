# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [deploy](#deploy-1)
      - [1.spark on yarn](#1spark-on-yarn)
        - [(1) 两种模式](#1-两种模式)
        - [(2) 配置环境变量](#2-配置环境变量)
        - [(3) 运行程序](#3-运行程序)

<!-- /code_chunk_output -->


### deploy

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