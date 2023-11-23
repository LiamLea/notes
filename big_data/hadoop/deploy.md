# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [概述](#概述)
      - [1.服务说明](#1服务说明)
        - [(1) HDFS](#1-hdfs)
        - [(2) YARN](#2-yarn)
    - [部署](#部署)
      - [1.准备](#1准备)
      - [2.创建帐号并拷贝密钥](#2创建帐号并拷贝密钥)
      - [3.修改配置文件](#3修改配置文件)
        - [(1) 设置环境变量](#1-设置环境变量)
        - [(2) 设置工作节点](#2-设置工作节点)
        - [(3) 核心配置](#3-核心配置)
        - [(4) hdfs配置](#4-hdfs配置)
        - [(5) yarn配置](#5-yarn配置)
        - [(6) MapReduce配置](#6-mapreduce配置)
      - [4.拷贝hadoop目录到其他worker节点](#4拷贝hadoop目录到其他worker节点)
      - [5.启动服务](#5启动服务)
      - [6.验证](#6验证)
        - [(1) 验证hdfs](#1-验证hdfs)
        - [(2) 验证yarn](#2-验证yarn)

<!-- /code_chunk_output -->

### 概述

#### 1.服务说明

##### (1) HDFS

|daemon|port|http port|说明|
|-|-|-|-|
|NameNode|9000|9870|存储元信息，用于索引blocks|
|SecondaryNameNode||9868、9869 (https)|存储checkpoint信息|
|DataNode|9866、9867 (IPC)|9864|存储blocks|

##### (2) YARN

|daemon|port|http port|说明|
|-|-|-|-|
|ResourceManger|8032、8030 (scheduler)、8031 (resource-tracker)、8033 (admin)|8088、8090 (https)|管理资源，进行调度（替代了原先的JobTracker）|
|NodeManger||8042、8044 (https)|管理节点|
|WebAppProxy||||

***

### 部署

#### 1.准备

* 安装openjdk，并设置JAVA_HOME环境变量

#### 2.创建帐号并拷贝密钥
```shell
#所有机器创建该账号
useradd -m -s /bin/bash hdfs
```

#### 3.修改配置文件

##### (1) 设置环境变量

```shell
$ vim etc/hadoop/hadoop-env.sh

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
export HADOOP_HOME=/home/hdfs/hadoop-3.3.6
```

##### (2) 设置工作节点

* 设置域名解析

```shell
$ vim /etc/hosts

10.172.1.71 hadoop-01
10.172.1.200 hadoop-02
10.172.1.115 hadoop-03
```

* 指定worker节点

```shell
$ vim etc/hadoop/workers
#不要出现localhost，因为所有的配置都需要同步到其他机器
hadoop-01
hadoop-02
hadoop-03
```

* 要设置该节点到所有worker的ssh免密登陆
```shell
#实现所有机器的免密登陆（包括本机）
ssh-keygen
ssh-copy-id hdfs@hadoop-02
ssh-copy-id hdfs@hadoop-03
```

##### (3) 核心配置

|配置项|默认值|说明|
|-|-|-|
|fs.defaultFS|NameNode的URI，其他的worker节点都需要连接到这个地址|
|io.file.buffer.size|131072|缓冲区大小|
|hadoop.tmp.dir|`/tmp/hadoop-${user.name}`|变量，数据存储的目录默认会使用这个变量|

```shell
$ vim etc/hadoop/core-site.xml
```
```xml
<!--配置NameNode的URI，其他的worker节点都需要连接到这个地址-->
<configuration>

    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop-01:9000</value>
    </property>

    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/hdfs/data</value>
    </property>

</configuration>
```

##### (4) hdfs配置

|配置项|默认值|说明|
|-|-|-|
|dfs.namenode.name.dir|`file://${hadoop.tmp.dir}/dfs/name`|namenode存储元数据的目录|
|dfs.datanode.data.dir|`file://${hadoop.tmp.dir}/dfs/data`|datanode存储blocks的目录|
|dfs.hosts / dfs.hosts.exclude||允许或剔除哪些数据节点|
|dfs.blocksize|268435456|块大小|
|dfs.namenode.handler.count|100|handler进程数，用于处理来自DataNode的rpc|

* 客户端配置
    * 即作为客户端 连接hdfs时使用的配置，不是服务端配置，所以每个客户端都需要自己自行做一些配置

##### (5) yarn配置

|配置项|默认值|说明|
|-|-|-|
|yarn.resourcemanager.hostname|0.0.0.0|变量，用于设置后面的连接地址，所以这里一定要修改|
|yarn.scheduler.minimum-allocation-mb||container的最小内存值|
|yarn.scheduler.maximum-allocation-mb||container的最大内存值|
|yarn.nodemanager.resource.memory-mb|-1|该节点可分配的内存值，当为-1且yarn.nodemanager.resource.detect-hardware-capabilities时true，则设为计算出来的内存，否则设为8192M|
|yarn.nodemanager.resource.system-reserved-memory-mb|-1|预留的内存，当为-1且yarn.nodemanager.resource.detect-hardware-capabilities时true，则设为 20% * (system memory - 2*HADOOP_HEAPSIZE) |
|yarn.nodemanager.resource.detect-hardware-capabilities|false|是否检测节点的硬件|
|yarn.nodemanager.aux-services||当使用MapReduce时，这里需要设置为: mapreduce_shuffle|
|yarn.nodemanager.env-whitelist|JAVA_HOME,...|containers可以覆盖的环境变量

```shell
vim etc/hadoop/yarn-site.xml
```
```xml
<configuration>

<!-- Site specific YARN configuration properties -->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>hadoop-01</value>
    </property>

    <property>
        <name>yarn.nodemanager.resource.detect-hardware-capabilities</name>
        <value>true</value>
    </property>

    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>

    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>

</configuration>
```

##### (6) MapReduce配置

|配置项|默认值|说明|
|-|-|-|
|mapreduce.framework.name|local|执行MapReduce jobs的框架，默认是本地执行，可设值: local、classic、yarn|
|mapreduce.application.classpath|`$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*, $HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*`|MapReduce应用的classpath|

```shell
vim etc/hadoop/mapred-site.xml
```

```xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```

#### 4.拷贝hadoop目录到其他worker节点

* 注意存放的位置要一致，因为设置了HADOOP_HOME，不然找不到目录

```shell
scp -r /home/hdfs/hadoop-3.3.6 hdfs@hadoop-02:/home/hdfs/
scp -r /home/hdfs/hadoop-3.3.6 hdfs@hadoop-03:/home/hdfs/

#后续配置变化只需要拷贝配置文件
scp -r /home/hdfs/hadoop-3.3.6/etc hdfs@hadoop-02:/home/hdfs/hadoop-3.3.6/
scp -r /home/hdfs/hadoop-3.3.6/etc hdfs@hadoop-03:/home/hdfs/hadoop-3.3.6/
```

#### 5.启动服务

以下命令都在主节点上执行，会自动运行其他节点上的程序

* 启动hdfs

```shell
bin/hdfs namenode -format
sbin/start-dfs.sh
```

* 启动yarn

```shell
sbin/start-yarn.sh
```

* 开启自启
```shell
$ vim /etc/rc.local

#!/bin/bash

su - hdfs /home/hdfs/hadoop-3.3.6/sbin/start-dfs.sh
su - hdfs /home/hdfs/hadoop-3.3.6/sbin/start-yarn.sh

$ chmod +x /etc/rc.local
```

#### 6.验证

##### (1) 验证hdfs

* 登陆dashboard查看节点是否都正常启动
    * `<ip>:9870`

* 运行demo mapreduce
```shell
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/hdfs
bin/hdfs dfs -mkdir input
bin/hdfs dfs -put etc/hadoop/*.xml input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep input output 'dfs[a-z.]+'
bin/hdfs dfs -get output output
cat output/*
```

##### (2) 验证yarn

* 登陆dashboard查看节点是否正常启动
    * `<ip>:8088`
* 确保MapReduce中的框架配置的是yarn，然后执行MapReduce应用即可
```shell
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep input output 'dfs[a-z.]+'
```