# coreDNS

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [coreDNS](#coredns)
    - [概述](#概述)
      - [1.容器如何使用DNS](#1容器如何使用dns)
      - [2.内存需求](#2内存需求)
      - [3.forward](#3forward)
        - [(1) 健康检查](#1-健康检查)
    - [配置](#配置)
      - [1.配置文件：Corefile](#1配置文件corefile)
      - [2.修改配置](#2修改配置)

<!-- /code_chunk_output -->

### 概述

#### 1.容器如何使用DNS
* 启动coreDNS，会分配一个静态ip
```shell
#通过该命令可以查看到coreDNS的静态ip
kubectl get svc -n kube-system
```
* 在kubelet的启动参数中指定，使用的DNS
通过kubelet启动容器，会自动注入DNS服务器信息到容器中
```shell
--cluster-dns=<dns-service-ip>
--cluster-domain=<default-local-domain>
```

#### 2.内存需求

* 主要受pods和services数量的影响
[参考](https://github.com/coredns/deployment/blob/master/kubernetes/Scaling_CoreDNS.md)

#### 3.forward
[参考](https://coredns.io/plugins/forward/)

* 最多只有3个forward nameserver生效，会转发到其中一个nameserver

##### (1) 健康检查
* 会检查forward的nameserver的状态
  * 如果健康检查失败，就不会将请求发往这些nameserver
  * 如果所有的upstream健康检查都失败，则会随即发送到其中一个upstream（会引发大量的i/o timeout）

***

### 配置

#### 1.配置文件：Corefile

[插件参考](https://github.com/coredns/coredns/tree/master/plugin)

* 基本格式
```shell
#server block格式，可以设置多个server block
<zone>:<port> {
  <plugin> <params> {}
}
```

* 常用配置
```shell
# . 表示根域，即所有匹配所有的域
# 53 表示监听在53端口上
.:53 {

    #将错误输出到标准输出
    errors

    #将coreDNS状态报告到 http://localhost:8080/health
    health

    #kubernetes plugin，会读取kubernetes中的配置
    #匹配域: cluster.local（k8s所在的域） in-addr.arpa、ip6.arpa（rDNS）
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       upstream
       #如果这两个域（in-addr.arpa、ip6.arpa）没有查询到结果，则将请求出入下一个插件
       #即rDNS没有查询结果，则将请求传入下一个插件
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }


    #hosts后面加域，如果域为空，表示匹配配置文件上面设置的域，即所有域
    hosts {

        #添加域名解析
        172.28.202.162 gitlab.devops.nari

        #如果没有查询到结果，则将请求传入下一个插件
        fallthrough
    }

    #暴露0.0.0.0:9153端口，提供prometheus的metric接口
    prometheus :9153

    #转发到下面的其中一个nameserver (如果在上面已经返回了解析结果，就不会走到这一步)
    #. 表示根域，即所有匹配所有的域
    #转发到/etc/resolve.conf中设置的DNS服务器，也可以直接写DNS服务器地址，比如：forward . 114.114.114.114 8.8.8.8
    forward . /etc/resolv.conf
}
```

#### 2.修改配置
```shell
kubectl edit cm coredns -n kube-system
```
