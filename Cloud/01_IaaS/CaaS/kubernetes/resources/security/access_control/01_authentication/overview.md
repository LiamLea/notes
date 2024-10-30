# Authentication（认证）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [Authentication（认证）](#authentication认证)
    - [概述](#概述)
      - [1.两类用户](#1两类用户)
      - [2.serviceaccount principle (to mount the corresponding token)](#2serviceaccount-principle-to-mount-the-corresponding-token)
      - [3.使用serviceaccount](#3使用serviceaccount)
        - [（1）创建serviceaccount](#1创建serviceaccount)
        - [（2）指定pod使用哪个账号](#2指定pod使用哪个账号)
      - [4.认证方式](#4认证方式)
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

#### 2.serviceaccount principle (to mount the corresponding token)
* every namespace has
  * a serviceaccount: `default`
  * get **token** method:
    * old (deorecated):
      * a secret correlated with the default serivceaccount: `default-token-xxxx`
      * the secret includes: 
        * **token** (the most important)
        * namespace
        * ca
    * new:
      * **kubelet** uses [TokenRequest API](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/) to request a **temporary token** for a given service account and then update it

* when a pod starts, it will mount `token, namespace and ca` on the specific directory (`/var/run/secrets/kubernetes.io/serviceaccount/`) 
  * why this directory?
    * it is **conventional** so that when developers develop a app running in the pod they know how to find the token  
* the app running in the pod can access k8s api with the token

#### 3.使用serviceaccount
##### （1）创建serviceaccount
```shell
kubectl create serviceaccount 账号名

#创建ServiceAccount资源后，会自动生成一个用于 认证 的Secret，并与该ServiceAccount绑定
```
##### （2）指定pod使用哪个账号
```shell
spec.ServiceAcountName

#pod使用指定ServiceAccount，会挂载相应的Secret
```

#### 4.认证方式

##### （1）x509证书认证
用k8s的证书签署的证书，且CN=用户名或者O=组名（可以有多个O），来进行验证

##### （2）请求头携带token
```shell
Authorization: Bearer 31ada4fd-adec-460c-809a-9e56ceb75269
```
