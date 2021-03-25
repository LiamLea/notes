# API

[toc]

### 预备知识

#### 1.声明式（declarative）和 命令式（imperative ）
* 声明式api
告诉服务器我想要的状态，然后服务器自己决定怎么做

* 命令式api
告诉服务器具体怎么做

***

### 概述

![](./imgs/api_01.png)

#### 1.在top-level分类

##### （1）核心组
* 由于历史原因，核心组没有按照`/apis/<GROUP_NAME>/<VERSION>`这样的格式
`/api/v1`

##### （2）命名组
`/apis/<GROUP_NAME>/<VERSION>`

##### （3）系统范围的实体
比如：`/metrics`


#### 2.有三类api version

##### （1）alpha
未来可能丢弃这个api（比如`v1alpha1`）

##### （2）beta
该api在测试阶段，未来可能发生改变（比如`v2beta3`）

##### （3）stable
该api是稳定的（比如`v1`）

#### 3.扩展api的两种方式

##### （1）通过CRD、operator
[参考](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
* 通过CRD定义custome resource，即能够在etcd中存储和提取指定结构的数据
* custome controllers能够根据这些数据，从而进行某些操作
* 通过operator将custome resource和custome controllers结合起来

##### （2） API Aggregation
需要使用自己的api server，将自定义的api发送到这个api server（比如metrics-server就是这种方式）
```shell
kubectl get apiservice xx
#可以查看metrics-server，就是将api发送到指定的api server
```
```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  service:
    name: metrics-server
    namespace: kube-system
    port: 443
  version: v1beta1
  versionPriority: 100
```

***

### 扩展api

#### 1.自定义一个api（CRD）
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
