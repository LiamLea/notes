# data type


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [data type](#data-type)
    - [概述](#概述)
      - [1.vector](#1vector)
        - [(1) ordered vector vs unordered vector](#1-ordered-vector-vs-unordered-vector)
      - [2.排序算法 (无序向量 -> 有序向量)](#2排序算法-无序向量---有序向量)
        - [(1) bubble sort (冒泡排序)](#1-bubble-sort-冒泡排序)

<!-- /code_chunk_output -->

### 概述

#### 1.vector

* 对array的封装，从而提供更丰富的接口
    * 扩容: 创建新的arrary，将旧的array的数据复制到新的array（array长度是固定的，不能改变）
    * 得益于封装，尽管扩容之后数据区的物理地址有所改变，却不会出现野指针

##### (1) ordered vector vs unordered vector
* ordered vector
    * 其中的元素，可以进行比较操作(`>`、`<`等)
    * 且满足有序性: 任意一对相邻元素顺序
* unordered vector
    * 其中的元素，只能进行判等的操作(`==`、`!=`)
    * 或满足无序性: 总有一对相邻元素逆序
* 对有序向量的处理，很多算法有优势
    * 所以处理前，通过排序算法将 无序向量 -> 有序向量

#### 2.排序算法 (无序向量 -> 有序向量)

##### (1) bubble sort (冒泡排序)

* 说明
    * 依次遍历，找到逆序对则交换
    * 则每一次，能够找出最大的一个元素
* 改进
    * 记录一次遍历，是否交换了逆序对
        * 如果没有，表示此序列已经有序，无需进行后续的处理