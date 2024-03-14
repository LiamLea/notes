# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.AI分类](#1ai分类)
        - [(1) ANI (artificial narrow intelligence)](#1-ani-artificial-narrow-intelligence)
        - [(2) AGI (artificial general intelligence)](#2-agi-artificial-general-intelligence)
      - [2.vectorization](#2vectorization)
        - [(1) 理解ndnarray和矩阵](#1-理解ndnarray和矩阵)
        - [(2) 数据结构](#2-数据结构)

<!-- /code_chunk_output -->


### 概述

#### 1.AI分类

##### (1) ANI (artificial narrow intelligence)

smart speaker, self-driving car, web search, etc

##### (2) AGI (artificial general intelligence)
do anything a human can do

#### 2.vectorization
使用矩阵描述数据，利用GPU计算，能够大大提升计算速度

##### (1) 理解ndnarray和矩阵
* 二维ndarray 理解为 理解为数组的元素 是矩阵的一行，且元素是一个数组
  * ndarry的`axis=n`，表示第n个嵌套数组
    * 比如: 
      * `np.sum(n. axis=0)`，就是将 最外层数组的元素相加
      * `np.sum(n. axis=1)`，就是将 第一个嵌套数组（最外层数组的元素）的元素相加

* 多维ndarray 理解为 数组的嵌套

##### (2) 数据结构

* input:
    * 垂直方向：特征
    * 水平方向：样本数
    * input.shape = (n,m)
* model
    * 水平方向：参数（数量为n）
    * 垂直方向：不同neuron的参数
    * model.shape = (j,n)
* $output = model \cdot input$
    * 水平方向：输出结果
    * 垂直方向：不同neuron的输出结果
    * output.shape = (j,m)
