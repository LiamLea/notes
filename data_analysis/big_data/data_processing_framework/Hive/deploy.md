# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [deploy](#deploy-1)
      - [1.准备](#1准备)
        - [(1) 确定版本](#1-确定版本)
      - [2.设置用户](#2设置用户)
      - [3.集成mysql](#3集成mysql)
      - [3.更多配置](#3更多配置)
      - [4.启动服务](#4启动服务)
        - [(1) 启动metastore服务](#1-启动metastore服务)
        - [(2) 测试](#2-测试)
      - [5.客户端](#5客户端)
        - [(1) hive](#1-hive)
        - [(2) hiveserver2（常用）](#2-hiveserver2常用)

<!-- /code_chunk_output -->


### deploy

* 使用hdfs用户操作
```shell
su - hdfs
```

#### 1.准备

##### (1) 确定版本

根据hadoop的版本选择对于的Hive版本

#### 2.设置用户

[参考](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/Superusers.html)

```shell
$ vim hadoop-3.3.6/etc/hadoop/core-site.xml

#允许superuser代理 来自 指定主机 的 指定组 用户
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

#### 3.集成mysql
mysql用于存储metastore数据

* 在mysql中创建数据库
```shell
create database hive charset utf8mb4_general_ci;
```

* 下载mysql驱动
    * 根据mysql版本，下载
    * 将驱动移动到lib目录下
    ```shell
    cp /usr/share/java/mysql-connector-java-8.0.24.jar apache-hive-3.1.3-bin/lib/
    ```

* 配置`hive-site.xml`
```xml
<configuration>
	<property>
		<name>javax.jdo.option.ConnectionURL</name>
		<value>jdbc:mysql://10.172.1.10:58176/hive?createDatabaseIfNotExist=true&amp;useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8</value>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionDriverName</name>
		<value>com.mysql.jdbc.Driver</value>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionUserName</name>
		<value>root</value>
	</property>
	<property>
		<name>javax.jdo.option.ConnectionPassword</name>
		<value>cangoal</value>
	</property>
</configuration>
```

* 格式化数据库
```shell
$HIVE_HOME/bin/schematool -dbType mysql -initSchema -verbose
```

#### 3.更多配置
[参考](https://cwiki.apache.org/confluence/display/hive/configuration+properties)

#### 4.启动服务

##### (1) 启动metastore服务
```shell
mkdir $HIVE_HOME/logs
nohup $HIVE_HOME/bin/hive --service metastore &> $HIVE_HOME/logs/metastore.log &
```

##### (2) 测试

```shell
$HIVE_HOME/bin/hive

> show databases;
> create table test(id int, name string, gender string);
> insert into test values(1, 'liyi', '男'), (2, 'lier', '男'), (3,'lisan', '女');
> select * from test;
> select gender, COUNT(*) as cnt from test group by gender;
```

* 数据默认存储在hdfs://user/hive/warehouse/

* 查看metastore
```shell
mysql> use hive;
mysql> select * from DBS; 

#能看出数据在hdfs中存储的位置
```

#### 5.客户端

##### (1) hive

##### (2) hiveserver2（常用）
* hiveserver2使用Thrift协议（port: 10000）提供服务
```shell
nohup $HIVE_HOME/bin/hiveserver2 &> $HIVE_HOME/logs/hiveserver2.log &
```
* beeline、DataGrip、DBeaver作为客户端连接hiveserver2
```shell
$ $HIVE_HOME/bin/beeline
beeline> !connect jdbc:hive2://<hive_host>:10000

0: jdbc:hive2://<hive_host>:10000> show databases;
```