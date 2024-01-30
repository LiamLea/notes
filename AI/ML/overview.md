# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.术语](#1术语)
        - [(1) training set](#1-training-set)
        - [(2) x -f-> $\hat{y}$](#2-x--f--haty)
        - [(3) cost function](#3-cost-function)
      - [2.两类算法](#2两类算法)
        - [(1) supervised learning](#1-supervised-learning)
        - [(2) unsupervised learning](#2-unsupervised-learning)
    - [supervised learning](#supervised-learning)
      - [1.linear regression](#1linear-regression)

<!-- /code_chunk_output -->


### 概述

#### 1.术语

##### (1) training set
用于训练模型的数据集
* x
    * input变量，也叫input feature
* y
    * output变量，也叫output target
* m
    * 训练集的数目
* $(x^{(i)},y^{(i)})$
    * 第i个训练数据

##### (2) x -f-> $\hat{y}$
* x
    * input feature
* $f_{w,b}(x) = wx + b$
    * f 称为模型
    * w,b称为该模型的参数
* $\hat{y}$
    * 预测值

##### (3) cost function
* 训练出的模型与真实值的偏差
* 目标：使用cost function的值**最小**，即预测值与真实值偏差最小
* 比如：squared error cost function
    * $J(w,b) = \frac{1}{2m}\sum_{i=1}^m (f_{w,b}(x^{(i)})-y^{(i)})^2$

#### 2.两类算法

##### (1) supervised learning
* regression
* classification

##### (2) unsupervised learning
训练数据，没有标注输出（即正确答案），算法需要在输入的数据中，自行去做分析
* clusering
* anomaly detection
* dimensionality reduction

***

### supervised learning

#### 1.linear regression

* 模型: $f_{w,b}(x) = wx + b$
* 目标: 寻找w,b，使用cost function值最小