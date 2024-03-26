# gradient descent


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [gradient descent](#gradient-descent)
    - [概述](#概述)
      - [1.基本概念](#1基本概念)
        - [(1) 算法](#1-算法)
        - [(2) learning rate](#2-learning-rate)
        - [(3) 选择合适的learning rate](#3-选择合适的learning-rate)
        - [(4) learning curve (关于代价函数的变换曲线)](#4-learning-curve-关于代价函数的变换曲线)
        - [(5) 判断梯度下降是否收敛](#5-判断梯度下降是否收敛)
      - [2.feature scaling (normalize features)](#2feature-scaling-normalize-features)
        - [(1) why](#1-why)
        - [(2) 目标](#2-目标)
        - [(3) 常用方法](#3-常用方法)
        - [(4) 注意](#4-注意)
      - [3.分类](#3分类)
        - [(1) batch gradient descent](#1-batch-gradient-descent)
      - [4.Adam algorithm (adaptive moment estimation)](#4adam-algorithm-adaptive-moment-estimation)

<!-- /code_chunk_output -->


### 概述

#### 1.基本概念

##### (1) 算法
以该代价函数为例: $J(w,b) = \frac{1}{2m}\sum_{i=1}^m (f_{w,b}(x^{(i)})-y^{(i)})^2$

* w,b随便取一个值（比如w=0,b=0）

* 每次迭代
    * $temp\_w = w - \alpha\frac{\partial}{\partial w}J(w,b)$
        * $\alpha$ 
            * learning rate（在0到1之间）
        * $\frac{\partial}{\partial w}J(w,b)$
            * $\frac{\partial}{\partial w}J(w,b) = \frac{1}{m}\sum_{i=1}^m \frac{\partial}{\partial w}L(\hat y^{(i)}, y^{(i)})$
            * 表示方向，当接近局部最小值时，绝对值就会越来越小（步长就会越来越小）
            * 当为正数，表示值需要减小
            * 当为负数，表示值需要增加
        * 当w是一个向量时（即有多个w时）
            * $temp\_w_j = w_j - \alpha\frac{\partial}{\partial w_j}J(\vec w,b)$
    * $temp\_b = b - \alpha\frac{\partial}{\partial b}J(w,b)$
    * w = temp_w
    * b = temp_b

* 经过多次迭代
    * 代价函数会趋近于局部最小

##### (2) learning rate
* 范围: 0-1
* 当过小时，步长就会更短，则更慢才能找到最小代价函数
* 当过大时，代价函数可能不会收敛（convergence）

##### (3) 选择合适的learning rate
尝试多个范围的学习率（比如: ... 0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1...），进行一定量的迭代
* 观察一次迭代后，代价函数是否减小
* 如果代价函数减小，尝试增加学习率
* 如果代价函数增加，尝试减小学习率

##### (4) learning curve (关于代价函数的变换曲线)
* 比如：代价函数和迭代次数的关系，横坐标为迭代次数，纵坐标为代价函数

##### (5) 判断梯度下降是否收敛
* learning curve
    * 观察学习曲线是否收敛
* automatic convergence test
    * 如果J每一次迭代减少的数值 <= $\epsilon$，则认为梯度下降已经收敛
        * $\epsilon$的值比较难确定

#### 2.feature scaling (normalize features) 

##### (1) why
* 当特征1的范围为0-1
* 当特征2的范围为100-500
* 会导致 梯度下降较慢

##### (2) 目标
使特征的范围差不多在-1到1之间，超过这个范围也是可以的，重点是各个特征的范围相当，这样才能使用梯度下降算法更快

##### (3) 常用方法

* 除以取值范围
* mean normalization
    * $x' = \frac{x - \mu}{max(x) - min(x)}$
* Z-score normalization
    * $Z = \frac{x - \mu}{\sigma}$
        * Z: standard score
        * x: observed value
        * $\mu$: mean of the sample
        * $\sigma$: standard deviation of the sample

##### (4) 注意
训练出模型后，进行数据预测，也需要对输入的数据进行缩放

#### 3.分类

##### (1) batch gradient descent
在每次迭代时使用训练集中的所有样本进行参数更新

#### 4.Adam algorithm (adaptive moment estimation)
* 自动调整learning rate
* if $w_j$ (or b) keeps moving in same direction
    * increase $\alpha_j$
* if $w_j$ (or b) keeps oscillating
    * reduce $\alpha_j$