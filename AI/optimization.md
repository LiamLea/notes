# optimization


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [optimization](#optimization)
    - [概述](#概述)
      - [1.evaluate a model](#1evaluate-a-model)
        - [(1) 划分数据集](#1-划分数据集)
        - [(2) 计算dev set的代价函数](#2-计算dev-set的代价函数)
        - [(3) 报告泛化误差](#3-报告泛化误差)

<!-- /code_chunk_output -->


### 概述

#### 1.evaluate a model

##### (1) 划分数据集
* training set (60%)
    * 用于训练模型
* cross validation set (validation set、development set、dev set) (20%)
    * 用于evaluate the different model configurations you are choosing from（比如:模型使用哪种多项式，x^2还是x^3等）
* test set (20%)
    * 用于估计泛化误差，评价模型的性能

##### (2) 计算dev set的代价函数
* $J_{cv}(\vec w,b)$
* 当有多个模型配置时，选择$J_{cv}(\vec w,b)$最小的模型配置

##### (3) 报告泛化误差
* $J_{test}(\vec w,b)$