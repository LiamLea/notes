# kafka

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kafka](#kafka)
    - [概述](#概述)
      - [1.KafkaProducer是线程安全的，KafkaConsumer不是线程安全的](#1kafkaproducer是线程安全的kafkaconsumer不是线程安全的)
      - [2.多个进程 之间不能 共享KafkaProducer](#2多个进程-之间不能-共享kafkaproducer)
    - [使用](#使用)
      - [1.安装kafka模块](#1安装kafka模块)
      - [2.设置生产者](#2设置生产者)
      - [3.设置消费者](#3设置消费者)
      - [4.创建AdminClient](#4创建adminclient)
        - [（1）管理consumer group](#1管理consumer-group)

<!-- /code_chunk_output -->

### 概述

#### 1.KafkaProducer是线程安全的，KafkaConsumer不是线程安全的

#### 2.多个进程 之间不能 共享KafkaProducer

***

### 使用
#### 1.安装kafka模块
```shell
#kafka模块有点问题，需要安装kafka-python
pip install kafka-python
```

#### 2.设置生产者
```python
from kafka import KafkaProducer

#创建kafka的生产者（即会连接kafka）
producer = KafkaProducer(bootstrap_servers = <STRING or LIST>)

#此时如果kafka连接断开，执行下面的内容不会报错
producer.send("<TOPIC>", b"<MSG>")    #发送的内容必须是二进制的
producer.flush()
```

* 直接指定发送的分区
```python
producer.send("<TOPIC>", b"<MSG>", partition = <NUM>)
```

* 根据key哈希到指定分区
```python
#定义key的哈希规则
```

#### 3.设置消费者
```python
from kafka import KafkaConsumer
from kafka.errors import CommitFailedError

consumer = KafkaConsumer(*topics, **configs)

# *topics，可以传入多个topic
# **configs:
#   bootstrap_servers = "<STRING or LIST>"
#   group_id = "<GID>"
#   client_id = "<CID>"
#   auto_offset_reset = "earliest"    //latest
#   enable_auto_commit = True

#会监听在指定topic上，有一条数据就会循环一次
for msg in consumer:
  print(msg)

  #要保证上面的操作是幂等的，才能这样处理
  try:
    consumer.commit()
  except CommitFailedError:
    pass
```

#### 4.创建AdminClient
```python
from kafka import KafkaAdminClient
from kafka.admin import NewTopic

#连接kafka
client = KafkaAdminClient(**configs)

#创建topic
my_topic = NewTopic(
  name = "<TOPIC>",
  num_partitions = <NUM>,
  replication_factor = <NUM>,
  #topic的配置，如果没有，用broker中默认的
  topic_configs = {}
)

client.create_topics([my_topic])
```

##### （1）管理consumer group

* 查看所有的consumer group

```python
result = client.list_consumer_groups()

print(json.dumps(result, indent = 2))
```
```shell
kafka-consumer-groups.sh --bootstrap-server <IP:PORT> --list
```

* 查看某个consumer group的详细信息
```python
result = client.describe_consumer_groups(["<CONSUMER_GROUP>"]))
result = client.list_consumer_group_offsets("<CONSUMER_GROUP>")
```

```shell
kafka-consumer-groups.sh --bootstrap-server <IP:PORT>  --describe --group <CONSUMER_GROUP> --state
kafka-consumer-groups.sh --bootstrap-server <IP:PORT>  --describe --group <CONSUMER_GROUP> --members
kafka-consumer-groups.sh --bootstrap-server <IP:PORT>  --describe --group <CONSUMER_GROUP> --offsets
```

* 删除某个consumer group（当该group中有client正在消费时，无法删除）
```python
#返回删除结果
result = client.delete_consumer_groups(["dev-kangpaas-monitormgnt-server-kangpaas-topic_batchformat_process"])
```
```shell
kafka-consumer-groups.sh --bootstrap-server <IP:PORT>  --delete --group <CONSUMER_GROUP>
```
