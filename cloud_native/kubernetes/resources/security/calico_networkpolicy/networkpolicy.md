# network policy

[toc]

### 概述

#### 1.特点
* 能够应用于endpoint（包括：pod、host interfaces）
* 能够限制 进入 和 外出 流量

#### 2.默认规则

|endpoint|没有设置policy时的默认规则|设置policy时的默认规则|
|-|-|-|
|pod endpoint|allow|deny|
|host endpoint|deny|deny|

#### 3.匹配原则
跟iptables一样
按顺序一条一条匹配（order越小，越先匹配）
* 匹配即停止匹配（但是当action为log时，不停止）
* 如果没有匹配到任何规则，则使用默认规则

***

### 使用

#### 1.NetworkPolicy
```yaml
apiVersion: projectcalico.org/v3
kind: NetworkPolicy
metadata:
  name: <name>
  namespace: <namespace>    #在该namespace下生效
spec:

  #设置该policy的优先级，数字越小，优先级越高
  order: <float>

  #选择把policy应用于哪些endpoints
  selector: <selector>   #默认为：all()，表示匹配所有endpoints
  serviceAccountSelector: <sa_selector>   #默认为：all(), 表示匹配所有sa

  #指定将规则应用于进入流量还是外出流量，不填则根据后面是否有ingress和egress配置，自动设置
  types:              
  - Ingress
  - Engress

  ingress: <rules_list>

  egress: <rules_list>
```

* rules_list
```yaml
- action: <action>    #Allow、Deny、Log、Pass

  protocol: <protocol>      #TCP, UDP, ICMP等
  #notProtocol: <protocol>
  icmp: {}
  #notICMP: {}
  http: {}

  source: {}
  destination: {}
```

#### 2.GloalNetworkPolicy

用于设置全局策略或hostendpoint策略

```yaml
apiVersion: projectcalico.org/v3
kind: NetworkPolicy
metadata:
  name: <name>
  namespace: <namespace>    #在该namespace下生效
spec:

  #下面这几个字段只对hostendpoint有意义：preDNAT、applyOnForward、doNotTrack
  #是否用于PREROUTING chain
  preDNAT: <bool | default=false>  
  #preDNAT和doNotTrack只有一个能为true
  doNotTrack: <bool | default=false>

  #当上面其中一个为true，这里必须为true
  applyOnForward: <bool | default=false>

  #其他跟NetworkPolicy一样
```
