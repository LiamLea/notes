# integration


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [integration](#integration)
    - [overview](#overview)
      - [1.line integrals for scalar functions](#1line-integrals-for-scalar-functions)
      - [2.line integrals in vector fields](#2line-integrals-in-vector-fields)
        - [(1) path independence](#1-path-independence)
      - [3.double integrals  (surface integrals)](#3double-integrals--surface-integrals)
      - [4.polar coordinates](#4polar-coordinates)
      - [5.triple integrals](#5triple-integrals)

<!-- /code_chunk_output -->


### overview

#### 1.line integrals for scalar functions
![](./imgs/int_01.png)

* 已知
    * $x=g(t)$
    * $y=h(t)$
    * $a\le t \le b$
* 则
    *  $\int_{t=a}^{t=b}f(x,y)dS=\int_{t=a}^{t=b}f(x,y)\sqrt{dx^2+dy^2}=\int_{t=a}^{t=b}f(x,y)\sqrt{(\frac{dx}{dt})^2+(\frac{dy}{dt})^2}dt$

#### 2.line integrals in vector fields

* 已知
    * c (curve，位置函数):
        * $r(t)=x(t)\vec i+y(t)\vec j$
        * $a\le t \le b$
    * 再各个位置所受的力
        * $\vec f(x,y)$
    * 求做的功
* work $=\int_c\vec f\cdot d\vec r=\int_c\vec f \cdot (x'(t)dt\ \vec i+y'(t)dt\ \vec j)$

##### (1) path independence
* if $\vec f=\nabla F$
* then $\int_c\vec f\cdot d\vec r=F(b)-F(a)$
* 即path indepenence: $c_1$和$c_2$起点和终点一样的，但是路线不一样，最终做的功是一样的，与路线无关:
    * $\int_{c_1}\vec f\cdot d\vec r=\int_{c_2}\vec f\cdot d\vec r$

* 判断$\vec f(x,y)=P(x,y)\vec i+Q(x,y)\vec j$是否存在F:
    * $P_y=Q_x$，则存在F

#### 3.double integrals  (surface integrals)
![](./imgs/int_02.png)

* $\int_c^d\int_{a}^{b}f(x,y)dxdy=\int_a^b\int_{c}^{d}f(x,y)dydx$
    * 也可以写成: $\int\int_D f(x,y)dA$

#### 4.polar coordinates

$(\theta, r)$

#### 5.triple integrals

* 已知
    * 密度函数: $p(x,y,z)$，在各个位置的密度
    * 求物体的质量
* $\int P(x,y,z)dV=\int_{a_3}^{b_3}\int_{a_2}^{b_2}\int_{a_1}^{b_1} P(x,y,z)dzdydx$