# ServiceEntry

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ServiceEntry](#serviceentry)
    - [概述](#概述)
      - [1.与k8s service比较](#1与k8s-service比较)
    - [使用](#使用)
      - [1.清单文件](#1清单文件)

<!-- /code_chunk_output -->

### 概述

#### 1.与k8s service比较

* k8s service能够提供域名解析（ServiceEntry不行），并且istio能够根据这个service自动生成ServiceEntry
* 当使用ip访问外部时，k8s service就没用了，而ServiceEntry是可以关联ip的

***

### 使用

#### 1.清单文件

* 注意：只对envoy有影响
  * 生成相应的listener、route、cluster等

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: <name>
spec:

  #用于匹配主机名（当使用http等时才有效）
  hosts:
  - mymongodb.somedomain

  #用于匹配地址（如果没有配置这个地址，则listener会匹配所有地址）
  #可以是网段192.192.192.192/24，也可以是具体的地址（当访问的是具体的地址时，这里必须也是具体的地址）
  addresses:
  - 192.192.192.192
  
  ports:
  - number: 27018
    name: mongodb
    protocol: MONGO
  location: MESH_INTERNAL

  #主要有三种：None、STATIC、DNS（区别看下方）
  #STATIC时，需要指定endpoints
  resolution: STATIC
  endpoints:
  - address: 2.2.2.2
  - address: 3.3.3.3
```

* resolution和envoy cluster类型的对应关系
  * NONE -- original destination
  * STATIC -- EDS
  * DNS -- STRICT_DNS
