# 扩展

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [扩展](#扩展)
    - [概述](#概述)
      - [1.custom resource](#1custom-resource)
      - [2.custom controller](#2custom-controller)
      - [3.operator](#3operator)
      - [4.Aggregation Layer](#4aggregation-layer)
      - [5.创建custom resource的两种方式](#5创建custom-resource的两种方式)
        - [（1）CRD（custom resource definition）](#1crdcustom-resource-definition)
        - [（2）API Aggregation](#2api-aggregation)
        - [（3）两种方式的比较](#3两种方式的比较)
        - [（4）查看所有注册的api](#4查看所有注册的api)
    - [使用](#使用)
      - [1.创建CRD](#1创建crd)

<!-- /code_chunk_output -->

### 概述

#### 1.custom resource
自定义资源，是对kubernetes API的一种扩展（相当于**添加新的api**）
定义数据格式，描述应用信息

#### 2.custom controller
将自定义资源和自定义控制器结合，自定义资源才能提供一个真正的声明式API
用户通过声明式API（即自定义资源）创建一个object，controller会根据用户声明式API中的信息，持续维持期望的状态

#### 3.operator
operator就是一个自定义资源的控制器
operator会watch apiserver，然后reconcile相关资源
[参考](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)

#### 4.Aggregation Layer
是apiserver中的进程
用于聚合和管理所有api（包括扩展的api）

* 开启聚合层（默认是开启的）
```shell
#apiserver需要进行以下配置
--requestheader-client-ca-file=<path to aggregator CA cert>
--requestheader-allowed-names=aggregator
--requestheader-extra-headers-prefix=X-Remote-Extra-
--requestheader-group-headers=X-Remote-Group
--requestheader-username-headers=X-Remote-User
--proxy-client-cert-file=<path to aggregator proxy cert>
--proxy-client-key-file=<path to aggregator proxy key>

#如果没有运行Kube-proxy，需要设置下面选项（即允许聚合器将请求转发到endpoint ip而不是cluster ip）
#--enable-aggregator-routing
```

#### 5.创建custom resource的两种方式

##### （1）CRD（custom resource definition）
在k8s的apiserver中注册新的api

[sample-controller](https://github.com/kubernetes/sample-controller)

##### （2）API Aggregation
部署一个 **自定义的apiserver**，自定义的apiserver 通过**APIService资源** 在**k8s的apiserver**的**聚合层（aggregation layer）** 中 **注册** 某些api，
当k8s的apiserver收到这些api的请求，会**转发**到自定义的apiserver上


##### （3）两种方式的比较

|CRD|API Aggregation|
|-|-|
|无需另外部署程序，CRD controller可以用任何语言实现|需要另外部署一个自定义的api server|
||排错更加复杂，使用更加灵活|

##### （4）查看所有注册的api
```shell
$ kubectl get apiservices

NAME                    SERVICE                     AVAILABLE   AGE
v1.                     Local                       True        183d

#Local代表是由k8s的apiserver提供的api（即通过CRD添加的api）
v1alpha1.pingcap.com    Local                       True        10d

#kube-system/metrics-server代表是外部apiserver提供的api
#外部apiserver的地址是 kube-system命名空间中的metrics-server这个service
#（即通过API Aggregation方式添加的api）
v1beta1.metrics.k8s.io  kube-system/metrics-server  True        183d

...
```

***

### 使用

#### 1.创建CRD
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: <plural>.<GROUP_NAME>   #这里必须跟下面保持一致
spec:

  #命名组api，/apis/<GROUP_NAME>/<VERSION>
  group: <GROUP_NAME>   
  version: <VERSION>    

  names:
    kind: <KIND>          #用于清单文件中指定的Kind
    plural: <plural>  #用于url访问，/apis/<GROUP_NAME>/<VERSION>/<plural>
    shortNames:
    - <shortNames>        #比如：Service可以缩写为svc
  scope: <scope>          #Namespaced或者Cluster
```
