# ServiceEntry

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ServiceEntry](#serviceentry)
    - [概述](#概述)
      - [1.与k8s service比较](#1与k8s-service比较)
    - [使用](#使用)

<!-- /code_chunk_output -->

### 概述

#### 1.与k8s service比较

* k8s service能够提供域名解析，并且istio能够根据这个service自动生成ServiceEntry
* 当使用ip访问外部时，k8s service就没用了，而ServiceEntry是可以关联ip的

***

### 使用
