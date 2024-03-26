# Advance


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Advance](#advance)
    - [概述](#概述)
      - [1.matrix factorizations](#1matrix-factorizations)
        - [(1) A = CR](#1-a--cr)
        - [(2) A=LU](#2-alu)
        - [(3) A=QR](#3-aqr)
        - [(4) $S=Q\Lambda Q^{-1} = Q\Lambda Q^T$ (S对称矩阵)](#4-sqlambda-q-1--qlambda-qt-s对称矩阵)
        - [(5) $A=X\Lambda X^{-1}$ (A非对称 方正矩阵)](#5-axlambda-x-1-a非对称-方正矩阵)
        - [(6) $A=U\Sigma V^T$ (非方正)](#6-ausigma-vt-非方正)
      - [3.norm](#3norm)
        - [(1) vector norm](#1-vector-norm)
        - [(2) matrix norm](#2-matrix-norm)

<!-- /code_chunk_output -->

### 概述

#### 1.matrix factorizations

##### (1) A = CR
* $A=\begin{bmatrix}1&1&3\\2&3&7\\1&4&6 \end{bmatrix} = \begin{bmatrix}1&1\\2&3\\1&4 \end{bmatrix}\begin{bmatrix}1&0&2\\0&1&1\end{bmatrix} = CR$
  * A的column1和column2线性无关
      * 所以C是这样的
      * R的col1和col2就是相应的基向量
  * A.column3 = 2(column1) + 1(column2)
      * 所以R.column3 = $\begin{bmatrix}2\\1\end{bmatrix}$
* R可以表示为 $[I\ F]$
  * I是identity matrix，F是任意的矩阵
  * 通过permutation（即调整列的位置），将单元向量都放在前面
* $[I\ F]\begin{bmatrix} -F \\ I \end{bmatrix} = 0$
  * 所以方程的解就是$\begin{bmatrix} -F \\ I \end{bmatrix}$

* 应用：
    * 求解线性，将方程 Ax--简化-->Rx
        * A和R是系数

##### (2) A=LU
* 本质就是 **消元**
* L是下三角矩阵，即矩阵的上三角都是0
* U是下三角矩阵

##### (3) A=QR
* Q标准正交矩阵
* $Q^TA=R$
  * [参考](overview.md#3-orthogonal-matrix)

##### (4) $S=Q\Lambda Q^{-1} = Q\Lambda Q^T$ (S对称矩阵)
* Q 是标准正交矩阵
  * 每一列都是**S的单位特征向量**，因为S是对称矩阵，所以每个特征向量都正交
* $\Lambda$ 每一列是对应的特征值 $\begin{bmatrix}\lambda_1 \\ &\ddots \\ &&\lambda_n\end{bmatrix}$

* 因为特征向量和特征值的关系，所以$SQ=Q\Lambda$，所以$S=Q\Lambda Q^{-1}$

##### (5) $A=X\Lambda X^{-1}$ (A非对称 方正矩阵)
* 每一列都是**A的单位特征向量**
* 因为$AX=X\Lambda$，所以$A=X\Lambda X^{-1}$
* 注意：**只有方正矩阵可逆**

##### (6) $A=U\Sigma V^T$ (非方正)
* 因为只有方正矩阵才可能，所以无法使用(5)分解，而该分解能应用所有矩阵
[参考](./overview.md#6singular-vectors-and-singular-values)

#### 3.norm

##### (1) vector norm
* Lp-norm: $\Vert \vec x \Vert_p = (\sum\limits_{i=1}^{n}|x_i|)^{1/p}$
    * L1-norm (Manhatten distance)
      * $\Vert \vec x\Vert_1 = \sum\limits_{i=1}^{n}|x_1|$
    * L2-norm (Euclidean distance)
      * $\Vert \vec x\Vert_2 = (\sum\limits_{i=1}^{n}|x_1|^2)^{1/2}$
* $\infty$-norm: $\Vert \vec x \Vert_{\infty} = \underset{i}{max}|x_i|$

##### (2) matrix norm

* Frobenius norm
  * $\Vert A\Vert_F = |\sum_{i,j}abs(a_{i,j})^2|^{1/2}$
* L1-norm
  * $\Vert A\Vert_1$ = `max( sum(abs(x), axis=0) )`
* L2-norm
  * $\Vert A\Vert_2$ = largest sing. value