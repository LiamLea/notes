# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.基础](#1基础)
        - [(1) padding](#1-padding)
        - [(2) cross-correlation vs convolution](#2-cross-correlation-vs-convolution)
        - [(3) 有多个channel](#3-有多个channel)
      - [2.CNN符号表示](#2cnn符号表示)

<!-- /code_chunk_output -->


### 概述

#### 1.基础

* 已知
    * 图片: $n\times n$
    * kernel: $f\times f$
    * padding的数量: p (即在每个边缘加p个元素)
    * stride: s
* 则最终的output: $(\frac{n+2p-f}{s} + 1) \times (\frac{n+2p-f}{s} + 1)$

##### (1) padding

* valid convolutions
    * 不进行填充，对图片进行卷积后，图片会变小
* same convolutions
    * 对图片边缘进行填充，卷积后，图片大小保持不变

##### (2) cross-correlation vs convolution
* 在数学上，kernel需要先逆时针旋转180度，然后进行移动，将窗口内的元素 相乘并相加
* 这里不需要（即cross-correlation）

##### (3) 有多个channel
* kernel也需要有相同数量的channel
![](./imgs/ov_01.png)

#### 2.CNN符号表示
* 基础符号
    * $f^{[l]}$: 第l层kernel(filter) size
    * $p^{[l]}$: 第l层padding size
    * $s^{[l]}$: 第l层stride
    * $n_c^{[l]}$: 第l层filters的数量
        * 对于最开始的输入，这个就是图片channel的数量（比如RGB）
* $a^{[l-1]}$: $n_H^{[l-1]} \times n_W^{[l-1]} \times n_c^{[l-1]}$
* each filter: $f^{[l]} \times f^{[l]} \times n_c^{[l]}$
* parameters
    * weights: $f^{[l]} \times f^{[l]} \times n_c^{[l-1]} \times n_c^{[l]}$
    * bias: $1 \times 1 \times 1\times n_c^{[l]}$
* $a^{[l]}$: $n_H^{[l]} \times n_W^{[l]} \times n_c^{[l]}$