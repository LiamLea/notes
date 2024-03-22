# Application


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Application](#application)
    - [概述](#概述)
      - [1.cramer's rule求解线性方程](#1cramers-rule求解线性方程)
      - [2.change of basis (基向量变换)](#2change-of-basis-基向量变换)
      - [3.vector spaces](#3vector-spaces)
        - [(1) 以函数求导为例子](#1-以函数求导为例子)

<!-- /code_chunk_output -->


### 概述

#### 1.cramer's rule求解线性方程

求解: $\begin{bmatrix} 2 & -1 \\ 0 & 1 \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 4 \\ 2 \end{bmatrix}$

* $\vec i$和y所构成的面积 = $det(\begin{bmatrix} 1 & 0 \\ 0 & y \end{bmatrix})$ = y
* $\vec j$和x所构成的面积 = $det(\begin{bmatrix} x & 0 \\ 0 & 1 \end{bmatrix})$ = x

* 经过线性变化，面积增长比列：$det(\begin{bmatrix} 2 & -1 \\ 0 & 1 \end{bmatrix})$ = 2
* 转换后
    * $\vec i$和y轴所构成的面积 = $det(\begin{bmatrix} 2 & 4 \\ 0 & 2 \end{bmatrix})$ = 4
    * $\vec j$和y轴所构成的面积 = $det(\begin{bmatrix} 4 & -1 \\ 2 & 1 \end{bmatrix})$ = 6
* 所以 y = 4/2 = 2, x = 6/2 =3

#### 2.change of basis (基向量变换)

* 使用新的基向量，描述 向量 和 线性变换
* 求某个向量在该基向量中的线性变换: $A^{-1}MA$
    * A就是将该基向量，变换为$\vec i$和$\vec j$向量
    * M是在$\vec i$和$\vec j$向量中做的线性变换
    * $A^{-1}$然后再变换为新的基础向量 

* 比如，自定义了新的基向量$\vec m$ = (2,1)和 $\vec n$ = (-1,1)，则求(-1,2)=$-1\vec m + 2 \vec n$，经过$\begin{bmatrix} 0 & -1 \\ 1 & 0\end{bmatrix}$线性变换
    * $\begin{bmatrix} 2 & -1 \\ 1 & 1 \end{bmatrix}^{-1}\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}\begin{bmatrix} 2 & -1 \\ 1 & 1 \end{bmatrix}\begin{bmatrix} -1 \\ 2 \end{bmatrix}$

#### 3.vector spaces

描述 所有具有向量这种性质 事物，比如函数

##### (1) 以函数求导为例子

* 设置基向量
    * $b_0(x)=1$
    * $b_1(x)=x$
    * $b_2(x)=x^2$
    * $b_3(x)=x^3$
    * ...

* 求导$x^3+5x^2+4x+5$
    * 用基向量表示这个函数: $\begin{bmatrix} 5 \\ 4 \\ 5 \\ 1 \\ \vdots \end{bmatrix}$
    * 对基向量求导: $\begin{bmatrix} 0 & 1 & 0 & 0 & \cdots \\ 0 & 0 & 2 & 0 & \cdots \\ 0 & 0 & 0 & 3 & \cdots \\ 0 & 0 & 0 & 0 & \cdots \\ \vdots & \vdots & \vdots & \vdots & \ddots \end{bmatrix}$
    * 结果就是: $\begin{bmatrix} 0 & 1 & 0 & 0 & \cdots \\ 0 & 0 & 2 & 0 & \cdots \\ 0 & 0 & 0 & 3 & \cdots \\ 0 & 0 & 0 & 0 & \cdots \\ \vdots & \vdots & \vdots & \vdots & \ddots \end{bmatrix}\begin{bmatrix} 5 \\ 4 \\ 5 \\ 1 \\ \vdots \end{bmatrix}=\begin{bmatrix} 1*4 \\ 2*5 \\ 3*1 \\ 0 \\ \vdots \end{bmatrix}$，所以结果就是$3x^2+10x+4$