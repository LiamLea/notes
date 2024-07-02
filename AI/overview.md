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
    - [相关概念](#相关概念)
      - [1.MLP (Multilayer Perceptron)](#1mlp-multilayer-perceptron)
      - [2.SVM (support vector machine)](#2svm-support-vector-machine)
        - [(1) 基本概念](#1-基本概念)
        - [(2) 目标: find the optimum hyperplane](#2-目标-find-the-optimum-hyperplane)
        - [(3) non-linear classification: kernel trick](#3-non-linear-classification-kernel-trick)
        - [(2) kernel](#2-kernel)
        - [(3) redial kernel (RBF: redial basis function)](#3-redial-kernel-rbf-redial-basis-function)
      - [3.restricted Boltzman machine (RBM)](#3restricted-boltzman-machine-rbm)
      - [4.autoencoders](#4autoencoders)
      - [5.deep belief network (DBN)](#5deep-belief-network-dbn)

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

***

### 相关概念

#### 1.MLP (Multilayer Perceptron)
A specific type of neural network with multiple fully connected layers and non-linear activation functions, primarily used for classification and regression tasks

#### 2.SVM (support vector machine)
given a set of labeld training data, SVM will find optimal hyperplane which categorized new examples (only handle two categories)

##### (1) 基本概念
* hyperplane
  * in 1d space: hyperplane is dot
  * in 2d space: hyperplane is line
  * in 3d space: hyperplane is surface

* support vector
  * the points that are closest to the hyperplane

* margin
  * the distance between the hyperplane and support vector

##### (2) 目标: find the optimum hyperplane
* maximum margin
  * only support vectors determine hyperplance

* hyperplane: $\vec W \cdot\vec X + b=0$
  * $\vec W$ 是参数
  * $\vec X$ 是hyperplane上的点

##### (3) non-linear classification: kernel trick
##### (2) kernel
* $(a\times b+r)^d$
  * a,b: two different observations in the dataset
  * r: the coefficient of the polynomial
  * d: the degree of the polynomial

* 比如: r=1, d=2
  * $(a\times b+1)^2=2ab+a^2b^2+1=(\sqrt 2a,a^2,1)\cdot (\sqrt 2b,b^2,1)$
  * 则将数据点从1d映射到2d
    * a: $(\sqrt 2a,a^2)$
    * b: $(\sqrt 2b.b^2)$

##### (3) redial kernel (RBF: redial basis function)
* $e^{-\gamma(a-b)^2} $
  * 根据taylor series: $e^{ab}=(a,\sqrt{\frac{1}{2!}}a^2,\sqrt{\frac{1}{3!}}a^3,...,\sqrt{\frac{1}{\infty!}}a^{\infty})\cdot (b,\sqrt{\frac{1}{2!}}b^2,\sqrt{\frac{1}{3!}}b^3,...,\sqrt{\frac{1}{\infty!}}b^{\infty})$

#### 3.restricted Boltzman machine (RBM)
* restriction: no connections within a layer

#### 4.autoencoders

#### 5.deep belief network (DBN)