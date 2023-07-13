# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.access control](#1access-control)

<!-- /code_chunk_output -->

### 概述

[参考](https://kubernetes.io/docs/concepts/security/controlling-access/)

#### 1.access control
![](./imgs/overview_01.png)

* authentication
  * 认证用户身份
* authorization
  * 给用户授权（RBAC）
* admission_control
  * 能改 **修改** 或者 **拒绝** 请求
