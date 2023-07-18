# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.数据并行化 (Data-Level Parallelism)](#1数据并行化-data-level-parallelism)
        - [(1) 适用场景](#1-适用场景)

<!-- /code_chunk_output -->

### 概述

#### 1.数据并行化 (Data-Level Parallelism)

基于divide-and-conquer策略

##### (1) 适用场景

* 数据并行并不适合所有类型的数据，当数据满足以下条件是才适合使用数据并行方式:
    * 数据能够切分且是独立的
    * 操作必须是确定性的和幂等的