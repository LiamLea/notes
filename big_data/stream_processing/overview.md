# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.stream processing](#1stream-processing)
        - [(1) why](#1-why)
        - [(2) 适用场景](#2-适用场景)
        - [(3) 目标](#3-目标)

<!-- /code_chunk_output -->

### 概述

#### 1.stream processing

##### (1) why
批处理面临的问题
* 数据量太大，无法一次性处理
* 数据到来太快，来不及处理
* 达到所需要性能的成本太高

##### (2) 适用场景

* $F(X + \Delta X)=F(X) op H(\Delta X)$
    * 即无需一次性处理，每次可以对增量数据进行处理后，通过相关运算，能够得到一次性处理的结果

##### (3) 目标
* 实时性/可扩展性
* 容错
    * 数据的错误
    * 系统的故障
* 可编程性
