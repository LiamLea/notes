# sort 


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [sort](#sort)
    - [概述](#概述)
      - [1.quick sort (快排序)](#1quick-sort-快排序)
        - [(1) pivot (轴点)](#1-pivot-轴点)
        - [(2) partition算法 (分区算法)](#2-partition算法-分区算法)
        - [(3) 性能分析](#3-性能分析)
        - [(4) quick select (解决selection问题)](#4-quick-select-解决selection问题)
      - [2.linear select (对quick select的优化)](#2linear-select-对quick-select的优化)
        - [(1) 算法](#1-算法)
        - [(2) 性能分析](#2-性能分析)
      - [3.shell排序框架 (希尔排序框架)](#3shell排序框架-希尔排序框架)
        - [(1) diminishing increment (递减增量)](#1-diminishing-increment-递减增量)
        - [(2) step sequence (步长序列)](#2-step-sequence-步长序列)
        - [(3) 算法](#3-算法)

<!-- /code_chunk_output -->

### 概述

#### 1.quick sort (快排序)

快排序: 选取pivot，然后迭代使用partition算法

* 不稳定: 相同的元素，位置可能会颠倒

##### (1) pivot (轴点)
* 左侧元素 <= pivot
* 右侧元素 >= pivot

##### (2) partition算法 (分区算法)
* 选择第一个节点为预备pivot
* 从前和从后遍历，逐渐将预备pivot移动到正确的位置

##### (3) 性能分析
* pivot的选取，会影响排序的性能
    * 最坏情况 (选取pivot，不能使用序列划分均衡): O(n^2)
    * 最好情况 (选取pivot，能使用序列划分均衡): O(nlogn)

##### (4) quick select (解决selection问题)

* selection问题
    * 找出排序后的第k个元素
* 使用partition算法

#### 2.linear select (对quick select的优化)

##### (1) 算法

* 选取一个常数Q
* 将序列分为 n/Q 个子序列
* 对每个子序列进行排序
* 找出每个子序列的中位数m，找出这些中位数中的中位数M
* 遍历所有元素，分别放入三个子序列中
    * L中的元素 < M
    * E中的元素 = M
    * G中的元素 > M
* 如果第k个元素在L或G中，则针对L或G进行上述递归

##### (2) 性能分析

当Q=5时，时间复杂度最好: O(n)，但是常系数比较大
* 所以这种算法更具理论意义

#### 3.shell排序框架 (希尔排序框架)

![](./imgs/sort_01.png)

##### (1) diminishing increment (递减增量)
矩阵宽度越来越小，最后变为宽度为1，即就是一列

##### (2) step sequence (步长序列)
S = {W1=1,W2,W3, ... ,Wk, ...}
每一次矩阵的宽度在上述序列中，按逆序选择
所需步长序列的选择，决定了排序的性能

##### (3) 算法

* 将一个序列，转换成一个宽度为Wk的矩阵
    * 注意转换并不是真实转换，而是逻辑上这样处理:
        * 第一列: T[0], T[Wk], ...
        * 第二列: T[1], T[1+Wk], ...
* 对每一列进行插入排序
* 然后再转换成一个宽度为Wk-1的矩阵
* 对每一列进行插入排序
* 迭代，最后转成为1列，然后进行插入排序

