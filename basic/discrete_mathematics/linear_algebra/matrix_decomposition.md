# matrix decompositon


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [matrix decompositon](#matrix-decompositon)
    - [概述](#概述)
      - [1.singular value decomposition (SVD)](#1singular-value-decomposition-svd)
        - [(1) 如何确定U、V和$\Sigma$](#1-如何确定u-v和sigma)
      - [2.matrix factorizations](#2matrix-factorizations)
        - [(1) A = CR](#1-a--cr)
        - [(2) A=LU](#2-alu)
        - [(3) A=QR](#3-aqr)
        - [(4) $S=Q\Lambda Q^{-1} = Q\Lambda Q^T$ (S对称矩阵)](#4-sqlambda-q-1--qlambda-qt-s对称矩阵)
        - [(5) $A=X\Lambda X^{-1}$ (A非对称 方正矩阵)](#5-axlambda-x-1-a非对称-方正矩阵)
        - [(6) $A=U\Sigma V^T$ (非方正)](#6-ausigma-vt-非方正)

<!-- /code_chunk_output -->


### 概述

#### 1.singular value decomposition (SVD)
* $AV = U\Sigma$
    * U是$AA^T$的特征向量，V是$A^TA$的特征向量
        * 即U和V都是**orthonormal matrix**（即$U^T=U^{-1}, V^T=V^{-1}$）
        * $AA^T$和$A^TA$的特征值，降序排列，依次相等，剩下的等于0
            * 比如
                * $AA^T$ 2个特征值: $\lambda_1\ge\lambda_2$
                * $A^TA$ 3个特征值: $\lambda_1\ge\lambda_2\ge\lambda_3$
                * 则$\lambda_1=\lambda_1, \lambda_2=\lambda_2, \lambda_3=0$
        * 特征值相等，特征向量也相等
        * $\sigma_i^2=\lambda_i$
    * 即$A\begin{bmatrix}\\ \vec v_1 & \cdots & \vec v_r \\ \ \end{bmatrix} = \begin{bmatrix}\\ \vec u_1 & \cdots & \vec u_r \\ \ \end{bmatrix} \begin{bmatrix}\sigma_1 \\ & \ddots \\ && \sigma_r \end{bmatrix}$
    * **r是矩阵的rank**
    * singular values: $\sigma_1 \ge\sigma_2\ge ... \ge\sigma_r\ge 0$
    * singular vector: $U$ 和 $V^T$

* 所以 $A = U\Sigma V^T$ (其中A: $m\times n$)
    * $V^T(n\times n)$: 旋转，使得engivecor与 原先的basis位置 对齐
        * singular value最大的engivecor与x轴对齐，次大的与y轴对齐，依次类推
    * $\Sigma (m\times n)$: scale（对角矩阵只进行scale）
    * $U(m\times m)$: 旋转回原来的位置

##### (1) 如何确定U、V和$\Sigma$

* U是$AA^T$的特征向量
* V是$A^TA$的特征向量
* $\sigma_i^2$就是非0特征值 (U和V的非0的特征值相等)
* 证明
    * $A^TA=V\Sigma^TU^TU\Sigma V^T=V(\Sigma^T\Sigma)V^T$
    * $AA^T=U\Sigma V^TV\Sigma^TU^T=U(\Sigma\Sigma^T)U^T$

#### 2.matrix factorizations

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
* Q: **orthonormal matrix**
  * 每一列都是**S的单位特征向量**，因为S是对称矩阵，所以每个特征向量都正交
* $\Lambda$: diagonal matrix
    * 每一列是对应的特征值 $\begin{bmatrix}\lambda_1 \\ &\ddots \\ &&\lambda_n\end{bmatrix}$

* 因为特征向量和特征值的关系，所以$SQ=Q\Lambda$，所以$S=Q\Lambda Q^{-1}$
* 理解:
    * $Q^{-1}$: 旋转，使得engivecor与 原先的basis位置 对齐
        * 注意与Q区分，Q是旋转，使得basis与 原先的engivecor位置 对齐
    * $\Lambda$: 进行scale
    * $Q$: 旋转，复原（即使得engivecor与 原先的engivecor位置 对齐）

##### (5) $A=X\Lambda X^{-1}$ (A非对称 方正矩阵)
* X每一列都是**A的单位特征向量**, $\Lambda$每一列都是对应的特征值
* 因为$AX=X\Lambda$，所以$A=X\Lambda X^{-1}$
* 注意：**只有方正矩阵可逆**
* 能够推出：
  * $A^k=X\Lambda^k X^{-1}$
  * 特征值的和 = A对角线的数值相加

##### (6) $A=U\Sigma V^T$ (非方正)
* 因为只有方正矩阵才可能，所以无法使用(5)分解，而该分解能应用所有矩阵
[参考SVD](./overview.md#6singular-vectors-and-singular-values)