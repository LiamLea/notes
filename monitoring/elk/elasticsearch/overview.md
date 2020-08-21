[toc]
### 基础概念
#### 1.特点
* 分布式
* 数据以 **json格式** 保存
* 索引方式：inverted index（倒排索引），索引文本查询速度很快
  * 正常索引：以文档ID作为索引，以文档内容作为记录
  * inverted index：以文档内容作为索引，以文档id作为记录

#### 1.类比数据库
```mermaid
graph LR
A("indices(库)")-->B("types(表)")
B-->C("documents(一行记录)")
C-->D("fields(字段)")
```

#### 2.核心概念
```shell
index         #documents的集合
type          #类似表
document      #fields的集合（一条json记录）
field         #key-value键值对

settings      #用来定义该index的相关配置（比如：备份数等）
mappings      #用来定义该index中各字段的属性（比如有一个字段，名为name，可以在mapping中定义这个字段，类型为string等）
```

#### 4.shards（数据分片）
##### （1）primary shards（主分片）
* es会将数据进行分片，从而减轻单台服务器上的数据量
  * 但当有一个节点宕机，部分数据会丢失

![](./imgs/overview_01.png)
##### （2）replica shards（副本分片）
* 为了实现高可用，需要冗余分片（即给每一个分片设置多少副本）
  * 1个副本

![](./imgs/overview_02.png)

  * 2个副本

![](./imgs/overview_03.png)

#### 3.角色
ES集群给每个节点分配不同角色，每种角色干的活都不一样

**（1）master**
主要负责维护集群状态，负载较轻
由于一个master会存在单点故障，所以一般会设置多个master
然后从中选举出一个**active master**，其他则是**backup master**
实际只有active master在工作，backuo master只是有资格参与竞选active master

**（2）data node**
主要负责集群中数据的存储和检索

**（3）coordinating node**
分发：请求到达协调节点后，协调节点将查询请求分发到每个分片上。
聚合: 协调节点搜集到每个分片上查询结果，在将查询的结果进行排序，之后给用户返回结果。

**（4）ingest node**
对索引的文档做预处理

#### 4.命名格式
（1）meta-filed
元字段用下划线开头

#### 5.ES中的时区是UTC（无法修改）

#### 6.集群状态及解决
##### （1）集群状态为red
red表示**不是**所有的**主分片**都可用，通常时由于某个索引的主分片为分片unassigned，只要找出这个索引的分片，手工分配即可

##### （2）集群状态为yellow
yellow表示所有**主分片**可用，但**不是**所有**副本分片**都可用，最常见的情景是单节点时，由于es默认是有1个副本，主分片和副本不能在同一个节点上，所以副本就是未分配unassigned

##### （3）解决思路：
* 先找出有问题的indices和nodes
```shell
curl IP:PORT/_cluster/health?level=indices
curl IP:POTT/_cat/health    #一个个试
```
* 然后查看该节点上哪一个分片是unassigned
```shell
curl IP:PORT/_cat/shards
```
