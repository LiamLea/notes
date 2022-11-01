# DestinationRule（本质就是envoy的cluster）

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [DestinationRule（本质就是envoy的cluster）](#destinationrule本质就是envoy的cluster)
    - [概述](#概述)
      - [1.功能：根据策略负载流量到endpoints](#1功能根据策略负载流量到endpoints)
    - [使用](#使用)
      - [1.清单文件格式](#1清单文件格式)

<!-- /code_chunk_output -->

### 概述

#### 1.功能：根据策略负载流量到endpoints
* 将一个service下的endpoint划分为多个subset
* 负载流量到subset（可选的负载策略比较多）
* 根据endpoint的labels，将一个service下的endpoint划分成多个subset
  * istio对envoy的cluster的命名方式：`<DIRECTION>|<PORT>|<SUBSET>|<SERVICE_FQDN>`
  * 如果cluster已存在，则修改，如果不存在，则添加

***

### 使用

#### 1.清单文件格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: xx
spec:

  #service registry中的service（包含k8s中的service）
  host: xx     

  #配置全局转发策略      
  trafficPolicy:
    loadBalancer:
      #还有ROUND_ROBIN，LEAST_CONN和PASSTHROUGH
      simple: RANDOM  	

  #根据endpoint的labels进行分类
  #这里一共分了三个subset，利用version这个标签
  #名为v1的subset，包含有version=v1标签的pods的endpoints   
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
