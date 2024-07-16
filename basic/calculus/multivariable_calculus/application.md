# application


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [application](#application)
    - [overview](#overview)
      - [1.local linearization](#1local-linearization)
        - [(1) tangent plane (local linearization in 3d space)](#1-tangent-plane-local-linearization-in-3d-space)
        - [(2) local linearization](#2-local-linearization)
      - [2.quadratic approximations](#2quadratic-approximations)
        - [(1) in 3d space](#1-in-3d-space)
        - [(2) generalization](#2-generalization)

<!-- /code_chunk_output -->


### overview

#### 1.local linearization

用于简单的估计某个点附近的值

##### (1) tangent plane (local linearization in 3d space)
* 存在函数$f(x,y)$，经过$(x_0,y_0,f(x_0,y_0))$这个点的，plane函数:
    * $L_f(x,y)=f_x(x_0,y_0)(x-x_0)+f_y(x_0,y_0)(y-y_0)+f(x_0,y_0)$
        * 因为平面和y=C的相交线都是平行的，所以该函数针对x的偏导数是常数（同理y）
        * $f_x(x_0,y_0)=\frac{\partial f}{\partial x}(x_0,y_0)$
        * $f_y(x_0,y_0)=\frac{\partial f}{\partial y}(x_0,y_0)$

##### (2) local linearization
* 存在函数$f(\vec x)$，经过$\vec x_0$这个点的，local linearization:
    * $L_f(\vec x)=f(\vec x_0)+\nabla f(\vec x_0)\cdot (\vec x - \vec x_0)$
  
#### 2.quadratic approximations
用于估计某个点附近的函数

##### (1) in 3d space
* $Q_f(x,y)=f_x(x_0,y_0)(x-x_0)+f_y(x_0,y_0)(y-y_0)+f(x_0,y_0)+\frac{1}{2}f_{xx}(x_0,y_0)(x-x_0)^2+f_{xy}(x_0,y_0)(x-x_0)(y-y_0)+\frac{1}{2}f_{yy}(x_0,y_0)(y-y_0)^2$
  * 二项式的系数是如何确定的：
    * $Q_{xx}(x_0,y_0)=f_{xx}(x_0,y_0)$
    * $Q_{yx}(x_0,y_0)=f_{yx}(x_0,y_0)$
    * $Q_{yy}(x_0,y_0)=f_{yy}(x_0,y_0)$

##### (2) generalization

* $f(x,y)$的Hessian matrix
  * $\vec H_f=\begin{bmatrix}f_{xx}&f_{xy}\\f_{yx}&f_{yy}\end{bmatrix}$

* $Q_f(\vec x)=f(\vec x_0)+\nabla f(\vec x_0)\cdot (\vec x - \vec x_0)+\frac{1}{2}(\vec x-\vec x_0)^T\cdot\vec H_f(\vec x_0)\cdot(\vec x-\vec x_0)$
  * $\vec x$ shape: (n, 1)