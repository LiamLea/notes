# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [Prerequisites](#prerequisites)
      - [1.sidecar模式](#1sidecar模式)
      - [2.service mesh](#2service-mesh)
    - [概述](#概述)
      - [1.Architecture](#1architecture)
        - [（1）envoy](#1envoy)
        - [（2）istiod](#2istiod)
        - [（3）监控体系架构说明](#3监控体系架构说明)
      - [2.istio中的基本概念](#2istio中的基本概念)
      - [3.integrations](#3integrations)
        - [（1）jaeger（zipkin）](#1jaegerzipkin)
        - [（2）kiali](#2kiali)
        - [（3）prometheus](#3prometheus)
    - [使用](#使用)
      - [1.工作原理](#1工作原理)
      - [2.支持转发的流量](#2支持转发的流量)
        - [（1）自动识别协议](#1自动识别协议)
        - [（2）明确指定协议（server first protocol需要明确指定）](#2明确指定协议server-first-protocol需要明确指定)
      - [3.使用注意事项（非常重要）](#3使用注意事项非常重要)
        - [（1）pod的要求](#1pod的要求)
        - [（2）被istio使用的端口](#2被istio使用的端口)
        - [（3）server first protocol](#3server-first-protocol)
      - [4.以sidecar形式注入到pod中](#4以sidecar形式注入到pod中)
        - [（1）限制](#1限制)
        - [（2）会对健康检查进行修改](#2会对健康检查进行修改)

<!-- /code_chunk_output -->

### Prerequisites

#### 1.sidecar模式
边车部署模式，一个单节点有两个容器组成，一个是应用容器，一个是配件容器，配件容器**共享**应用容器的**资源**和**生命周期**，即配件容器不能单独存活
* 这里指的是把一个**微服务**和一个**proxy**部署在一起  

#### 2.service mesh

* 定义
  * 一个service mesh是一个可配置的**infrastructure layer**，能够处理在此mesh中所有服务之间的通信（包括进入和外出的）
* 实现方式
  * sidecar proxy

***

### 概述

#### 1.Architecture
![](./imgs/overview_01.png)

##### （1）envoy
* 包含下面组件：
  * envoy
  * pilot-agent（也叫istio agent, 用于envoy连接istiod）
* 启动envoy时，会设置iptables，将所有进入流量转到15006端口，所有外出流量转到15001端口
  * 所有流量进出pod之前，都需要经过envoy

##### （2）istiod
* service discovery（pilot）
* configuration（galley）
* certificate management（citadel）
  * Istiod acts as a Certificate Authority (CA) and generates certificates to allow secure mTLS communication in the data plane.

##### （3）监控体系架构说明
* istiod本身不存储任何数据
* 配置provider后，数据会推送到相应的provider
  * metrics（包括服务间的调用关系） 存储在prometheus中，由于不是主动推送的，而是prometheus主动拉取的，所以prometheus provider不需要配置
  * tracing 通过zipkin等接口进行存储，需要配置tracing provider，将数据推送到此接口
  * log 默认provider为envoy，即打印到/dev/stdout
* 监控展示(kiali)
  * 需要配置相应的provider地址，才能展示数据
  * metric 需要配置prometheus地址，才能获取metric数据进行展示
  * tracing 需要配置tracing provider地址，才能获取tracing数据进行展示

#### 2.istio中的基本概念

|envoy中|k8s中|
|-|-|
|application|属于同一个application: 同一个ns下，有相同`app`标签的pods的controller </br> application名称就是`app`标签的值 </br> application由workload（即controller）组成|
|workload|controller（比如:deployment等）|
|workload instance|pod|
|endpoint|是endpoints中的一个个endpoint，每个endpoint还会关联pod的相关信息（比如：labels等，所以可以理解为一个endpoint就是一个pod）|
|service|service|

#### 3.integrations

##### （1）jaeger（zipkin）
默认使用的就是jaeger

##### （2）kiali

##### （3）prometheus

***

### 使用

#### 1.工作原理
* 启动envoy之前，都会先设置**iptables**
* 将所有 **进入流量** 转到envoy的 **15006** 端口
  * 会利用 元数据（原始的目标地址、协议等信息），来匹配最佳的filter chain，进行处理
* 将所有 **外出流量** 转到envoy的 **15001** 端口
  * 设置了`"use_original_dst": true`
    * 会根据原始的目标地址，将该流量转到与之匹配的listener上
      * 发往："1.1.1.1:9080"，
      * 如果存在"1.1.1.1:9080"这个listener，则会匹配这个listener，不存在的话继续，
      * 如果存在"0.0.0.0:9080"这个listener（0.0.0.0表示匹配所有），则会匹配这个listener
    * 如果没有匹配的，则将流量发送到15001这个listener指定的cluster上（即PassthroughCluster）

#### 2.支持转发的流量

* 支持转发所有TCP的流量
* 不支持转发非TCP的流量（比如UDP），即istio proxy不会拦截该流量（即该流量不经过istio proxy）

##### （1）自动识别协议
* 注意：
  * server first protocol与此种方式不兼容，所以必须明确指定协议（比如：TCP、Mysql等）
* istio能够自动识别的协议：http
* 如果无法识别协议，则认为是纯TCP流量


##### （2）明确指定协议（server first protocol需要明确指定）
* 两种方式
  * 通过端口的名称：`svc.spec.ports.name: <protocol>[-<suffix>]`
  * 通过字段明确指定：`svc.spec.ports.appProtocol: <protocol>`

#### 3.使用注意事项（非常重要）

##### （1）pod的要求

* 必须与service关联 （因为外出流量必须访问service，不能直接访问pod）
  * 当与多个service关联时，同一个端口不能使用多种协议
  * 直接访问pod，envoy无法找到相关listener，所以就会变为passthrough状态
* uid`1337`必须预留
  * 应用不能使用`1337`这个uid运行，这个是个sidecar proxy使用的
* NET_ADMIN 、NET_RAW 能力 或者 使用istio cni插件
  * 当需要用到security功能时，需要具备以上的条件
* 设置标签（不是必须）：
  * `app: <app>`
  * `version: <version>`
  * 这样采集的指标能够包含这些信息
* service port使用的协议是server first protocol，必须明确指定协议（比如：TCP）
* 不能设置` hostNetwork: true`
  * 自动注入sidecar会忽略这种pod

##### （2）被istio使用的端口
[参考](https://istio.io/latest/docs/ops/deployment/requirements/)

##### （3）server first protocol
* 由server发送第一个字节，会影响 PERMISSIVE mTLS 和 协议自动识别
* 常见的server first protocol:
  * SMTP
  * DNS
  * MySQL
  * MongoDB

#### 4.以sidecar形式注入到pod中

利用admission controller实现注入的

##### （1）限制
* 不能注入到kube-system和kube-public这两个命名空间
* pod不能设置` hostNetwork: true`

##### （2）会对健康检查进行修改
因为http和tcp健康检查是kubelet发送健康检查请求到相应的pod，如果加上了sidecar，
如果进行http检查，且开启了mTLS，kubelet无法知道证书，所以会失败
如果进行tcp检查，因为sidecar进行转发，所以不管目标容器有没有开启这个端口，一定会成功
* 对exec检查不修改
* 对httpGet和tcpSocket进行修改
  * 修改前
  ```yaml
  tcpSocket:
    port: 8001

  #或者

  httpGet:
    path: /foo
    port: 8001
  ```
  * 修改后
  ```yaml
  httpGet:
    path: /app-health/<container_name>/livez
    port: 15020
    scheme: HTTP
  ```
