# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [基础概念](#基础概念)
      - [1.特点](#1特点)
      - [2.核心概念](#2核心概念)
      - [3.角色](#3角色)
      - [4.命名格式](#4命名格式)
      - [5.ES中的时区是UTC（无法修改）](#5es中的时区是utc无法修改)
    - [文本分析（使用的是analyzer）](#文本分析使用的是analyzer)
      - [1.文件分析步骤](#1文件分析步骤)
        - [（1）tokenization（词语切分）](#1tokenization词语切分)
        - [（2）normalization（标准化）](#2normalization标准化)
      - [2.analyzer组成](#2analyzer组成)
        - [（1）character filters](#1character-filters)
        - [（2）tokenizer](#2tokenizer)
        - [（3）token filters](#3token-filters)
      - [3.文件分析的时机](#3文件分析的时机)
        - [（1）index时](#1index时)
        - [（2）search时](#2search时)
      - [4.测试index使用的analyzer](#4测试index使用的analyzer)
      - [5.对keyword类型的数据不会进行文本分析](#5对keyword类型的数据不会进行文本分析)
    - [Aggregations（聚合）](#aggregations聚合)
      - [1.有4类聚合](#1有4类聚合)
        - [（1）bucketing](#1bucketing)
        - [（2）metric](#2metric)
        - [（3）matrix（试验阶段）](#3matrix试验阶段)
        - [（4）pipeline](#4pipeline)

<!-- /code_chunk_output -->

### 基础概念

#### 1.特点
* 分布式
* 数据以 **json格式** 保存
* 索引方式：inverted index（倒排索引），索引文本查询速度很快
  * 正常索引：以文档ID作为索引，以文档内容作为记录
  * inverted index：以文档内容作为索引，以文档id作为记录

#### 2.核心概念
```shell
index         #documents的集合
type          #已经弃用type（因为type会影响性能）
              #类似表，7.0版本
              #一个index中，不会有多个type
document      #fields的集合（一条json记录）
field         #key-value键值对

settings      #用来定义该index的相关配置（比如：备份数等）
mappings      #用来定义该index中各字段的属性（比如有一个字段，名为name，可以在mapping中定义这个字段，类型为string等）
```

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
* meta-filed: `_xx`
  * 元字段用下划线开头

#### 5.ES中的时区是UTC（无法修改）

***

### 文本分析（使用的是analyzer）

[参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis.html)

* 默认的analyzer: [standard analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html)

#### 1.文件分析步骤

##### （1）tokenization（词语切分）
词语切分，将一个text，切分成多个chunk（一个单词或者词组），一个chunk叫做token
* 并且记录chunk间的顺序

##### （2）normalization（标准化）
将token转换成标准格式，比如:
* Quick -> quick
* foxes -> fox
* jump或者leap -> jump

这样能够实现同义匹配，而不是精准匹配

#### 2.analyzer组成

##### （1）character filters
用于对文件内容进行转换，比如：添加、删除或者改变字符

##### （2）tokenizer
进行tokenization（词语切分）

##### （3）token filters
进行normalization（标准化）

#### 3.文件分析的时机

##### （1）index时
当doc被index时，text类型的字段会进行 文件分析

##### （2）search时
进行full-text搜索时，会对 搜索文本（比如：query_string） 进行 文本分析 后，再进行搜索
* 所以 search时使用的analyzer 应该和 index时使用的analyzer 一样

#### 4.测试index使用的analyzer
```shell
#必须用完整的index名称，不能使用模糊匹配，因为会匹配多个index
POST /.ds-logs-syslog.host.app-test-2022.12.16-000001/_analyze
{
  "field": "my_text",
  "text": "The old brown cow"
}
```

#### 5.对keyword类型的数据不会进行文本分析

***

### Aggregations（聚合）
#### 1.有4类聚合
##### （1）bucketing
用于生成buckets的聚合方式
每个bucket都有 一个**key**（key用于标识该bucket） 和 一个**document条件**
当执行聚合时，会对每个document进行条件评估
如果，document符合某个backet的条件，则该document属于该bucket
最后，会返回多个backets

##### （2）metric
计算一组document的数值指标

##### （3）matrix（试验阶段）

##### （4）pipeline
