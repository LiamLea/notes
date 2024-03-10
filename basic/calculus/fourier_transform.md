# fourier transform


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [fourier transform](#fourier-transform)
    - [概述](#概述)
      - [1.sin函数](#1sin函数)
        - [(1) 基础](#1-基础)
        - [(2) 常用公式](#2-常用公式)
      - [2.以频率的形式表示sin函数](#2以频率的形式表示sin函数)
      - [3.fourier基础](#3fourier基础)
        - [(1) 波的叠加](#1-波的叠加)
        - [(2) 求解系数](#2-求解系数)
      - [4.fourier series](#4fourier-series)
      - [5.fourier tranformation](#5fourier-tranformation)

<!-- /code_chunk_output -->



### 概述

#### 1.sin函数

##### (1) 基础
$y=sin(kx+\varphi)$

* period: $\frac{2\pi}{k}$
* phase: $\varphi$

##### (2) 常用公式

* $sin(x+y) = sinx\cdot cosy + siny\cdot cosx$
* sin(-x)=-sinx
* cos(-x)=cosx


#### 2.以频率的形式表示sin函数

$f(t) = sin(2\pi kt)$
* frequence: 就是k，即 k clycle/s
* period: 1 (对于所有正整数k而言)
    * $\frac{2\pi}{2\pi k} = \frac{1}{k}$
    * 因为对于1/2（频率为2）是一个周期的sin函数，1肯定也是他的周期
    * 因为对于1/3（频率为3）是一个周期的sin函数，1肯定也是他的周期


#### 3.fourier基础

##### (1) 波的叠加

* $f(t) = \sum_{k=1}^{N}A_k\sin(2\pi kt + \varphi_k) = \sum_{k=1}^{N}(a_k\sin(2\pi kt) + b_k\cos(2\pi kt))$

* 欧拉公式和sin、cos的关系
  * 因为$e^{ix} = \cos x + i\sin x$
  * 所以
    * $\cos x = \frac{e^{ix}+e^{-ix}}{2}$
    * $\sin x=\frac{e^{ix}-e^{-ix}}{2i}$
  * 所以
    * $a_n\sin nx + b_n\cos nx = a_n\frac{e^{inx}+e^{-inx}}{2} + b_n\frac{e^{inx}-e^{-inx}}{2i} = \frac{a_n-ib_n}{2}e^{inx} + \frac{a_n+ib_n}{2}e^{-inx}$
* 根据上述推导，使用欧拉公式表示
    * $f(t) = \sum_{k=-n}^{n}C_ke^{2\pi i kt}$
        * $C_0$是实数
        * $C_k$是复数，且$C_k$和$C_{-k}$是**共轭**的（根据上述推导）
            * 比如$(a+ib)(cosx+isinx) + (a-ib)(cosx-isinx)=2acosx-2bsinx$

##### (2) 求解系数

* $C_m = f(t)e^{-2\pi imt} - \sum_{k\ne m}C_ke^{2\pi i (k-m)t} $
* 两边求微积分: $\int_0^1C_mdt = \int_0^1f(t)e^{-2\pi imt}dt + \int_0^1\sum_{k\ne m}C_ke^{2\pi i (k-m)t}dt$
  * $\int_0^1\sum_{k\ne m}C_ke^{2\pi i (k-m)t}dt = \frac{1}{2\pi i (k-m)} \sum_{k\ne m}C_ke^{2\pi i (k-m)t}dt$ 在t=1和t=0时的差值,即0
    * 因为$e^{2\pi i (k-m)t} = 1$
* 所以$C_m = \int_0^1f(t)e^{-2\pi imt}dt$

#### 4.fourier series

* $f(x) = ... + C_{-2}e^{-2\cdot 2\pi ix} + C_{-1}e^{-1\cdot 2\pi ix} + C_{0}e^{0\cdot 2\pi ix} + C_{1}e^{1\cdot 2\pi ix} + C_{2}e^{2\cdot 2\pi ix} + ...$

#### 5.fourier tranformation

将时域函数，转换成频率函数，即求fourier series的系数
* $F(w) = \int_{-\infty}^{\infty}f(t)\cdot e^{-iwt} dt$
  * $\int_0^1f(x)d(x) = C_0$
  * $\int_0^1f(x)e^{-2\cdot 2\pi ix}d(x) = C_2$
  * 依次类推: $C_n = \int_0^1f(x)e^{n\cdot 2\pi ix}d(x)$