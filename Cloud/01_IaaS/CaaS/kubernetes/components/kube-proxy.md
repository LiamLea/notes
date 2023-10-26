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
|KUBE-SEP|用于匹配service enpoint（即pod的ip）
|KUBE-MARK-MASQ|给数据包打上MASQ(MASQUERADE)(`0x4000/0x4000`) 标记|
|KUBE-MARK-DROP|给数据包打上DROP(`0x8000/0x8000`)标记|
|KUBE-POSTROUTING|判断是不是`0x4000/0x4000`</br>如果不是则返回</br>是则对被标记的包m进行MASQUERADE（即SNAT），然后将标记改为`0x4000/0x0`|

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
#建议不设置这个参数
#这个用于设置iptables，在这个范围外访问service的地址都会进行MASQURADE
#其实没有存在的必要，很多网络插件都进行了SNAT
#如果设置了这个参数，但是没有覆盖全面的ip，这样外部ip会进行MASQURADE，从而影响相关参数
--cluster-cidr
```
