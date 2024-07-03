# Laplace transform


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Laplace transform](#laplace-transform)
    - [overview](#overview)
      - [1.Laplace transform](#1laplace-transform)
        - [(1) Laplace table](#1-laplace-table)
        - [(2) properties](#2-properties)
        - [(3) inverse Laplace](#3-inverse-laplace)

<!-- /code_chunk_output -->


### overview

#### 1.Laplace transform
* $\mathscr{L}\{f(t)\}=\int_0^{\infty}e^{-st}f(t)dt$

##### (1) Laplace table
常见Laplace transform
* $\mathscr{L}\{1\}=\frac{1}{s}$
* $\mathscr{L}\{e^{at}\}=\frac{1}{s-a},\ s>a$
* $\mathscr{L}\{\sin{at}\}=\frac{a}{s^2+a^2}$
    * 利用integration by parts：
        * $\frac{d}{dt}(uv)=u'v+uv'$
        * $\therefore uv=\int u'v+\int uv'$
        * $\therefore \int u'v=uv-\int uv'$
* $\mathscr{L}\{\cos{at}\}=\frac{s}{s^2+a^2}$
* $\mathscr{L}\{t^n\}=\frac{n!}{s^{n+1}}$

##### (2) properties

* linear operator
    * $\mathscr{L}\{C_1f(t)+C_2g(t)\}=C_1\mathscr{L}\{f(t)\}+C_2\mathscr{L}\{g(t)\}$
</br>
* $\mathscr{L}\{f'(t)\}=s\mathscr{L}\{f(t)\}-f(0)$
    * 利用integration by parts进行推导
    * $\mathscr{L}\{y''\}=s\mathscr{L}\{y'\}-y'(0)=s^2\mathscr{L}\{y\}-sy(0)-y'(0)$
    * $\mathscr{L}\{y^{(4)}\}=s^4\mathscr{L}\{y\}-s^3y(0)-s^2y'(0)-sy''(0)-y^{(3)}(0)$
</br>
* $\mathscr{L}\{f(t)\}=F(s) \Longrightarrow \mathscr{L}\{e^{at}f(t)\}=F(s-a)$
</br>
* $\mathscr{L}\{u_c(t)f(t-c)\}=e^{-sc}\mathscr{L}\{f(t)\}$
    * 其中 $u_c(t)=\begin{cases}0&t\lt c\\1&t\ge c\end{cases}$
</br>
* $\mathscr{L}\{\delta(t-c)f(t)\}=e^{-sc}f(c)$
    * Dirac delta function
        * $\delta(x)=\begin{cases}\infty&x=0\\0&x\ne0\end{cases}$
        * $\int_{-\infty}^\infty\delta(x)dx=1$

##### (3) inverse Laplace

* 举例:
    * $F(s)=\frac{3!}{(s-2)^4}$
        * $\mathscr{L}\{t^3\}=\frac{3!}{s^{4}}$
        * $\mathscr{L}\{e^{2t}t^3\}=\frac{3!}{(s-2)^{4}}$
        * $\mathscr{L}^{-1}\{\frac{3!}{(s-2)^4}\}=e^{2t}t^3$
    * $F(s)=\frac{2(s-1)e^{-2s}}{s^2-2s+2}$
        * $F(s)=\frac{2e^{-2s}(s-1)}{(s-1)^2+1}$
        * $\mathscr{L}\{\cos{t}\}=\frac{s}{s^2+1}$
        * $\mathscr{L}\{e^t\cos{t}\}=\frac{s-1}{(s-1)^2+1}$
        * $\mathscr{L}\{u_2(t)e^{t-2}\cos{(t-2)}\}=\frac{(s-1)e^{-2s}}{(s-1)^2+1}$
        * $\mathscr{L}^{-1}\{\frac{2(s-1)e^{-2s}}{s^2-2s+2}\}=u_2(t)e^{t-2}\cos{(t-2)}$
