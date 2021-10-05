# Authentication（认证）

[toc]

### 概述

[参考文档](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)

#### 1.两类用户

|类型|用途|创建方式|认证方式|
|-|-|-|-|
|normal user|用户访问使用的账号|k8s没有相应的资源来管理normal user（即不能通过相关api创建user）|需要 用k8s的CA签署的证书（CN=用户名或者O=组名）进行认证|
|serviceaccount|内部服务访问使用的账号|可用用过k8s资源管理|通过token（存放在secret中）进行认证|

#### 2.特点
* 每个namespace中都有一个默认的Secret资源，存储的是token，用于认证
* 该名称空间内的pod都会挂载该Secret，从而能够通过apiServer的认证
* ServiceAccount可以绑定docker-registry类型的secrets
从而可以指定使用其他仓库

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
