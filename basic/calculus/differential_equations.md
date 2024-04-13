# differential equations


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [differential equations](#differential-equations)
    - [概述](#概述)
      - [1.differential equations](#1differential-equations)

<!-- /code_chunk_output -->


### 概述

#### 1.differential equations
用于描述运动（**变化速率与当前状态有关**），求某个时刻的状态

* $\frac{d}{dt}\begin{bmatrix}x(t)\\y(t)\end{bmatrix} = \begin{bmatrix}a&b\\c&d\end{bmatrix}\begin{bmatrix}x(t)\\y(t)\end{bmatrix}$

* 因为导数跟自身有关，所以想到用e 表示x、y函数
* $\begin{bmatrix}x(t)\\y(t)\end{bmatrix} = e^{\begin{bmatrix}a&b\\c&d\end{bmatrix}t}\begin{bmatrix}x(0)\\y(0)\end{bmatrix}$