# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [现实意义](#现实意义)
      - [1.vector](#1vector)
        - [(1) 线性组合](#1-线性组合)
        - [(2) span](#2-span)
        - [(3) linear dependent](#3-linear-dependent)
        - [(4) basis vector（基向量）](#4-basis-vector基向量)
      - [2.矩阵](#2矩阵)
      - [3.线性变换](#3线性变换)
        - [(1) 以二维空间为例](#1-以二维空间为例)
        - [(2) 线性变换组合](#2-线性变换组合)
        - [(3) determinant (行列式)](#3-determinant-行列式)
        - [(4) inverse matrices (逆矩阵)](#4-inverse-matrices-逆矩阵)
        - [(5) rank (矩阵的秩)](#5-rank-矩阵的秩)
        - [(6) 非方阵](#6-非方阵)

<!-- /code_chunk_output -->


### 现实意义

#### 1.vector

*  一个向量就是一段运行轨迹

##### (1) 线性组合
* $\vec v_1 + \vec v_2$
    * 先进行第一段运行轨迹，再进行第二段运行轨迹
* $\vec v_1 * n$
    * 就是对运动轨迹进行scale（即拉伸或缩短）

##### (2) span

向量所有可能的**线性组合** 的 **集合**

##### (3) linear dependent
在一组向量中，其中一个向量，能由这组向量中的**其他向量** 通过 **线性组合** **相互转换**

##### (4) basis vector（基向量）
* 基向量一组**非线性相关**的向量，能够span到**整个空间**

* 对于二维空间来说，下面两个**非线性相关**的向量可以作为该空间的基向量
    * $\vec i$ = (1,0)
    * $\vec j$ = (0,1)
    * 所有向量都能由这两个向量进行scale得到

* 对于三维空间
    * $\vec i$ = (1,0,0)
    * $\vec j$ = (0,1,0)
    * $\vec k$ = (0,0,1)

#### 2.矩阵
由vector组成
* **一列**就是一个**vector**
* **一行**就是一个**维度**

#### 3.线性变换

##### (1) 以二维空间为例
* 默认前提:
    * 基向量：
        * $\vec i$ = (1,0)
        * $\vec j$ = (0,1)
    * 基向量用矩阵表示为
        * $\begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}$

* 存在一个向量$\vec v= \begin{bmatrix} x \\y \end{bmatrix} = x\vec i + y\vec j$

* 对基向量进行线性变量，则向量v的位置就能够确定
    * 比如旋转90度
    * 基向量就变为
        * $\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}$
    * 则向量v的位置就是
        * $\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}\begin{bmatrix} x \\y \end{bmatrix} = x\begin{bmatrix} 0 \\1 \end{bmatrix} + y\begin{bmatrix} -1 \\0 \end{bmatrix} = \begin{bmatrix} -y \\ x \end{bmatrix}$
    * 所以新的基向量就是**变换矩阵**

##### (2) 线性变换组合
即多次进行线性变换
* 第一次变换:
    * $\vec M_1 = \begin{bmatrix} a & b \\ c & d \end{bmatrix}$
* 第二次变换
    * $\vec M_2 = \begin{bmatrix} e & f \\ g & h \end{bmatrix}$
* 对向量v进行变换：
    * 对向量v先做$\vec M_1$变换再做$\vec M_2$变换
        * $\begin{bmatrix} e & f \\ g & h \end{bmatrix}\begin{bmatrix} a & b \\ c & d \end{bmatrix}\begin{bmatrix} x \\y \end{bmatrix} = \begin{bmatrix} e & f \\ g & h \end{bmatrix}(x\begin{bmatrix} a \\c \end{bmatrix} + y\begin{bmatrix} b \\d \end{bmatrix})$
    </br>
    * 先对基向量进行$\vec M_1$和$\vec M_2$变换，再对向量v变换
        * $\begin{bmatrix} e & f \\ g & h \end{bmatrix}\begin{bmatrix} a \\ c \end{bmatrix} = \begin{bmatrix} ae+cf \\ ag+ch \end{bmatrix}$
        </br>
        * $\begin{bmatrix} e & f \\ g & h \end{bmatrix}\begin{bmatrix} b \\ d \end{bmatrix} = \begin{bmatrix} be+df \\ bg+dh \end{bmatrix}$
        </br>
        * $\begin{bmatrix} ae+cf & be+df \\ ag+ch & gb+dh \end{bmatrix}\begin{bmatrix} x \\ y \end{bmatrix}$

##### (3) determinant (行列式)
* 用于描述**基向量**经过**线性变换**后的**空间变化程度**
    * 默认基向量空间1为，如果变换后的基向量空间为2,则称该变换的行列式为2
    * 当行列式为负数时，表示发生了翻转

* $det(\begin{bmatrix} a & 0 \\0 & b \end{bmatrix}) = a*b$
* $det(\begin{bmatrix} a & b \\c & d \end{bmatrix}) = ad - bc$
    * ![](./imgs/overview_01.png)
* $det(\begin{bmatrix} a & b & c\\d & e & f\\g & h & i \end{bmatrix}) = a*det(\begin{bmatrix} e & f \\h & i \end{bmatrix}) - b*det(\begin{bmatrix} d & f \\g & i \end{bmatrix}) - c*det(\begin{bmatrix} d & e \\g & h \end{bmatrix})$

##### (4) inverse matrices (逆矩阵)

* 矩阵就是对向量的变换，逆矩阵就是逆变换
    * 所以$A^{-1}A=E$
        * 二维$E=\begin{bmatrix} 1 & 0 \\0 & 1 \end{bmatrix}$
        * 三维$E=\begin{bmatrix} 1 & 0 & 0 \\0 & 1 &0 \\ 0 & 0 & 1 \end{bmatrix}$

* 当det(A)=0时，A不存在逆矩阵
    * 比如二维，当det(A)=0时，代表变换后span为一条直线，这样就不存在逆变换还原向量
    * 比如三维，当det(A)=0时，代表变换后span为一个平面或一条直线，同样无法还原向量

##### (5) rank (矩阵的秩)

* column space
    * 经过该矩阵变换，所有可能的span
* null space (kernel)
    * 比如二维，变换为一条直线，则变为0的向量集合（即该直线经过原点的垂直线）就是null space

* rank
    * 经过**column space**的**维度**
* $\begin{bmatrix} 2 & -2 \\1 & 1 \end{bmatrix}$
    * 这个线性变换后，span为一条直线，即一维，则这个矩阵的秩为1
* 三维矩阵线性变换后
    * span为一个平面，即二维，则秩为2
    * span为一条直线，即一维，则秩为1
* 满秩
    * 变换后，rank没有发生变化



##### (6) 非方阵

* 比如:
    * $\begin{bmatrix} 2 & 0 \\-1 & 1 \\ -2 & 1 \end{bmatrix}$
        * 将二维向量变换为三维向量
        * 但是变换还是在二维空间进行的
            * 所以column space的维度为2，所以为满秩
    * $\begin{bmatrix} 2 & 0 & 1\\-1 & 1 & 2 \end{bmatrix}$
        * 将三维向量变换为二维向量