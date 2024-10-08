# VirtualService（本质就是envoy的filter）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [VirtualService（本质就是envoy的filter）](#virtualservice本质就是envoy的filter)
    - [概述](#概述)
      - [1. 功能: 路由流量](#1-功能-路由流量)
    - [使用](#使用)
      - [1.清单文件](#1清单文件)
        - [(1) match rule](#1-match-rule)
        - [(2) destination设置](#2-destination设置)
        - [(3) 路由http流量](#3-路由http流量)

<!-- /code_chunk_output -->

### 概述

#### 1. 功能: 路由流量
* 匹配流量
  * 可以匹配七层和四层的流量
  * 可以匹配从指定gateways进来的流量
  * 遵循匹配即停止的规则
* 路由到相应的DestinationRule（即envoy中的cluster）

***

### 使用

#### 1.清单文件

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: xx
spec:
  hosts:
  - xx              #匹配目标地址（建议使用 short name并部署在相应的namespace中）
                    #对于http：
                    #   会配置virtualhosts，如果能匹配到相应的virtualhosts，则会修改virtualhosts，如果匹配不到，则默认在80的路由规则中添加virtualhosts）
                    #   两种方式：short name（会根据所在的namespace，自动生成完整的域名） 或者 完整的域名，这样才能够使得路由规则应用到相关的service上
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

##### (1) match rule
* 可以根据source pods的labels进行匹配流量
  * `sourceLabels`

##### (2) destination设置
* 即指定路由到envoy的哪个cluster: `<DIRECTION>|<PORT>|<SUBSET>|<SERVICE_FDQN>`
  * `<DIRECTION>: outbound`，因为对于当前服务，访问其他cluster是出站流量
  * `<PORT>: 指定的port（若未设置则使用service使用的port）`
  * `<SUBSET>: 指定的subset（若未指定则为空）`
  * `<SERVICE_FQDN>: 根据指定的host生成（如果host是short name会自动填充成FQDN`
```yaml
- destination:
    #所以这里一般填servie名称
    host: reviews
    port:
      number: 8088
    subset: v2
```

##### (3) 路由http流量

* 匹配http流量

（建议在生成环境中使用 完整域名（这样对部署的namespace就没有要求了）
```yaml
#每条规则可以设置相关匹配条件（也可以不设置）
- match:
  - headers:
      end-user:
        exact: jason

  route:
  #设置destination
  - destination:
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
