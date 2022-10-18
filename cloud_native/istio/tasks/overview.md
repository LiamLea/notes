# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.traffic management](#1traffic-management)
    - [在k8s中使用时的注意事项](#在k8s中使用时的注意事项)
      - [1.创建service，服务端口必须按照要求命名](#1创建service服务端口必须按照要求命名)

<!-- /code_chunk_output -->

### 概述
#### 1.traffic management
In order to direct traffic within your mesh, Istio needs to know where all your endpoints are, and which services they belong to. To populate its own service registry, Istio connects to a service discovery system.


### 在k8s中使用时的注意事项

#### 1.创建service，服务端口必须按照要求命名
命名格式：`<protocol>[-<suffix>]`
比如：
```yaml
apiVersion: v1
kind: Service
metadata:
  name: xx
spec:
  selector:
    xx: xx
  ports:
  - name: http      #这里需要命名规范
    port: xx
```
支持的协议：
* grpc
* grpc-web
* http
* http2
* https
* mongo
* mysql
默认关闭，需要在pilot配置文件中开启
* redis
默认关闭，需要在pilot配置文件中开启
* tcp
* tls
* udp
