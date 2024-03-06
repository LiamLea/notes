# anomaly detection


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [anomaly detection](#anomaly-detection)
    - [概述](#概述)
      - [1.density estimation](#1density-estimation)
      - [2.anomaly detection算法](#2anomaly-detection算法)
        - [(1) 使用正态分布](#1-使用正态分布)
      - [3.evalution](#3evalution)

<!-- /code_chunk_output -->


### 概述

#### 1.density estimation

* $p(\vec x) = \prod_{j=1}^n p(x_j;\mu_j,\sigma_j^2)$
    * $x_j$
        * 当前待预测数据的第j个特征值
    * $\mu_j = \frac{1}{m}\sum_{i=1}^mx_j^{(i)}$
        * 第j个特征的 样本平均值
    * $\sigma_j^2 = \frac{1}{m}\sum_{i=1}^m(x_j^{(i)} - \mu_j)^2$
        * 第j个特征的 样本方差

#### 2.anomaly detection算法

##### (1) 使用正态分布

* $p(\vec x) = \prod_{j=1}^n p(x_j;\mu_j,\sigma_j^2) = \prod_{j=1}^n \frac{1}{\sqrt {2\pi}\sigma_j}\exp(-\frac{(x_j-u_j)^2}{2\sigma_j^2})$
    * $x_j$
        * 当前待预测数据的第j个特征值
    * $\mu_j = \frac{1}{m}\sum_{i=1}^mx_j^{(i)}$
        * 第j个特征的 样本平均值
    * $\sigma_j^2 = \frac{1}{m}\sum_{i=1}^m(x_j^{(i)} - \mu_j)^2$
        * 第j个特征的 样本方差

* if $p(\vec x) < \epsilon$
    * 则异常

#### 3.evalution

* 使用训练数据 训练模型
* 用少量的**打标**的数据（即cross validation set）去评估模型
    * 其中包含少量的**anomaly数据**（异常数据很少）
    * 选择合适的metric 对模型进行评估，从而调整$\epsilon$参数
        * 使用precison/recall进行评估，[参考](../../../optimization.md)
* 如果有足够的anomaly数据，还可以划分test set，对模型进行评估