# admission（准入）

[toc]

### 概述

[参考文档](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

#### 1.admission controller（准入控制器）
准入控制器是一段代码，在请求通过认证和授权之后，在对象持久化之前，拦截到达apiserver的请求

#### 2.准入控制分为两个阶段

大部分准入控制器都包含了这两个阶段，比如：LimitRanger准入控制器

##### （1）变更（mutating）阶段
用于更改请求（比如：LimitRanger准入控制器，如果容器未设置litmits时，会帮其设置litmits）

##### （2）验证（validating）阶段
用于验证请求是否符合要求（比如：LimitRanger准入控制器，会验证容器是否设置了litmis，如果未设置，则拒绝请求）

#### 3.查看默认启用的准入控制器
```shell
kube-apiserver -h | grep enable-admission-plugins
```

#### 4.常见准入控制器

* NamespaceLifecycle
  * 禁止在一个正在被终止的 Namespace 中创建新对象
  * 禁止删除三个系统保留的名字空间，即 default、 kube-system 和 kube-public

* NodeRestriction
  * 限制了 kubelet 只能修改该节点的 Node 和 Pod 对象
