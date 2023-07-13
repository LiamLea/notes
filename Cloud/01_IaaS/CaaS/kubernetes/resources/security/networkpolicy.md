# networkpolicy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [networkpolicy](#networkpolicy)
    - [概述](#概述)
      - [1.networkpolicy](#1networkpolicy)
      - [2.前提](#2前提)
    - [使用](#使用)
      - [1.设置默认规则（如果不设置，默认都允许所有流量）](#1设置默认规则如果不设置默认都允许所有流量)
        - [（1）某个namespace默认拒绝所有流量](#1某个namespace默认拒绝所有流量)
        - [（2）某个namespace默认允许所有流量](#2某个namespace默认允许所有流量)

<!-- /code_chunk_output -->

### 概述

#### 1.networkpolicy
在ip地址和pod级别，控制流量安全

#### 2.前提
需要CNI插件的支持：[参考](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)

***

### 使用

注意：当设置了规则，默认就会变为禁止所有
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: <name>
  namespace: <namespace>    #在该namespace下生效
spec:
  podSelector: <selector>   #空表示匹配所有pods

  #对进入流量进行限制（为空表示，阻止所有流量）
  ingress:
  - from:

    #匹配来源ip
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
          - 172.17.1.0/24

    #匹配来自指定namespace的流量
    - namespaceSelector:
        matchLabels:
          project: myproject

    #匹配来自指定pod的流量
    - podSelector:
        matchLabels:
          role: frontend

    ports:            #如果为空匹配所有port
    - protocol: TCP
      port: 6379

  #对外出流量进行限制（为空表示，阻止所有流量）
  egress:
    - to:
        - ipBlock:
            cidr: 10.0.0.0/24
      ports:
        - protocol: TCP
          port: 5978
```

#### 1.设置默认规则（如果不设置，默认都允许所有流量）

##### （1）某个namespace默认拒绝所有流量
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

##### （2）某个namespace默认允许所有流量
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-ingress
spec:
  podSelector: {}
  ingress:
  - {}
  policyTypes:
  - Ingress
```
