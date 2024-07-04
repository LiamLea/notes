# second order


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [second order](#second-order)
    - [overview](#overview)
      - [1.second order linear differential equation](#1second-order-linear-differential-equation)
      - [2.homogenous differential equation](#2homogenous-differential-equation)
        - [(1) solution](#1-solution)
      - [3.non-homogenous differential equation](#3non-homogenous-differential-equation)
        - [(1) solution (undetermined coefficients)](#1-solution-undetermined-coefficients)
      - [4.使用Laplace transform](#4使用laplace-transform)

<!-- /code_chunk_output -->


### overview

#### 1.second order linear differential equation
$a(x)y''+b(x)y'+c(y)y=d(x)$

#### 2.homogenous differential equation

* $Ay''+By'+Cy=0$
* 性质：
  * 如果$g(x),h(x)$是方程的解，则
    * $C_1g(x)+C_2h(x)$也是方程的解 

##### (1) solution
* 举例：$y''+5y'+6y=0$
  * 设$y=e^{rx}$
  * $r^2e^{rx}+5re^{rx}+6e^{rx}=0$
  * $r^2+5r+6=0$
  * $r_1=-2,r_2=-3$
  * $y_1=C_1e^{-2x},y_2=C_2e^{-3x}$
  * $y=C_1e^{-2x}+C_2e^{-3x}$

* 对于r是复数的情况
  * 如果$r=\lambda \pm\mu i$
  * 带入Euler formula，得
    * $y=e^{\lambda x}(C_1\cos\mu x+C_2\sin\mu x)$

* 对于r只有一个值的情况
  * $y=v(x)e^{\lambda x}$
    * 将y带入公式求得: $y=(C_1+xC_2)e^{\lambda x}$

#### 3.non-homogenous differential equation

* $Ay''+By'+Cy=g(x)$

##### (1) solution (undetermined coefficients)

* 先求homogenous部分
  * $Ah''+Bh'+Ch=0$
* 再求particular solution
  * $Aj''+Bj'+Cj=g(x)$
* 所以general solution: $y=h+j$

* 举例: $y''-3y'-4y=3e^{2x}$
  * 求homogenous部分: $y''-3y'-4y=0$
    * $y_h=C_1e^{4x}+C_2e^{-x}$
  * 求particular solution
    * 猜测$y_j=Ae^{2x}$
    * 带入得 $A=-\frac{1}{2}$
  * $y=C_1e^{4x}+C_2e^{-x}-\frac{1}{2}e^{2x}$

* 举例: $y''-3y'-4y=4x^2$
  * 求homogenous部分: $y''-3y'-4y=0$
    * $y_h=C_1e^{4x}+C_2e^{-x}$
  * 求particular solution
    * 猜测$y_j=Ax^2+Bx+C$
    * 带入得 $A=-1,B=\frac{3}{2},C=-\frac{13}{8}$
  * $y=C_1e^{4x}+C_2e^{-x}-x^2+\frac{3}{2}x-\frac{13}{8}$

#### 4.使用Laplace transform

* 举例: $y''+5y'+6y=0,y(0)=2,y'(0)=3$
  * $\mathscr{L}\{y''\}+\mathscr{L}\{y'\}+6\mathscr{L}\{y\}=0$
  * $\because \mathscr{L}\{y'\}=s\mathscr{L}\{y\}-y(0)$
  * $\therefore \mathscr{L}\{y\}=\frac{2s+13}{s^2+5s+6}$
  * 进行inverse Laplace transform即可得到方程的解
* 举例: $y''+y=\sin 2t,y(0)=2,y'(0)=1$
  * Laplace transform:
    * $s^2Y(s)-2s-1+Y(s)=\frac{2}{s^2+4}$
  
  * $Y(s)=\frac{2}{(s^2+4)(s^2+1)}+\frac{2s}{s^2+1}+\frac{1}{s^2+1}$
  * 进行inverse Laplace transform即可得到方程的解