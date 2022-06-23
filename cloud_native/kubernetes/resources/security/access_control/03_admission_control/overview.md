# admission control（准入控制）

[toc]

### 概述

[参考文档](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

#### 1.admission control分为两个阶段

大部分准入控制器都包含了这两个阶段，比如：LimitRanger准入控制器

##### （1）变更阶段（Mutating Admission Webhook）
用于更改请求（比如：LimitRanger准入控制器，如果容器未设置litmits时，会帮其设置litmits）

##### （2）验证阶段（Validating Admission Webhook）
用于验证请求是否符合要求（比如：LimitRanger准入控制器，会验证容器是否设置了litmis，如果未设置，则拒绝请求）

#### 2.查看默认启用的admission controllers（admission plugins）
```shell
kube-apiserver -h | grep enable-admission-plugins
```

#### 3.常见admission controllers（admission plugins）

|admission plugins(controllers)|description|
|-|-|
|NodeRestriction|限制了某个kubelet只能管理其所在节点的 Node 和 Pod 对象|
|LimitRange|设置requests和limits|
|ResourceQuota|对指定命名空间的资源使用量进行配额|

#### 4.查看Mutating Admission Webhook 和 Validating Admission Webhook
```shell
kubectl get mutatingwebhookconfiguration
kubectl get mutatingwebhookconfiguration
```
