# convex_optimization


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [convex_optimization](#convex_optimization)
    - [overview](#overview)
      - [1.基础概念](#1基础概念)
        - [(1) affine set](#1-affine-set)
        - [(2) convex set](#2-convex-set)
        - [(3) convex combination](#3-convex-combination)
        - [(4) convex hull](#4-convex-hull)
        - [(5) convex cone](#5-convex-cone)

<!-- /code_chunk_output -->


### overview

#### 1.基础概念

**x is a point in vector space**

##### (1) affine set

* 经过$x_1,x_2$的直线:
    * $x=\theta x_1+(1-\theta) x_2 \qquad \theta \in R$
        * 为什么系数加起来为1
            * 为了保证所有的点在一条直线上（$x_1,x_2$是常量，$\theta$是变量，不同的$\theta$值，产生不同的点）
            * $x=x_2+\theta(x_1-x_2)$

    ![](./imgs/co_03.png)
* affine set:
    * 集合中 任意两点 形成的 直线 还在集合中（所以affine set就是一条直线）

##### (2) convex set

* $x_1,x_2$的线段:
    * $x=\theta x_1+(1-\theta) x_2 \qquad 0\le\theta\le1$

* convex set:
    * 集合中 任意两点 形成的 线段 还在集合中
    ![](./imgs/co_01.png)

##### (3) convex combination

* $x=\theta_1x_1+\theta_2x_2+...+\theta_kx_k$
    * $\theta_1+\theta_2+...+\theta_3=1$
    * $\theta_i\ge0$

##### (4) convex hull
* a set of all convex combinations of all points
![](./imgs/co_02.png)

##### (5) convex cone
* conic combination:
    * $x=\theta_1x_1+\theta_2x_2$
        * $\theta_1\ge0,\theta_2\ge0$

![](./imgs/co_04.png)

* convex cone
    * a set of all canic combinations of all points