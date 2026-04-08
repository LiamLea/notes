# Authentication（认证）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [Authentication（认证）](#authentication认证)
    - [概述](#概述)
      - [1.两类用户](#1两类用户)
      - [2.认证方式](#2认证方式)
        - [（1）x509证书认证](#1x509证书认证)
        - [（2）请求头携带token](#2请求头携带token)

<!-- /code_chunk_output -->

### 概述

[参考文档](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)

#### 1.两类用户

|类型|用途|创建方式|认证方式|
|-|-|-|-|
|normal user|用户访问使用的账号|k8s没有相应的资源来管理normal user（即不能通过相关api创建user）|需要 用k8s的CA签署的证书（CN=用户名或者O=组名）进行认证|
|serviceaccount|内部服务访问使用的账号|可用用过k8s资源管理|通过token（存放在secret中）进行认证|

#### 2.认证方式

##### （1）x509证书认证
用k8s的证书签署的证书，且CN=用户名或者O=组名（可以有多个O），来进行验证

##### （2）请求头携带token
```shell
Authorization: Bearer 31ada4fd-adec-460c-809a-9e56ceb75269
```
