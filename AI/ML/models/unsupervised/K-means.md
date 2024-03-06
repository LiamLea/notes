# K-means


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [K-means](#k-means)
    - [概述](#概述)
      - [1.算法](#1算法)
        - [(1) cost function (distortion function)](#1-cost-function-distortion-function)
        - [(2) random initilization](#2-random-initilization)

<!-- /code_chunk_output -->


### 概述

#### 1.算法

* **随机**选择K个cluster centroid（即分为K类）$\mu_1,\mu_2,...,\mu_K$
* 重复：
    * for i = 1 to m
        * $c^{(i)} = min_k\Vert x^{(i)}-\mu_K\Vert $
            * 第i个训练数据的cluster centroid index（即第i个训练数据属于哪个centroid index：$\mu_{c^{(i)}}$）
                * 找到与之距离最短的cluster centroid
    * for k = 1 to K
        * 根据划分到每一类的训练数据，重新计算 $\mu_k$
        * 特殊情况：如果某一类中0个样本数据，则减少分类数（比如K-1）或者 重新设置初始化cluster centroid

##### (1) cost function (distortion function)

* $J(c^{(1)},...,c^{(m)},\mu_1,...,\mu_K) = \frac{1}{m}\sum_{i=1}^m \Vert x^{(i)}-\mu_{c^{(i)}}\Vert$
    * 上述算法的每一步，都是为了让该代价函数最小

##### (2) random initilization
* why
    * 最初随机选择的cluster centroid会影响最后的分类结果

* how
    * 多次（50-1000）进行K-means，选择代价函数最小的
        * 每次随机选择的cluster centroid不一样，（从训练数据选出K个 作为cluster centroid）

* 如何分类的数量，有以下几种方法
    * 根据实际情况和后续如何使用，确定需要划分几类
    * 画出J和K的关系图，K越来越大，开始时，J下降的很多，当经过某一个K值时，J下降很慢，就选择该K（即划分多少类）