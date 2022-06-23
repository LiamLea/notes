# ResourceQuota

[toc]

### 概述

#### 1.ResourceQuota资源
用于对指定命名空间的资源使用量进行配额

* 不会影响已经创建的资源（即使已经超出了限额）
* 超出限额
  * 如果pods超出限额，如果是通过replica这些控制器创建pods的则不会报错，只是不会创建pods
  * 如果对象数量超出限额，创建该对象时就会报错

***

### 使用

#### 1.简单使用
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: <name>
  namespace: <namespace>    #对该namespace进行配额
spec:
  hard:
    #对资源限制
    requests.cpu: 1000m     #表示该命名空间中所有的requests.cpu总和不能超过10000m
    requests.memory: 1Gi    #表示该命名空间中所有的requests.memory总和不能超过1Gi
    limits.cpu: 2000m       #表示该命名空间中所有的litmis.cpu总和不能超过2000m
    limits.memory: 3Gi      #表示该命名空间中所有的limits.memory总和不能超过2Gi

    #对对象限制
    pods: <int>             #表示该命名空间中最多能创建多少个pod
    configmaps: <init>      #表示该命名空间中最多能创建多少个configmap
    #...
```

* 查看
```shell
$ kubectl describe resourceQuota xx

Name: test-quota
Namespace: test
Resource       Used       Hard
--------       ----       ----
limits.cpu     1          2
limits.memory  2Gi        3Gi     #limits.memory Used表示test命名空间中，所有的limits.memory总和为2Gi，Hard 表示不能超过3Gi，超过了也不会报错，只是不会运行该pods（可以查看replicaset）
```
