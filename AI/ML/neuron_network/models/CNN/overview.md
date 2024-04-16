# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.基础](#1基础)
        - [(1) padding](#1-padding)
        - [(2) cross-correlation vs convolution](#2-cross-correlation-vs-convolution)

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