[toc]
### 基础概念
#### 1.istio主要功能
* 连接（connect）			
>连接各个微服务  
* 安全（secure）			
> 包括数据安全等  
* 控制（control）			
> 包括证书下发等  
* 观察（observer）			
> 监控微服务的状态  

#### 2.sidecar
sidecar方式就是把一个微服务和一个proxy部署在一起
#### 3.两个层面
（1）数据层面
  由一组以 sidecar 方式部署的智能代理（Envoy）组成

（2）控制平面
  管控所有服务代理之间的路由方式  
#### 4.组件
（1）envoy
  高性能proxy，四层和七层转发器
  sidecar方式部署	  

（2）mixer
  监控和路由策略管理

（3）pilot
  配置规则到Envoy

（4）citadel
  安全相关，比如下发证书等

（5）galley
  对用户规则，平台规则(k8s等)进行检测

#### 5.相关资源（CRD,CustomeResourceDefine）
（1）GateWay
  提供外部服务的访问接入和内部服务需要访问外部的出口
  用于匹配流量
>GateWay和VirualService是绑定的  
>这两个加起来就相当于k8s中的Ingress  

（2）VirtualService（需要与某个GateWay绑定）
  最核心的配置接口，定义指定服务的所有路由规则
  用于路由匹配到的流量到某个具体的服务

（3）DestinationRule
  设置目标服务的策略（负载均衡设置等）
  用于路由流量到某个具体的pod
> 类似于k8s中的service  

（4）ServiceEntry
  将外部服务接入到服务注册表中（比如使得内部服务能够访问外网）
> 类似于k8s中的ExternalName  

***
### 在k8s上的应用

#### 1.与k8s对应关系
  service    	---		service
  |
  |- instance	---		endpoint
  |
  |- version	---		deployment

#### 2.会在每个pod内注入一个envoy代理（即sidecar部署方式）
***
### envoy

#### 1.四个概念
（1）listener
  设置监听的端口，用于接收请求

（2）routes
  将请求转发到后端的cluster

（3）cluster
  定义后端的cluster

（4）endpoints
  指定cluster的访问点  
***
### pilot
#### 1.功能
  服务发现（获取k8s中service的规则，从而生成规则到envoy中）
  服务配置

#### 2.pilot服务发现机制的adapter机制
  用于对接相应平台（比如k8s），从而实现服务的发现
***
### Gateway
#### 1.有两个Gateway

（1）ingress gateway
  控制外部服务访问网格内服务，配合GateWay+VirtualService使用

（2）egress gateway
  控制网格内服务访问外部服务，配合GateWay+VirtualService+ServiceEntry使用

#### 2.Gateway与Ingress区别
（1）Ingress只支持7层负载均衡，功能单一
（2）Gateway支持L4-L6负责均衡，支持故障注入、流量转移等
