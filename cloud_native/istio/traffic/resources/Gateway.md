# Gateway（本质跟nginx-ingress一样）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [Gateway（本质跟nginx-ingress一样）](#gateway本质跟nginx-ingress一样)
    - [概述](#概述)
      - [1.功能：通过对外暴露一个proxy，管理进入和外出流量](#1功能通过对外暴露一个proxy管理进入和外出流量)
      - [2.与k8s中Ingress比较](#2与k8s中ingress比较)
    - [使用](#使用)
      - [1.资源清单](#1资源清单)

<!-- /code_chunk_output -->

### 概述

#### 1.功能：通过对外暴露一个proxy，管理进入和外出流量
* 需要在VirtualService中绑定指定的GateWay后，允许进入的流量，才能被相应规则路由
* 需要 **外部流量访问ingressgateway这个pod**，才能实现控制

#### 2.与k8s中Ingress比较
* ingress创建后会自动注入配置到ingress controller中
* GateWay相当于自动注入配置到ingressgateway(pod)中

***

### 使用

#### 1.资源清单
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
