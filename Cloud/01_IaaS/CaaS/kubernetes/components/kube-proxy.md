# kube-proxy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kube-proxy](#kube-proxy)
    - [概述](#概述)
      - [1.在iptables中相关的chain](#1在iptables中相关的chain)
      - [2.chain的顺序](#2chain的顺序)
    - [配置](#配置)
      - [1.常用配置](#1常用配置)

<!-- /code_chunk_output -->

### 概述

#### 1.在iptables中相关的chain

|chain|description|
|-|-|
|KUBE-SERVICES|用于匹配service的ip|
|KUBE-NODEPORTS|用于匹配nodeport|
|KUBE-SVC|用于关联多个KUBE-SEP，这样就能实现负载|
|KUBE-SEP|用于匹配service enpoint（即pod的ip）|
|KUBE-POSTROUTING|会对包进行标记（0x4000/0x4000）|
|KUBE-POSTROUTING|对被标记的包进行SNAT|

#### 2.chain的顺序
通过`iptables-save`中的nat表进行分析

* 首先匹配KUBE-SERVICES这个chain
  * `KUBE-SERVICES -> KUBE-SVC -> KUBE-SEP`
* 然后匹配KUBE-NODEPORTS这个chain
  * `KUBE-NODEPORTS -> KUBE-SVC -> KUBE-SEP`
* 最后匹配KUBE-SEP这个chain

***

### 配置

[参考](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)

#### 1.常用配置

```shell
#设置pod的cidr，这个不会影响pod的地址（影响pod的地址的是网络插件）
#但是这个会影响iptables的相关配置，所以网络插件设置的pod的cidr必须和这里一致
#traffic sent to a Service cluster IP from outside this range will be masqueraded and traffic sent from pods to an external LoadBalancer IP will be directed to the respective cluster IP instead
--cluster-cidr
```
