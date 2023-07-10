
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [基础概念](#基础概念)
  - [1.索引](#1索引)

<!-- /code_chunk_output -->

### 基础概念

#### 1.索引

* 主索引
  * 主索引的叶子结点存储的是整行数据
* 辅助索引
  * 辅助索引的叶子结点存储的是主键值
* 回表
  * 当通过辅助索引找到主键后，需要再利用主索引找到具体的行
