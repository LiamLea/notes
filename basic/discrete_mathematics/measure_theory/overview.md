# measure theory


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [measure theory](#measure-theory)
    - [概述](#概述)
      - [1.sigma-algebra](#1sigma-algebra)

<!-- /code_chunk_output -->


### 概述

#### 1.sigma-algebra

* 集合X，若$\mathcal{A}\subseteq P(X)$（$\mathcal{A}$是一个**元素为集合**的集合），且满足以下三个条件:
    * $\empty, X \in \mathcal{A}$
    * $\mathcal{A}$ 在补集运算下 是封闭的
        * 若$A\in\mathcal{A}$，则$A^c\in\mathcal{A}$
            * $A^c=X-A$
    * $\mathcal{A}$ 在可数个集合的并集运算下 是封闭的
        * 若$A_i\in\mathcal{A}, i\in\mathbb{N}$，则$\cup{A_N}\in\mathcal{A}$ 
            * $\mathbb{N}$和N都是表示自然数，即1,2,3,...
* 则称$\mathcal{A}$是一个$\sigma$-algebra