# fourier transform


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [fourier transform](#fourier-transform)
    - [概述](#概述)
      - [1.Euler's number e](#1eulers-number-e)
        - [(1) 定义](#1-定义)
        - [(2) 特性](#2-特性)
        - [(3) complex plane的理解](#3-complex-plane的理解)
        - [(4) Euler's formula](#4-eulers-formula)
        - [(5) $f(x)\cdot e^{ix}$的理解](#5-fxcdot-eix的理解)
      - [2.sin函数](#2sin函数)
        - [(1) 基础](#1-基础)
        - [(2) 常用公式](#2-常用公式)
      - [3.以频率的形式表示sin函数](#3以频率的形式表示sin函数)
      - [4.fourier基础](#4fourier基础)
        - [(1) 波的叠加](#1-波的叠加)
        - [(2) 求解系数](#2-求解系数)
      - [5.fourier series](#5fourier-series)
      - [6.fourier tranformation](#6fourier-tranformation)

<!-- /code_chunk_output -->



### 概述

#### 1.Euler's number e

##### (1) 定义
$\lim_{n \to \infty} (1 + \frac{1}{n})^n = 2.718...$

##### (2) 特性

* 导数是其本身
    * $\frac{d}{dx}e^x = e^x$

##### (3) complex plane的理解
* **二维**的数字，正常理解数字是一维的（即所有的数字都可以在一条负无穷到正无穷的直线上找到）
    * 横坐标为实数轴（Re），纵坐标为虚数轴（Im）
* **乘法**可以理解为 先**旋转**一定度数，然后进行**scale**
    * $z_1 * z_2$ 表示将$z_2$旋转 一定度数（$z_1$和横坐标形成的度数），然后进行scale
    * $(\frac{\sqrt 2}{2} + i\frac{\sqrt 2}{2})^2 = i$
        * 理解为1旋转45度，再旋转45度
    * 乘以$i$ 表示旋转90度（所以$i^2=-1$）
    * $x^3=1$，在complex plane中表示，1旋转3次相同的角度，还得到1，所以x有多种解（比如: $x=-\frac{1}{2} + i\frac{\sqrt 3}{2}$）

##### (4) Euler's formula

* $e^{ix}$的理解
  * 在**complex plane**上，以原点为与圆心的**圆周运动** (x可以理解成时间)
      * amplitude: 1（当$ne^{ix}$就是n）
      * period: $2\pi$ (时间单位)
      * frequency: $\frac{1}{period} = \frac{1}{2\pi}$

* 为什么$e^{ix}$是圆周运动
  * $\frac{d}{dx}e^{ix} = ie^{ix}$，即导数在任何位置都呈90度（因为i理解为旋转90度）
  * $e^0=1$
  * 所以只有 **单位圆** 满足要求
  * 所以 $e^{ix} = \cos x + i\sin x$
      * $e^{i\pi} = -1$

![](./imgs/ft_01.png)

##### (5) $f(x)\cdot e^{ix}$的理解
* **$f(x)$基于$e^{ix}$参照系的运动**
  * 将$e^{ix}$作为参照系，而不是通常使用的实数坐标系
  * 所以从实数坐标系角度看就是，$e^{ix}$和$f(x)$的**叠加**运动

* 当$f(x)$也是**周期**函数，就会出现如下效果
  * 当$f(x)$频率 > $e^{ix}$的频率
    * ![](./imgs/ft_02.png)
    * 所以 $\int_0^{2\pi} f(x)e^{ix} = 0$
  * 当$f(x)$频率 = $e^{ix}$的频率
    * ![](./imgs/ft_03.png)
    * 所以 $\int_0^{2\pi} f(x)e^{ix} > 0 $

#### 2.sin函数

##### (1) 基础
$y=sin(kx+\varphi)$

* period: $\frac{2\pi}{k}$
* phase: $\varphi$

##### (2) 常用公式

* $sin(x+y) = sinx\cdot cosy + siny\cdot cosx$
* sin(-x)=-sinx
* cos(-x)=cosx


#### 3.以频率的形式表示sin函数

$f(t) = sin(2\pi kt)$
* frequence: 就是k，即 k clycle/s
* period: 1 (对于所有正整数k而言)
    * $\frac{2\pi}{2\pi k} = \frac{1}{k}$
    * 因为对于1/2（频率为2）是一个周期的sin函数，1肯定也是他的周期
    * 因为对于1/3（频率为3）是一个周期的sin函数，1肯定也是他的周期


#### 4.fourier基础

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

#### 5.fourier series

* $f(x) = ... + C_{-2}e^{-2\cdot 2\pi ix} + C_{-1}e^{-1\cdot 2\pi ix} + C_{0}e^{0\cdot 2\pi ix} + C_{1}e^{1\cdot 2\pi ix} + C_{2}e^{2\cdot 2\pi ix} + ...$

#### 6.fourier tranformation

将时域函数，转换成频率函数，即求fourier series的系数
* $F(w) = \int_{-\infty}^{\infty}f(t)\cdot e^{-iwt} dt$
  * $\int_0^1f(x)d(x) = C_0$
  * $\int_0^1f(x)e^{-2\cdot 2\pi ix}d(x) = C_2$
  * 依次类推: $C_n = \int_0^1f(x)e^{n\cdot 2\pi ix}d(x)$