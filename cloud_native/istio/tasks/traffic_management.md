# traffic management

[toc]

### 概述

#### 1.service registry
* 通过调用k8s接口，发现services和endpoints
  * 填充service registry
  * 后续需要利用service registry的信息去配置envoy

* 也可以通过ServiceEntry在service registry中添加静态的条目

#### 2.数据处理流程
VirtualService需要通过hosts这个配置关联k8s的services（本质通过配置的hosts去查找该名字的virtualhosts，如果找到了，则修改，找不到则在80路由规则中添加）
VirtualService用于将流量路由到指定DestinationRule
* 如果没有匹配到VirtualService的流量，则正常处理（即发送到指定service进行负载）
DestinationRule用于对service进行分组
gateways to control ingress and egress traffic.

***

### 使用

#### 1. VirtualService（本质是配置envoy的filter）
* 路由流量
  * 匹配流量
    * 可以匹配七层和四层的流量
    * 可以匹配从指定gateways进来的流量
    * 遵循匹配即停止的规则
  * 路由到相应的DestinationRule（即service集）

##### （1）清单文件格式

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: xx
spec:
  hosts:
  - xx              #匹配目标地址（建议：填service名称并且部署到对应的namespace中，因为默认会对这个service名称补全，否则就要写全的域名）
                    #对于http：
                    #   会配置virtualhosts，如果能匹配到相应的virtualhosts，则会修改virtualhosts，如果匹配不到，则默认在80的路由规则中添加virtualhosts）
                    #   所以一般使用service名称并且部署在其命名空间中 或者 使用 完整的域名，这样才能够使得路由规则应用到相关的service上
                    #   当其他VirtualService使用同样的hosts不会生效（只有第一个生效）
                    # '*' 匹配所有目标地址（用于tcp路由）

  #如果要路由外部进来的流量，这里就需要指定gateways
  #添加这个选项后，既会路由指定的外部流量，也会路由内部流量
  gateways:
  - xx              #这里填GateWay的名字

  #配置tcp路由规则（好像要配合gateway一起使用，才能在envoy的listener产生配置，待确认）
  tcp: []

  #配置http路由规则（包括HTTP/1.1, HTTP2, gRPC）
  http: []          

  #配置tls路由规则
  tls: []
```

##### （2）路由http流量

* 匹配http流量
```yaml
#每条规则可以设置相关匹配条件（也可以不设置）
- match:
  - headers:
      end-user:
        exact: jason

  route:
  #设置destination，指向一个地址
  - destination:
      #这里可以填ip，或service的域名，或能够解析的域名
      host: reviews
      port:
        number: 8088
      subset: v2
```

* 设置多个destination

```yaml
- route:
  - destination:
      host: reviews
      subset: v1
    weight: 75
  - destination:
      host: reviews
      subset: v2
    weight: 25
```

***
### DestinationRule
**应用于指定的destination**
用于设置当流量达到destination后，如何分发到后端pods
#### 1.特点
* 会依据指定的若干个标签对后端pod进行分类，一个subset就是一类
* 在DestinationRule中设置分发策略，即负载均衡（比如轮询等）
* 某个subset中可以覆盖全局的分发策略
* 在VirtualService中配置了路由到哪个subset
#### 2.清单文件格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: xx
spec:

#指定应用于哪个destination（一般指service）
  host: xx     

#配置如何将流量分发到后端       
  trafficPolicy:
    loadBalancer:

#还有ROUND_ROBIN，LEAST_CONN和PASSTHROUGH
      simple: RANDOM  	

#用于对后端Pods进行分类，这里一共分了三类，利用version这个标签  
#第一类的名字是v1，有version=v1这个标签的pods属于这一类    
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
  - name: v3
    labels:
      version: v3
```
***
### GateWay
用来管理k8s集群的进入和外出流量，**与VirtualService结合使用**
#### 1.特点
* 只是允许特定流量进入k8s集群，并未指明具体的路由到何处
* 需要在VirtualService中绑定指定的GateWay后，允许进入的流量，才能被相应规则路由
#### 2.资源清单格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: xx
spec:

#指定应用于哪个ingressgateway（是一个pod）
  selector:
    app: my-gateway-controller

#设置允许进入的流量（可以允许指定客户端和协议的流量进入）
  servers:
    - hosts:
      - '*'
      port:
        name: http
        number: 80
        protocol: HTTP

```
***
### ServiceEntry
#### 1.特点
* 添加**条目**到**服务注册表**中(一般用于为**外部服务**添加)，envoy代理可以发送流量到该服务，像发送给其他内部服务一样
* 如果未为外部服务添加条目，默认则设为**unkown service**
* 一个条目就是一个服务
#### 2.清单格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: xx
spec:

#设置该条目的内容（即设置service的名称和暴露的端口）
  hosts:
  - ext-svc.example.com   #当设置了hosts就没必要设置addresses了
  addresses:
  - 192.192.192.192/24    #可以设置VIP，即访问这个地址，会路由到后端endpoints
  ports:
  - number: 443
    name: https
    protocol: HTTPS

#用于指明该服务是外部的还是内部的
  location: MESH_EXTERNAL

#设置该service代理的后端地址，这里是静态解析，即地址已经给定
#动态解析是，不用设置endponts，会根据上面的hosts的名字，解析出多个ip地址
  resolution: static
  endpoints:
  - address: 2.2.2.2
  - address: 3.3.3.3
```

### unknown 和 passthroughcluster 和 BlackHole
* 当不知道的外部流量进来时，则标识来源为**unknown**
* 当流量发往外部不知道的服务时，则标记为目的为**passthroughcluster** 或者 **blackholw**
当允许流量外出时，为**passthroughcluster**
当不允许流量外出时，为**blackhole**


### 更多流量治理（无需修改代码）
#### 1.timeout
设置envoy proxy等待响应超过这个时间，则认为超时（即失败）
在VitualService中设置，无需修改代码
#### 2.retries
设置envoy proxy尝试连接服务的最大次数
在VirualService中设置
#### 3.circuit breakers（断路器，是一种保护机制）
设置envoy proxy支持的最大并发数、最大失败次数等
当达到上限，流量暂时就不会路由到该envoy proxy
在DestinationRule中设置
#### 4.fault injection（故障注入，是一种测试机制）
可以注入两种故障：delay 和 abort
在VirtualService中设置
#### 5.failure recovery（故障恢复）
对应用来说时透明的，即不需要配置
如果应用本身设置了故障恢复，可能会和istio的故障恢复冲突
有些故障是istio无法恢复的，需要应用自己解决（比如503错误）

### 总结
* VirtualService会应用到所有的envoy中
当指定gateway时会应用到该gateway所关联的ingress envoy中
* GateWay会应用到ingress envoy(即ingressgateway这个pod)中
* DestinationRule会应用到指定envoy中（一般

与k8s中Ingress比较
* 与k8s中的Ingress资源类似
ingress创建后会自动注入配置到ingress controller中
GateWay相当于自动注入配置到ingressgateway(pod)中
