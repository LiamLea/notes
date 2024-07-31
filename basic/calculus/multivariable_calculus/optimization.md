# optimization


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [optimization](#optimization)
    - [overview](#overview)
      - [1.critical point](#1critical-point)
      - [2.second partial derivative test (2 variables)](#2second-partial-derivative-test-2-variables)
      - [3.constrained optimization](#3constrained-optimization)
        - [(1) Lagrange multipliers](#1-lagrange-multipliers)
        - [(2) Lagranian](#2-lagranian)
        - [(3) consider b as a variable](#3-consider-b-as-a-variable)

<!-- /code_chunk_output -->


### overview

#### 1.critical point

* $\nabla f=\vec 0$
* 可能的情况
    * maxima/minima point
    * saddle point
    * unknown

#### 2.second partial derivative test (2 variables)

* find critical points: 
    * $\nabla f=\vec 0$
* second partial derivative test:
    * $H=f_{xx}(x_0,y_0)f_{yy}(x_0,y_0)-f_{xy}(x_0,y_0)^2$
        * if H<0, $(x_0,y_0)$ is saddle point
        * if H>0
            * if $f_{xx}(x_0,y_0)<0$, $(x_0,y_0)$ is local maximum point
            * if $f_{xx}(x_0,y_0)>0$, $(x_0,y_0)$ is local minimum point
        * 公式推导：
            * 求$f(x_0,y_0)$的quadratic form: $Q_f(x_0,y_0)=f(x_0,y_0)+ax^2+2bxy+cy^2$
                * 当$ax^2+2bxy+cy^2$一直为正数，在$(x_0,y_0)$有local minimum，为$f(x_0,y_0)$
                * 当$ax^2+2bxy+cy^2$一直为负数，在$(x_0,y_0)$有local maximum，为$f(x_0,y_0)$
            * 从而继续推导得到上述式子（[参考](https://www.khanacademy.org/math/multivariable-calculus/applications-of-multivariable-derivatives/optimizing-multivariable-functions/a/reasoning-behind-the-second-partial-derivative-test)）

#### 3.constrained optimization

比如：maximize $f(x,y)$ on the set $g(x,y)=b$ (b is constant) 

##### (1) Lagrange multipliers
* $\nabla f(x_m,y_m)=\lambda \nabla g(x_m,y_m)$
    * 取到最大值时，$g(x,y)$与$f(x,y)$ countour line相切
        * 所以需要找到相切点，然后再找出最大值
    * 由于gradient和coutour line垂直，所以在相切点，函数g和函数f的gradient方向一样，大小不等 
        * multiplier: $\lambda$不能为0

##### (2) Lagranian
上述式子的简化，方便计算机计算
* $\mathcal{L}(x,y,\lambda)=f(x,y)-\lambda(g(x,y)-b)$
* $\nabla \mathcal{L}=\vec 0$
    * 等价于:
        * $\nabla f(x,y)=\lambda \nabla g(x,y)$
        * $g(x,y)=b$
    * 先需要找到相切点，然后再找出
        * 最大值 的相切点：$(x^*,y^*,\lambda^*)$
        * 最大值：$M^*=f(x^*,y^*)$

##### (3) consider b as a variable

* $\frac{dM^*}{db}=\lambda^*$
    * $M^*(b)=f(x^*(b),y^*(b))$
    * 推导:
        * $\mathcal{L^*}(x^*(b),y^*(b),\lambda^*(b),b)=f(x^*(b),y^*(b))-\lambda^*(g(x^*(b),y^*(b))-b)$
        * $\frac{d\mathcal{L^*}}{db}=\frac{\partial\mathcal{L^*}}{\partial  x^*}\cdot\frac{d x^*}{db}+\frac{\partial\mathcal{L^*}}{\partial  y^*}\cdot\frac{d y^*}{db}+\frac{\partial\mathcal{L^*}}{\partial  \lambda^*}\cdot\frac{d \lambda^*}{db}+\frac{\partial\mathcal{L^*}}{\partial  b}$
        * $\frac{d\mathcal{L^*}}{db}=\frac{\partial\mathcal{L^*}}{\partial  b}=\lambda^*(b)$