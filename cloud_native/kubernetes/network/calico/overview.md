# overview

[toc]

### 概述

#### 1.相关api group

* `operator.tigera.io/v1`
  * 用于配置calico operator

* `crd.projectcalico.org/v1`
  * 用于配置calico（不要直接修改，修改operator的配置，会自动修改）

* `projectcalico.org/v3`
  * 用于配置calico（通过calicoctl修改）


#### 2.架构
![](./imgs/overview_01.png)

##### （1）管理组件
* kube-controllers
  * 监听kubernetes api，调度calico相关的pod

* Typha
  * 类似于缓存，会与clico的数据库建立连接，然后其他组件通过typha读取相关数据

##### （2）calico-node pod中的组件

* flelix
  * 网卡管理
  * 路由管理
  * ACL管理
  * 状态汇报

* BIRD（bird internet routing daemon）
  * 分发路由条目到BGP peer
  * 配置BGP route reflector

* conf（configuration management system）
  * 负责监听calico的数据库，当发生变化，更新BIRD相关的配置文件

##### （3）API相关组件
* CNI plugin
* Datastore plugin
* IPAM plugin

##### （4）其他组件
* Dikastes
  * 用于再istio中配置网络策略
