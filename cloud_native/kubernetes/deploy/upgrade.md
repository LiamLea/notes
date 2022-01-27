# upgrade

[toc]

### 概述

#### 1.版本控制：semantic versioning

[参考](https://semver.org/)

##### （1）版本号命名规则：`<major>.<minor>.<patch>`
* major version: 当进行了不兼容的public api更改
* minor version: 增加了public api 或 相关public api被弃用，并向后兼容（即能够兼容以前的版本）
* patch version: bug修复，并向后兼容

##### （2）预发布版本：`<major>.<minor>.<patch>-<pre-release>`
* 比如：`1.0.0-alpha`, `1.0.0-alpha.1`, `1.0.0-0.3.7`, `1.0.0-x.7.z.92`, `1.0.0-x-y-z.–`
* 预发布版本**不稳定**

##### （3）build medata：`<...>+<build_metadata>`
* 比如：`1.0.0-alpha+001`, `1.0.0+20130313144700`, `1.0.0-beta+exp.sha.5114f85`

#### 2.k8s版本管理

[参考](https://github.com/kubernetes/sig-release/blob/master/release-engineering/versioning.md)

##### （1）版本更新顺序:
  * `X.Y.0-{alpha,beta}.W` (Branch: master)
  * `X.Y.Z-rc.W` (Branch: release-X.Y)
    * rc: release candidate
  * `X.Y.Z` (Branch: release-X.Y)

##### （2）version skew
[参考](https://kubernetes.io/releases/version-skew-policy/)
比如在一个k8s集群中，最新的apiserver版本是1.22，那么其他的apiserver的版本只能是1.21或1.22，最多只能差一个minor version
* 目的：能够实现k8s的**滚动升级**
  * 所以，升级时，不能跨越多个minor version


#### 3.升级后的影响
* 所有pods都会重启，因为container spec的hash值变了
* 一些API会被弃用
  * [弃用api查询](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)

#### 4.升级的主要步骤

* 升级控制平面
  * etcd (all instances)
  * kube-apiserver (all control plane hosts)
  * kube-controller-manager
  * kube-scheduler
* 升级其他节点
* 升级客户端kubectl
* 根据新版本的API变化，调整manifests和其他资源

***

### upgrade

[参考](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

#### 1.准备
* 阅读changelogs，需要知道更新后，会有哪些影响
* 备份重要数据（etcd等）


#### 2.升级其中一个master

##### （1）安装指定版本的kubeadm

##### （2）升级该master
```shell
##kubeadm config images list --kubernetes-version=<kubeadm-version>
##可以先拉取镜像

#查看可升级的版本
kubeadm upgrade plan
```
