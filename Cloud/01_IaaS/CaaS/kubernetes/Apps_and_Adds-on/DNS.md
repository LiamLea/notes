# DNS

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [DNS](#dns)
    - [概述](#概述)
      - [1.特点](#1特点)
      - [2.支持的记录](#2支持的记录)
        - [（1）service相关](#1service相关)
        - [（2）pod相关](#2pod相关)
      - [3.pod的DNS policy](#3pod的dns-policy)
      - [4.增加DNS配置](#4增加dns配置)
      - [5.在容器的hosts文件中增加解析记录](#5在容器的hosts文件中增加解析记录)

<!-- /code_chunk_output -->

### 概述
#### 1.特点
* k8s会创建一个DNS的pod和service
* kubelet会控制每个容器，都去使用该DNS服务器

#### 2.支持的记录

##### （1）service相关
* A/AAAA记录
  * 对于正常service，返回该service的ip
  * 对于headless service，返回一个IP集合
</br>
* SRV记录
  * 用于命名的端口，当解析下面域名时，能够从SRV记录中，获取端口号
    * `_<PORT_NAME>._<PORT_PROTOCOL>.<SVC_NAME>.<NAMESAPCE>.svc.<CLUSTER_DOMIAN>`

##### （2）pod相关
注意：`<ip-addr>`形如`192-168-1-1`
* 每个pod都一个DNS解析
  * `<ip-addr>.<NAMESPACE>.pod.<CLUSTER_DOMAIN>`
</br>
* 被Deployment或DaemonSet创建的Pod有如下DNS解析
  * `<ip-addr>.<DEPLOYMENT_NAME>.<NAMESPACE>.svc.<CLUSTER_DOMAIN>`


#### 3.pod的DNS policy
`Pod.spec.dnsPolicy`
* Default
复制所在node的`/etc/resolv.cnf`文件
</br>

* ClusterFirst（默认）
当查询DNS时，域名后缀不匹配<CLUSER_DOMAIN>，则会去node的nameserver
</br>
* ClusterFirstWithHostNet
当pod使用host网络时，需要明确设置这一项
</br>
* None
不自动配置DNS，只使用dnsConfig这个字段的配置DNS

#### 4.增加DNS配置
`Pod.spec.dnsConfig`

对于所有dnsPolicy，dnsConfig都生效（是对DNS配置的增加，而不是覆盖）

#### 5.在容器的hosts文件中增加解析记录
`spec.hostAliases`
