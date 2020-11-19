# kafka
[toc]

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

#### 2.函数
```python
from kafka import KafkaProducer

#创建kafka的生产者（即会连接kafka）
producer = KafkaProducer(bootstrap_servers = '<IP>:<PORT>')

#此时如果kafka连接断开，执行下面的内容不会报错
producer.send('<TOPIC>',b'<MSG>')    #发送的内容必须是二进制的
producer.flush()
```
