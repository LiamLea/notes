# transformers


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [transformers](#transformers)
    - [overview](#overview)
      - [1.transformers特点](#1transformers特点)
        - [(1) 传统模型](#1-传统模型)
        - [(2) transformers](#2-transformers)
      - [2.transform representations](#2transform-representations)
      - [3.self-attention](#3self-attention)
        - [(1) 与RNN attention比较](#1-与rnn-attention比较)
        - [(2) self-attention](#2-self-attention)
      - [4.multi-head attention](#4multi-head-attention)
      - [5.transformer network](#5transformer-network)
        - [(1) postional encoding](#1-postional-encoding)
        - [(2) masked multi-head attention](#2-masked-multi-head-attention)

<!-- /code_chunk_output -->

### overview

#### 1.transformers特点

##### (1) 传统模型
* RNN
    * 存在vanishing graidents问题
* GRU/LSTM
    * 模型变得更加复杂
    * sequential，需要按顺序处理一个个token，导致性能比较低

##### (2) transformers
* **并行**计算每个token的 attention-based representations

#### 2.transform representations

* transformers的目的: 调整word的representations，使得其不仅仅encode单个单词，还要包含**context信息** (**attention-based representations**)
    * `没有context信息的embedding` `-->` `有（context信息 + position信息）的embedding`

![](./imgs/tm_03.png)
![](./imgs/tm_04.png)

#### 3.self-attention

##### (1) 与RNN attention比较
[参考](../RNN/NLP.md#7attetion-model)

* $\text {context}^{<t>}=\sum\limits_{t'}\frac {\exp(e^{<t,t'>})}{\sum_{t'=1}^{T_x}exp(e^{<t,t'>})}a^{<t'>}$
* $A(q^{<t>},K,V)=\sum\limits_i\frac{\exp(q^{<t>}\cdot k^{<i>})}{\sum_j\exp(q^{<t>}\cdot k^{<j>})}v^{<i>}$

* 目的不一样
    * RNN计算context，作为每个decoder unit的输入
    * transformer计算attention-based representations
* 本质是一样，计算当前token对其他token的attention

##### (2) self-attention

![](./imgs/tm_01.png)

* 第t个token的attention-based representations
    * $A^{<t>} = A(q^{<t>},K,V)=\sum\limits_i\frac{\exp(q^{<t>}\cdot k^{<i>})}{\sum_j\exp(q^{<t>}\cdot k^{<j>})}v^{<i>}$
        * $q^{<t>}$: 第t个token的query值，即需要transform的
        * $k^{<j>}$: 第j个token的key值
        * q和k: 用于计算 每个token 对于 当前token的 context贡献的权重
        * $v^{<i>}$: 第i个token的value值
        * 权重和v: 用于计算context，即attention-based representations
* 实际使用如下公式: 
    * $\text {Attention}(Q,K,V) = \text {softmax}(\frac{QK^T}{\sqrt {d_k}})V$
        * $\sqrt {d_k}$是防止graident exploding

#### 4.multi-head attention

![](./imgs/tm_02.png)

* $\text {MultiHead}(Q,K,V) = \text {concat}(\text {head}_1,\text {head}_2,...,\text {head}_n)W_o$
    * $\text {head}_i=\text {Attention}(W_i^QQ,W_i^KK,W_i^VV)$
        * 一个token由多个heads，一个head就是一个特征
        * $Q=K=V=X$
            * 因为这里将W参数提取出来了，而在self-attention中，q/k/v是用W参数计算出来的，本质是一样的

#### 5.transformer network

以翻译为例
* 简化的
    * ![](./imgs/tm_05.png)
        * decoder中的Q来自 已经输出内容 的attetion，即需要考虑已经输出的内容
* 实际的
    * ![](./imgs/tm_06.png)
        * Add & Norm就类似于batchnormalization

##### (1) postional encoding
* 由于transformer是并行处理的，丢失了位置信息，所以需要补充位置信息

* how
![](./imgs/tm_08.png)
    * $PE(pos,2i)=\sin (\frac{pos}{n^{2i/d}})$
    * $PE(pos,2i+1)=\cos (\frac{pos}{n^{2i/d}})$
        * d: token的维度
        * n建议取10,000
    * 比如token的维度是4，则计算出的postional vector为: ( PE(pos,0), PE(pos,1), PE(pos,2), PE(pos,3) )


* 特点
    * 唯一的
        * 只要有一个周期大于序列长度（即context长度），则一定是唯一的，因为一个周期内的值是不重复的
    * 确定的
    * 可以评估出两个vector的位置距离
        * ![](./imgs/tm_07.png)
        * 从周期大的部分能看出，两者是否接近
        * 如果两者接近，从周期小的部分能够更细致的看出两者的距离

##### (2) masked multi-head attention
* 用于训练过程中，将结果部分遮挡，进行训练（即一个训练样本，能用作多个训练样本）