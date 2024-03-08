# PCA (principal component analysis)


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [PCA (principal component analysis)](#pca-principal-component-analysis)
    - [概述](#概述)
      - [1.算法](#1算法)

<!-- /code_chunk_output -->


### 概述

#### 1.算法

* 减少特征数，用于 数据可视化
    * 预处理: normalized to have zero mean
    * 大量的特征 --映射--> 少量的特征（转换后的特征叫 principal component）
        * 尽量**保持variance不减少**