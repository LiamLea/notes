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
      - [3.parameters vs hyperparameters](#3parameters-vs-hyperparameters)
      - [4.对数据的预处理](#4对数据的预处理)

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
      * 每一行 是不同样本的同一特征
      * 每一列 是一个样本的所有特征
* model
    * 水平方向：参数（数量为上一层**特征的数量**）
    * 垂直方向：不同neuron的参数
    * model.shape = $(n^{[l]},n^{[l-1]})$
* $output = model \cdot input$（**下一层的input** ）
    * 水平方向：输出结果
    * 垂直方向：不同neuron的输出结果
    * output.shape = $(n^{[l]},m)$
      * 每一行 是同一neuron针对不同样本的输出
      * 每一列 是同一样本在不同neuron上的输出
  
* 相关导数的结构 都跟 数据的原始结构一样

#### 3.parameters vs hyperparameters

* parameters: W、b
* hyperparameters: 
    * learning rate alpha
    * number of iterations of gradient descent
    * number of hidden layers
    * number of hidden units
    * so on

#### 4.对数据的预处理

* 搞清楚数据集的shape及其含义
* 对数据集进行reshape
* 进行standardize