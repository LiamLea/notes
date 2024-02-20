# neural network


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [neural network](#neural-network)
    - [概述](#概述)
      - [1.术语](#1术语)
        - [(1) layer](#1-layer)
        - [(2) activation](#2-activation)

<!-- /code_chunk_output -->


### 概述

#### 1.术语

在线代中，大写代笔矩阵，小写代表向量

##### (1) layer
* input layer
* hidden layer
* output layer

* 表示: 
    * `[0]` 表示第0层，即input layer
    * `[1]` 表示layer 1，以此类推
    * $w_1^{[1]}$ 表示layer 1中的参数

##### (2) activation

* 一个unit（即neuron）输出就是一个activation
    * 接收输入，经过 **activation function** 产生输出（即 **activation value**）
* $a_j^{[l]} = g(\vec w_j^{[l]} \cdot \vec a^{[l-1]} + b_j^{[l]})$
    * `[l]`表示 layer l
    * j表示 该层的unit j（即第j个neuron）
    * g表示使用的sigmoid function作为activation function
* layer l 所有activation表示：$\vec a^{[l]}$
    * input layer的activation（即输入向量）: $\vec a^{[0]}$
