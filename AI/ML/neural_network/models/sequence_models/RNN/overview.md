# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [overview](#overview-1)
      - [1.notation](#1notation)
      - [2.RNN (recurrent neural network)](#2rnn-recurrent-neural-network)

<!-- /code_chunk_output -->


### overview

#### 1.notation

* $x^{<t>}$: 输入序列的第t个item
* $y^{<t>}$: 输出序列的第t个item
* $T_x$: 输入序列的长度
* $T_y$: 输出序列的长度

* representing words
    * 构建一个vocabulary (比如有10,000个words)
    * 可以使用one-hot表示序列
        * 比如一个序列有9个words，则可以用9个长度为10,000的vector表示，
        * 如果第一个word是we，则vector在we的索引处值为1，其他都为0

#### 2.RNN (recurrent neural network)

![](./imgs/rnn_01.png)


* model
    * $a^{<0>}$一般设为0
    * $a^{<t>} = g(W_{a}[a^{<t-1>},x^{<t>}] +b_a)$
    * $\hat y^{<t>} = g(W_{y}a^{<t>}+b_y)$
        * 是下面两个公式的简化写法（将参数堆叠成一个更大的矩阵）
            * $a^{<t>} = g(W_{aa}a^{<t-1>} + W_{ax}x^{<t>}+b_a)$
            * $\hat y^{<t>} = g(W_{ya}a^{<t>}+b_y)$
        * 注意：两个g函数不一样

* 特点
    * 只考虑了之前输入的信息，未考虑之后输出的信息