# usage


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [usage](#usage)
    - [hdfs使用](#hdfs使用)
      - [1.目录操作](#1目录操作)
      - [2.文件操作](#2文件操作)
    - [yarn使用](#yarn使用)
      - [1.应用相关](#1应用相关)

<!-- /code_chunk_output -->

### hdfs使用

#### 1.目录操作

* 创建目录
```shell
$HADOOP_HOME/bin/hdfs dfs -mkdir <dir>
```

* 删除目录
```shell
$HADOOP_HOME/bin/hdfs dfs -rm -R <dir>
```

#### 2.文件操作

* 文件授权

```shell
#也就是 +200，即owner能够写
$HADOOP_HOME/bin/hadoop fs -chmod u+w   /tmp
#也就是 +020，即group能够写
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
#也就是 +002，即others能够写
$HADOOP_HOME/bin/hadoop fs -chmod o+w   /tmp
```

***

### yarn使用

#### 1.应用相关

* 列出应用
```shell
$HADOOP_HOME/bin/yarn application -list
```