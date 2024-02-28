# differential equations


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [differential equations](#differential-equations)
    - [概述](#概述)
      - [1.differential equations](#1differential-equations)
      - [2.PDE (partial differential equations)](#2pde-partial-differential-equations)
      - [3.fourier series](#3fourier-series)
        - [(1) 基本项](#1-基本项)
        - [(2) 表示任意函数](#2-表示任意函数)

<!-- /code_chunk_output -->


### 概述

#### 1.differential equations
an equation that relates one or more unknown functions and their derivatives.

#### 2.PDE (partial differential equations)
an equation which computes a function between various partial derivatives of a multivariable function
* partial derivatives（偏导数）
    * 有多个维度（即变量），每个维度有自己的变化（即针对每个变量求导）
    * 比如函数T(x,t)，x、t都是变量，则有偏导数：
        * $\frac{\partial T}{\partial x}$
        * $\frac{\partial T}{\partial t}$

#### 3.fourier series

##### (1) 基本项
不同频率、不同初始位置、不同幅度的sin函数（在complex plane上表示就是圆）
* $C_ne^{n\cdot 2\pi ix}$
    * $C_n$可以控制基本项的幅度（比如设为2）和初始位置（比如$e^{\frac{\pi}{4}i}$）

##### (2) 表示任意函数

* $f(x) = ... + C_{-2}e^{-2\cdot 2\pi ix} + C_{-1}e^{-1\cdot 2\pi ix} + C_{0}e^{0\cdot 2\pi ix} + C_{1}e^{1\cdot 2\pi ix} + C_{2}e^{2\cdot 2\pi ix} + ...$

* $\int_0^1f(x)d(x) = C_0$
* $\int_0^1f(x)e^{-2\cdot 2\pi ix}d(x) = C_2$
* 依次类推: $C_n = \int_0^1f(x)e^{n\cdot 2\pi ix}d(x)$