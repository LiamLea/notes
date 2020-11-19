# kafka

[toc]

### 概述

#### 1.三个关键功能
* 发布和订阅
* 持久化（可以指定存储数据多久）
* 可以从指定offset开始处理事件

#### 2.主要概念

##### （1）broker（代理）
一个kafka server就是一个broker

##### （2）event（message、record）
* message的组成：
  * 消息头
  * key（用于hash到指定分区）
  * 消息内容

##### （3）topic
类似文件夹，用于组织和存储event
当event被消费，topic不会删除event
可以设置保存event多长时间
* topic是被分区的（默认只有一个分区：Partition 0）
  * 根据event的key（key是由生产者指定的），将event哈希到指定分区
  * 同时消费多个分区，不能保证多个分区之间的顺序，只能保证一个分区内的数据是按顺序消费的

#### 3.使用的安全协议
|协议名|说明|
|-|-|
|PLAINTEXT|不认证，不加密|
|SASL_PLAINTEXT|SASL认证，不加密|
|SASL_SSL|SASL认证，SSL加密|
|SSL|不认证，SSL加密|

#### 4.partition log

![](./imgs/kafka_01.png)


##### （1）partition log目录
`<TOPIC>-<PARTITION>`
* 比如：`topic_os_config-0/`

##### （2）log segemnt
* `<OFFSET>.index`
* `<OFFSET>.log`
* `<OFFSET>.timestamp`
  * 比如：`00000000000000000202.log`，表示第一条消息从202 offset开始

##### （3）log条目的内容
前4N个字节存放该 消息的字节长度，后面紧跟消息的内容

##### （4）日志操作
* 写入
该日志允许串行追加，该追加始终会转到最后一个文件。 当该文件达到可配置的大小（例如1GB）时，它将被滚动到一个新文件。 日志有两个配置参数：M（在强制操作系统将文件刷新到磁盘之前，提供了要写入的消息数）和S（在强制刷新后的秒数内）。 这样可以持久保证在系统崩溃时最多丢失M条消息或S秒的数据。
</br>
* 删除：
日志管理器应用两个指标来标识可删除的段：时间和大小
</br>
* 日志压缩：
可以有选择的删除日志（根据key，保留每个key最新的数据）

#### 5.producer
* 控制将数据发往 指定topic 的 指定分区
  * 常用方法是利用指定key hash到指定分区，从而能够分类存放

* 异步发送（提高效率）
  * 先将数据缓存在内存中，一次发送多条数据，可以设置当达到一定条件发送（比如64k或10ms）

#### 6.consumer
* 当消费者获取消息后，并且回复了，broker才会增加offset


##### （1）group_id
* offset是与group关联的
* 在同一个group中的消费者只会消费一次数据
* 当有多个消费者监听同一个队列，同一个group中的消费者，只有一个消费者消费数据，当这个消费者挂了，同group中的另一个消费者会顶上继续消费

##### （2）client_id
* 在同一个group中，client_id不能一样

***

### 集群

消费者的消费记录（offset）存储在某一个broker上的，这个broker成为协调broker
消费者连接另一个broker，会先获取协议broker信息，然后都会协调broker上提交和获取offset

***

### 配置

#### 1.broker配置

* 基本配置

```shell
#当前kafka server的id，在同一个集群中，id必须唯一
broker.id=<NUM>
```

* 监听器设置

```shell
#监听器名称 和 安全协议 之间的映射关系（相当于创建监听器）
#为什么需要这个：如果同一个安全协议，应用到不同ip，需要有不同的策略
#比如：通用设置 ssl.keystore.location，如果给指定监听器设置 listener.name.<NAME>.ssl.keystore.location
listener.security.protocol.map=<NAME>:<PROTOCOL>,<NAME>:<PROTOCOL>

#监听器列表，用于 指定监听的地址列表 或者 设置监听器的地址列表
listeners=<PROTOCOL or LISTENER_NAME>://<IP>:<PORT>

#发布到zookeeper中的监听器信息列表
#与本地设置的监听器不同：
#   本地监听器可以设置0.0.0.0:9092，但是发布到zookeeper的监听器地址必须是一个可以访问的地址
#   因为客户端会通过zookeeper获取到kafka的访问地址，从而实现高可用，即使某一台kafka挂了，还可以访问其他地址
advertised.listeners=<PROTOCOL or LISTENER_NAME>://<IP>:<PORT>
```

* topic相关配置
```shell
#允许自动创建topic，比如生产者需要往某个topic推数据，不需要先创建好topic
auto.create.topics.enable=true

auto.leader.rebalance.enable

#允许删除topic，否则无法删除任何topic
delete.topic.enable==true
```

* zookeeper相关配置
```shell
#指定zookeeper地址，为了高可用可以指定多个，用逗号隔开
#还可以指定，将数据放在zookeeper指定目录下
#zookeeper.connect=192.168.1.1:2181/my/kafka
zookeeper.connect=<host:port>,<host:port>
```

* 日志相关
日志删除的基本单位是：log segment
```shell
#日志存储目录
log.dirs=<DIR>

#每个日志分片（即日志文件）的大小
#如果一条消息大于该值，则该消息不会存放kafka中
log.segment.bytes=<NUM>

#指定日志清理策略
#   delete策略，根据时间或者大小删除日志
#   compact策略，根据key，每个key只保留最新的数据
log.cleanup.policy=<delete or compact>

#多长时间检查一次是否满足删除条件
log.retention.check.interval.ms=<NUM>

#该大小必须设为大于日志分片的大小，否则不生效
log.retention.bytes=<NUM>

#当设置了更小的单位时，只会按照较单位执行
#根据时间删除，不依赖检查时间（log.retention.check.interval.ms）
log.retention.hours=<NUM>
log.retention.minutes=<NUM>
log.retention.ms=<NUM>

#最多多长时间将log写入磁盘
#默认写文件并不是直接写入到磁盘，而是先存放在缓冲区（了解：linux的fsync命令）
log.flush.interval.ms=<NUM>

#log.cleaner是关于日志压缩策略的配置
```





* 其他配置
```shell
#设置（名称:协议）的映射，一个名称就是一个listener
#这里定义了两个listener，一个是EXTERNAL，一个是INTERNAL
listener.security.protocol.map = EXTERNAL:PLAINTEXT,INTERNAL:PLAINTEXT

#设置listener监听的地址（listener已经在上面定义）
listeners = EXTERNAL://:9092,INTERNAL://:9093

#对外宣称的listener地址（listener已经在上面定义）
advertised.listeners = EXTERNAL://3.1.5.15:30909,INTERNAL:3.1.5.15:30910

#用于设置broker之间进行通信时采用的listener名称
inter.broker.listener.name = INTERNAL
```
