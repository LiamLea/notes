# decision tree


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [decision tree](#decision-tree)
    - [概述](#概述)
      - [1.术语](#1术语)
        - [(1) purity](#1-purity)

<!-- /code_chunk_output -->


### 概述

#### 1.术语

##### (1) purity
* 用entropy描述purity的程度，记为H
* $H(p) = -plog_2(p) - (1-p)log_2(1-p)$
    * 当$p=0$ 和 $p=1$ 时，$H(p) = 0$，最小
    * 当$p=0.5$时，$H(p) = 1$，最大