# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.transaction（事务）](#1transaction事务)
      - [2.ACID](#2acid)
        - [（1）Atomicity（原子性）](#1atomicity原子性)
        - [（2）Consistency（一致性）](#2consistency一致性)
        - [（3）Isolation（隔离性）](#3isolation隔离性)
        - [（4）Durability（持久性）](#4durability持久性)

<!-- /code_chunk_output -->

### 概述

#### 1.transaction（事务）
一个工作单元，即执行**一组SQL语句**，这个操作是**原子**的

#### 2.ACID

#####  （1）Atomicity（原子性）

##### （2）Consistency（一致性）
* 数据需要满足一定的规则
比如从A账号转200到B账号
当A账号减掉200的同时，B账号必须同时增加200（因为需要满足A+B的值不变的规则）
当A账号不足200时，该操作必须失败（因为需要满足>=0的规则）
</br>
* 实现一致性的方式：
  * 通过AID保证C，即AID是手段，C是目的

##### （3）Isolation（隔离性）
事务的结果通常对其他事务不可见，直到该事务完成为止。

##### （4）Durability（持久性）
事务的更改是永久的，即使在事务完成的瞬间，服务器宕机了，数据也不会丢失