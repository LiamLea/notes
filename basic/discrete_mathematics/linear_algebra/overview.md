# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [几何意义](#几何意义)
      - [1.vector](#1vector)
        - [(1) 线性组合](#1-线性组合)
        - [(2) span](#2-span)
        - [(3) linear dependent](#3-linear-dependent)
        - [(4) basis vector（基向量）](#4-basis-vector基向量)
      - [2.矩阵](#2矩阵)
      - [3.线性变换](#3线性变换)
        - [(1) 定义](#1-定义)
        - [(2) 以二维空间为例](#2-以二维空间为例)
        - [(3) 线性变换组合](#3-线性变换组合)
        - [(4) determinant (行列式)](#4-determinant-行列式)
        - [(5) inverse matrices (逆矩阵)](#5-inverse-matrices-逆矩阵)
        - [(6) rank (矩阵的秩)](#6-rank-矩阵的秩)
        - [(7) 非方阵](#7-非方阵)
      - [4.product](#4product)
        - [(1) dot product](#1-dot-product)
        - [(2) cross product](#2-cross-product)
      - [5.cramer's rule求解线性方程](#5cramers-rule求解线性方程)
      - [6.change of basis (基向量变换)](#6change-of-basis-基向量变换)
      - [7.eigenvectors and eigenvalues](#7eigenvectors-and-eigenvalues)
        - [(1) 特征值和特征向量](#1-特征值和特征向量)
        - [(2) eigenbasis](#2-eigenbasis)
      - [8.vector spaces](#8vector-spaces)
        - [(1) 以函数求导为例子](#1-以函数求导为例子)

<!-- /code_chunk_output -->


### 几何意义

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

##### (1) 定义

* $L(\vec v + \vec w) = L(\vec v) + L(\vec w)$
* $L(c\vec v) = cL(\vec v)$

* 所以**所有向量**可以使用**基向量**进行表示，然后对**基向量**进行**线性变换**，从而求得对**该向量**的**线性变换**

##### (2) 以二维空间为例
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
        * $\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}\begin{bmatrix} x \\y \end{bmatrix} = x\vec i + y\vec j =x\begin{bmatrix} 0 \\1 \end{bmatrix} + y\begin{bmatrix} -1 \\0 \end{bmatrix} = \begin{bmatrix} -y \\ x \end{bmatrix}$
    * 所以新的基向量就是**变换矩阵**

##### (3) 线性变换组合
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

##### (4) determinant (行列式)
* 用于描述**基向量**经过**线性变换**后的**空间变化程度**
    * 默认基向量空间1为，如果变换后的基向量空间为2,则称该变换的行列式为2
    * 当行列式为负数时，表示发生了翻转

* $det(\begin{bmatrix} a & 0 \\0 & b \end{bmatrix}) = a*b$
* $det(\begin{bmatrix} a & b \\c & d \end{bmatrix}) = ad - bc$
    * ![](./imgs/overview_01.png)
* $det(\begin{bmatrix} a & b & c\\d & e & f\\g & h & i \end{bmatrix}) = a*det(\begin{bmatrix} e & f \\h & i \end{bmatrix}) - b*det(\begin{bmatrix} d & f \\g & i \end{bmatrix}) - c*det(\begin{bmatrix} d & e \\g & h \end{bmatrix})$

##### (5) inverse matrices (逆矩阵)

* 矩阵就是对向量的变换，逆矩阵就是逆变换
    * 所以$A^{-1}A=E$
        * 二维$E=\begin{bmatrix} 1 & 0 \\0 & 1 \end{bmatrix}$
        * 三维$E=\begin{bmatrix} 1 & 0 & 0 \\0 & 1 &0 \\ 0 & 0 & 1 \end{bmatrix}$

* 当det(A)=0时，A不存在逆矩阵
    * 比如二维，当det(A)=0时，代表变换后span为一条直线，这样就不存在逆变换还原向量
    * 比如三维，当det(A)=0时，代表变换后span为一个平面或一条直线，同样无法还原向量

##### (6) rank (矩阵的秩)

* column space
    * 所有column vectors（一个column就是一个vector）构成的span
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
    * 行满秩: 行数 = rank
    * 列满秩: 列数 = rank
    * 如果将列看成一个向量时，当列满秩时，行列式才不为0，此时
        * 才能求出逆矩阵，也就是方程式有解
        * 如果不满秩，行列式为0，方程式可以有无限的解 或者 无解

##### (7) 非方阵

* 比如:
    * $\begin{bmatrix} 2 & 0 \\-1 & 1 \\ -2 & 1 \end{bmatrix}$
        * 将二维向量变换为三维向量
        * 但是**变换还是在二维空间进行**的
            * 所以column space的维度为2，所以为满秩
    * $\begin{bmatrix} 2 & 0 & 1\\-1 & 1 & 2 \end{bmatrix}$
        * 将三维向量变换为二维向量
        * 比如:
            * 存在$\vec v=\begin{bmatrix} 4 \\ 3\end{bmatrix}$
            * 线性变换: $\begin{bmatrix} 1 & -2 \end{bmatrix}$
            * 变换后的 $\vec v' = 4\vec i + 3\vec j = 4\begin{bmatrix} 1 \end{bmatrix} + 3\begin{bmatrix} -2 \end{bmatrix} = [-2]$

#### 4.product

##### (1) dot product
* 和matrix multiply区分
    * dot product对象：向量，输出是一个值
    * matrix multiply对象：矩阵，输出是另一个矩阵
* $\vec v \cdot \vec w$ = (length of projected $\vec w$ on $\vec v$)(length of $\vec v$) = $\vec w \cdot \vec v$
    * 当$\vec v$和$\vec w$方向 不一致时为负数，垂直时为0

* 可以将$\begin{bmatrix} 1 \\ 2 \end{bmatrix} \cdot \begin{bmatrix} 4 \\ 3 \end{bmatrix}$理解成，对向量进行线性变换
    * $\begin{bmatrix} 1 & 2 \end{bmatrix} \begin{bmatrix} 4 \\ 3 \end{bmatrix}=1*4+2*3=10$

* 为什么映射和线性变换有关
    * duality: 比如存在一条斜线，该斜线的1单元记为$\vec u$，在x上的映射（也是$\vec i$在该斜线上的映射）记为$u_x$，在y上的映射（也是$\vec j$在该斜线上的映射）记为$u_y$
        * 能够得出结论：$\vec i$和$\vec j$在该斜线上的映射 = $\vec u$在x和y上的映射
    * 若该斜线上存在一个向量$\vec v = (v_x,v_y)$，$\vec v \cdot \begin{bmatrix} x \\ y \end{bmatrix}$

    * $\begin{bmatrix} x \\ y \end{bmatrix} = x\vec i + y\vec j$，求在$\vec v$上的映射，所以基向量$(\vec i, \vec j)$就变为了$\vec v = (v_x,v_y)$，所以$\begin{bmatrix} x \\ y \end{bmatrix}$在该斜线上的映射就是$xv_x + yv_y$，也就是$\begin{bmatrix} v_x & v_y \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix}$

    ![](./imgs/overview_02.png)

##### (2) cross product
* 两个二维向量叉乘，$\vec v \times \vec w$ 结果是两个向量构成的平行四边形的面积（如果$\vec v$ 在右边，则是正数）
* 两个三维向量叉乘，产生一个新的三维向量: $\vec v \times \vec w = \vec p$
    * $\vec w$的长度是 $\vec v$和$\vec w$组成平行图的面积（即行列式的值）
    * $\vec p$的方向是 经过原点 与$\vec v$和$\vec w$所在平面垂直
        * 右手法则:
            * 食指表示$\vec v$
            * 中指表示$\vec w$
            * 大拇指的方向就是$\vec p$的方向
* 从三维向量的叉乘计算 -> 几何意义
    * $\vec v \times \vec w = det(\begin{bmatrix} \vec i & v_1 & w_1 \\ \vec j & v_2 & v_2 \\ \vec k & v_3 & w_3 \end{bmatrix})= \vec p \cdot \begin{bmatrix} \vec i \\ \vec j \\ \vec k \end{bmatrix}$
        * 存在$\vec p$使得该等式成立
        * $det(\begin{bmatrix} \vec i & v_1 & w_1 \\ \vec j & v_2 & v_2 \\ \vec k & v_3 & w_3 \end{bmatrix})$ = ($\vec v$和$\vec w$的面积) * ($\begin{bmatrix} \vec i \\ \vec j \\ \vec k \end{bmatrix}$在 $\vec v$和$\vec w$平面的垂直线上 的映射) 
        * $\vec p \cdot \begin{bmatrix} \vec i \\ \vec j \\ \vec k \end{bmatrix}$ = ($\begin{bmatrix} \vec i \\ \vec j \\ \vec k \end{bmatrix}$在$\vec p$上的映射) * ($\vec p$的长度)
        * 所以$\vec p$
            * 方向 在$\vec v$和$\vec w$平面的垂直线上 
            * 大小为$\vec v$和$\vec w$的面积

#### 5.cramer's rule求解线性方程

求解: $\begin{bmatrix} 2 & -1 \\ 0 & 1 \end{bmatrix} \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} 4 \\ 2 \end{bmatrix}$

* $\vec i$和y所构成的面积 = $det(\begin{bmatrix} 1 & 0 \\ 0 & y \end{bmatrix})$ = y
* $\vec j$和x所构成的面积 = $det(\begin{bmatrix} x & 0 \\ 0 & 1 \end{bmatrix})$ = x

* 经过线性变化，面积增长比列：$det(\begin{bmatrix} 2 & -1 \\ 0 & 1 \end{bmatrix})$ = 2
* 转换后
    * $\vec i$和y轴所构成的面积 = $det(\begin{bmatrix} 2 & 4 \\ 0 & 2 \end{bmatrix})$ = 4
    * $\vec j$和y轴所构成的面积 = $det(\begin{bmatrix} 4 & -1 \\ 2 & 1 \end{bmatrix})$ = 6
* 所以 y = 4/2 = 2, x = 6/2 =3

#### 6.change of basis (基向量变换)

* 使用新的基向量，描述 向量 和 线性变换
* 求某个向量在该基向量中的线性变换: $A^{-1}MA$
    * A就是将该基向量，变换为$\vec i$和$\vec j$向量
    * M是在$\vec i$和$\vec j$向量中做的线性变换
    * $A^{-1}$然后再变换为新的基础向量 

* 比如，自定义了新的基向量$\vec m$ = (2,1)和 $\vec n$ = (-1,1)，则求(-1,2)=$-1\vec m + 2 \vec n$，经过$\begin{bmatrix} 0 & -1 \\ 1 & 0\end{bmatrix}$线性变换
    * $\begin{bmatrix} 2 & -1 \\ 1 & 1 \end{bmatrix}^{-1}\begin{bmatrix} 0 & -1 \\ 1 & 0 \end{bmatrix}\begin{bmatrix} 2 & -1 \\ 1 & 1 \end{bmatrix}\begin{bmatrix} -1 \\ 2 \end{bmatrix}$

#### 7.eigenvectors and eigenvalues

##### (1) 特征值和特征向量
* **特征向量**：经过线性变换，向量的span没有改变，只是进行了scale
* scale的值就是 **特征值**
* 比如: 进行$\begin{bmatrix} 1 & 1 \\ 0 & 1 \end{bmatrix}$线性变换，x轴的span没有改变，scale值为1,所以x轴上的所有向量都是特征向量，特征值为1

* 数学定义: $A\vec v= \lambda \vec v$
    * $\lambda$可以 $\lambda I$，I是主对角线都为1的矩阵
    * 所以$(A-\lambda I)\vec v= 0$
    * 所以$det(A-\lambda I)=0$

* 不是所有的线性变换都有特征值和特征向量的

##### (2) eigenbasis
针对某一个线性变换，使用一组特征向量作为新的基向量，如果需要计算多次进行该线性变换，使用eignebasis简化计算，因为除了主对角线上，其他地方都为0

#### 8.vector spaces

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