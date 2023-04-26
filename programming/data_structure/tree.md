# tree


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [tree](#tree)
    - [概述](#概述)
      - [1.tree](#1tree)
        - [(1) 特性](#1-特性)
        - [(2) 基本概念](#2-基本概念)
        - [(3) 指标](#3-指标)

<!-- /code_chunk_output -->

### 概述

#### 1.tree 

##### (1) 特性 

* 是特殊的图
    * vertex (节点)
    * edge (边)
* 指定任何一个节点v为根，则称为rooted tree (有根树)
    * 任何一个节点v与根之间存在**唯一路径**
* 半线性
    * v的祖先若存在，则必然唯一
    * v的后代若存在，则不一定唯一
* 将vector和list优势结合
    * vector 查找效率高，移动（插入、删除等）效率低
    * list 查找效率低，移动（插入、删除等）效率高

##### (2) 基本概念

* root
* child
* sibling
* parent
* degree

##### (3) 指标

* depth