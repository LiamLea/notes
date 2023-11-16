# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [deploy](#deploy-1)
      - [1.准备](#1准备)
        - [(1) 确定版本](#1-确定版本)

<!-- /code_chunk_output -->


### deploy

#### 1.准备

##### (1) 确定版本

根据hadoop的版本选择对于的Hive版本

```shell
useradd -m -s /bin/bash hive
```
```shell
su - hdfs

export HADOOP_HOME=<hadoop-install-dir>

$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir -p    /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse
```

```shell
$ vim hadoop-3.3.6/etc/hadoop/core-site.xml

<property>
    <name>hadoop.proxyuser.hdfs.hosts</name>
    <value>*</value>
</property>
<property>
    <name>hadoop.proxyuser.hdfs.groups</name>
    <value>*</value>
</property>

$ $HADOOP_HOME/sbin/stop-dfs.sh
$ $HADOOP_HOME/sbin/start-dfs.sh
```
```shell
export HIVE_HOME=<hive-install-dir>

$HIVE_HOME/bin/schematool -dbType derby -initSchema

$HIVE_HOME/bin/hive

$HIVE_HOME/bin/hiveserver2
$HIVE_HOME/bin/beeline -u jdbc:hive2://localhost:10000
```