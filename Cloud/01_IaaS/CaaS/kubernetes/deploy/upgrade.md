# upgrade

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [upgrade](#upgrade)
    - [概述](#概述)
      - [1.版本控制：semantic versioning](#1版本控制semantic-versioning)
        - [（1）版本号命名规则：`<major>.<minor>.<patch>`](#1版本号命名规则majorminorpatch)
        - [（2）预发布版本：`<major>.<minor>.<patch>-<pre-release>`](#2预发布版本majorminorpatch-pre-release)
        - [（3）build medata：`<...>+<build_metadata>`](#3build-medatabuild_metadata)
      - [2.k8s版本管理](#2k8s版本管理)
        - [（1）版本更新顺序:](#1版本更新顺序)
        - [（2）version skew](#2version-skew)
      - [3.升级需要考虑的方面](#3升级需要考虑的方面)
        - [（1）API的改变（需要特别关注）](#1api的改变需要特别关注)
        - [（2）相关功能的改变](#2相关功能的改变)
      - [4.升级前先预演](#4升级前先预演)
        - [（1）移除升级后不存在的API](#1移除升级后不存在的api)
      - [5.升级后的影响](#5升级后的影响)
      - [6.升级的主要步骤](#6升级的主要步骤)
    - [upgrade](#upgrade-1)
      - [1.准备](#1准备)
      - [2.升级前预演API移除](#2升级前预演api移除)
      - [3.升级其中一个master](#3升级其中一个master)
        - [（1）升级该master](#1升级该master)
        - [（2）升级calico](#2升级calico)
      - [4.升级其他master](#4升级其他master)
        - [（1）升级该master](#1升级该master-1)
      - [5.升级master的kubelet和kubectl](#5升级master的kubelet和kubectl)
        - [（1）升级kubelet](#1升级kubelet)
        - [（2）安装指定版本的kubectl](#2安装指定版本的kubectl)
      - [6.升级node](#6升级node)
        - [（1）升级该node](#1升级该node)
        - [（2）升级kubelet](#2升级kubelet)
    - [API Migration](#api-migration)
      - [1.Served Version vs. Storage Version](#1served-version-vs-storage-version)
      - [2.The "Two-Release" Rule](#2the-two-release-rule)
      - [3.The Risk: The "Hidden" Legacy Data](#3the-risk-the-hidden-legacy-data)
        - [(1) Use the "Storage Version Migrator" (The Pro Way)](#1-use-the-storage-version-migrator-the-pro-way)
        - [(2) The Manual "Update All"](#2-the-manual-update-all)
      - [4.Pay attention to versions](#4pay-attention-to-versions)
        - [(1) feature-gates](#1-feature-gates)

<!-- /code_chunk_output -->

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

#### 3.升级需要考虑的方面

##### （1）API的改变（需要特别关注）

升级到某一个k8s版本后，API也会升级，会出现新的API代替旧的API：
  * 稳定（GA，general availability）的API（即版本不是alpha或者beta的API），是最终版本的API，通常不会被替换（除非有更新的稳定版）
  * 旧的API（比如一些alpha和beta版本的API），会被 **deprecated（弃用）**，最终在某一个版本被 **removed（移除）**，在被移除之前，这些API还能够被使用
    * [弃用api查询](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)
* API升级，意味着这个资源的有些字段可能不一样了（即旧的yaml文件可能用不了），需要阅读changelogs

##### （2）相关功能的改变
* 比如1.20不支持传递selflink，如果有些应用依赖selfLink才能工作，就会有问题

#### 4.升级前先预演

##### （1）移除升级后不存在的API
通过修改api server的配置，将升级后会被移除的API，先关闭掉，就能看出升级后的效果

#### 5.升级后的影响
* 所有pods都会重启，因为container spec的hash值变了
* 重新生成证书
  * 可以不重新生成：`kubeadm upgrade ... --certificate-renewal=false`

#### 6.升级的主要步骤

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
* 阅读[changelogs](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG)，需要知道更新后，会有哪些影响
  * 主要关注（比如）：`v1.22.0 / What’s New 和  Changes by Kind`
* 备份重要数据（etcd等）

#### 2.升级前预演API移除
根据阅读changelogs的结果，知道了哪些API会被移除，预演一下这些API被移除后的修改
* 修改api server的配置
```shell
#将相关的API关闭（就相当于移除）
#比如升级到1.22之间测试以下，因为1.22将移除下列api
--runtime-config=admissionregistration.k8s.io/v1beta1=false,apiextensions.k8s.io/v1beta1=false,apiregistration.k8s.io/v1beta1=false,authentication.k8s.io/v1beta1=false,authorization.k8s.io/v1beta1=false,certificates.k8s.io/v1beta1=false,coordination.k8s.io/v1beta1=false,extensions/v1beta1=false,networking.k8s.io/v1beta1=false
```

#### 3.升级其中一个master

##### （1）升级该master

* 安装指定版本的kubeadm
  * 建议同时安装kubelet和kubectl（否则可能会自动升级kubelet和kubectl到最新版）

* 查看升级信息（**很重要**）：
  * 可升级的k8s版本
  * 哪些组件需要手动升级（比如：kubelet、kubectl）

```shell
kubeadm upgrade plan
```

* 进行升级
```shell
kubeadm upgrade apply <version>
```

##### （2）升级calico
[参考](https://projectcalico.docs.tigera.io/maintenance/kubernetes-upgrade)

#### 4.升级其他master

##### （1）升级该master
* 安装指定版本的kubeadm
  * 建议同时安装kubelet和kubectl（否则可能会自动升级kubelet和kubectl到最新版）

* 进行升级
```shell
kubeadm upgrade node
```

#### 5.升级master的kubelet和kubectl

##### （1）升级kubelet
* 将该node置于维护状态
```shell
kubectl drain <cp-node-name> --ignore-daemonsets
```
* 安装指定版本的kubelet
* 重启kubelet
```shell
systemctl daemon-reload
systemctl restart kubelet
```
* 将该node置于可用状态
```shell
kubectl uncordon <cp-node-name>
```

##### （2）安装指定版本的kubectl

#### 6.升级node

##### （1）升级该node
* 安装指定版本的kubeadm
  * 建议同时安装kubelet和kubectl（否则可能会自动升级kubelet和kubectl到最新版）

* 进行升级
```shell
kubeadm upgrade node
```

##### （2）升级kubelet
* 将该node置于维护状态
```shell
kubectl drain <cp-node-name> --ignore-daemonsets
```
* 按照指定版本的kubelet
* 重启kubelet
```shell
systemctl daemon-reload
systemctl restart kubelet
```
* 将该node置于可用状态
```shell
kubectl uncordon <cp-node-name>
```

***

### API Migration

#### 1.Served Version vs. Storage Version

* Served Version (v1): This is the "User Interface." Since the feature is GA in v1.33, the API server accepts v1 requests.
* Storage Version (v1beta1): This is the "Database Schema." Even if you send a v1 object, the API server transmutes it into a v1beta1 structure before writing the bytes to etcd.

#### 2.The "Two-Release" Rule

[xRef](https://kubernetes.io/docs/reference/using-api/deprecation-policy/)

Kubernetes |Version	API Status	|Storage Version in etcd
-|-|-
v1.32	|Beta|	v1beta1
v1.33 (Current)	|GA (v1)	|v1beta1 (For compatibility)
v1.34+ (Future)	|GA (v1)	|v1 (The "Flip" happens here)

#### 3.The Risk: The "Hidden" Legacy Data

The danger arises when a legacy API is removed (no longer "served") by the API server.

If you have an object in etcd stored as v1beta1, and you upgrade to a Kubernetes version where v1beta1 is completely gone, the API server might lose the "translator" needed to understand that old data. This can lead to:

Failed Upgrades: The API server crashes because it can't decode the old data in etcd.

Ghost Objects: Resources that exist in the database but cannot be managed or deleted through the API.

##### (1) Use the "Storage Version Migrator" (The Pro Way)

[xRef](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/storage-version-migration/)

##### (2) The Manual "Update All"

```shell
kubectl annotate ingress --all migrated-on=$(date +%Y-%m-%d) --overwrite
```

#### 4.Pay attention to versions

##### (1) feature-gates
[xRef](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates)