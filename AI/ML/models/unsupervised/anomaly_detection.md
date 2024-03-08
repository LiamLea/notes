# anomaly detection


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [anomaly detection](#anomaly-detection)
    - [概述](#概述)
      - [1.density estimation](#1density-estimation)
      - [2.anomaly detection算法](#2anomaly-detection算法)
        - [(1) 使用正态分布](#1-使用正态分布)
        - [(2) evalution](#2-evalution)
      - [3.如何选择feature](#3如何选择feature)
        - [(1) 转换non-normal distribution features](#1-转换non-normal-distribution-features)
        - [(2) error analysis](#2-error-analysis)
      - [4.anomaly detection vs supervised learning](#4anomaly-detection-vs-supervised-learning)

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

##### (2) evalution

* 使用训练数据 训练模型
* 用少量的**打标**的数据（即cross validation set）去评估模型
    * 其中包含少量的**anomaly数据**（异常数据很少）
    * 选择合适的metric 对模型进行评估，从而调整$\epsilon$参数
        * 使用precison/recall和F1 score进行评估，[参考](../../../optimization.md)
        * 从而 从训练样本中的 最低的概率 到 最高的概率中，寻找最佳的 **$\epsilon$值**
* 如果有足够的anomaly数据，还可以划分test set，对模型进行评估

#### 3.如何选择feature

##### (1) 转换non-normal distribution features
将非高斯分布的特征，转换成高斯分布
* 调整下面方法的参数，找到合适的变换，使得features能够很好的满足高斯分布
* $log(x+C)$
    * C是常数
* 或 $x^{0.5}、x^{0.4}$等

##### (2) error analysis
当训练好的模型在cross validation set上的性能不好时，就需要进行错误分析
* 分析anomaly数据为什么没有检测出来
    * 比如现有特征不足以检测出该数据，则可以添加新特征
    * 可以将特征进行组合，建立特征间的关系，从而找出异常

#### 4.anomaly detection vs supervised learning

当只有少量的positive样本（而negative样本有很多）时，该如何进行选择

* anomaly detection
    * 当现有的positive样本不能覆盖大部分anomaly的情况，则此算法更加合适，能够识别 未出现过的异常情况
* supervised learning
    * 训练数据越全面越好，现有的positive样本能覆盖大部分情况，后续出现的positive情况，与现有的类似，则此算法更加合适
