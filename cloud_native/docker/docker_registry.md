# docker registry

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [docker registry](#docker-registry)
    - [概述](#概述)
      - [1.insecure registry](#1insecure-registry)
        - [（1）没有设置insecure registry](#1没有设置insecure-registry)
        - [（2)设置了insecure registry](#2设置了insecure-registry)
      - [2.registry分类](#2registry分类)
    - [使用](#使用)
      - [1.查看有哪些docker仓库](#1查看有哪些docker仓库)
      - [2.查看某个仓库有哪些标签](#2查看某个仓库有哪些标签)
      - [3.删除某个镜像](#3删除某个镜像)
      - [4.去仓库服务器上清理刚刚删除的镜像](#4去仓库服务器上清理刚刚删除的镜像)

<!-- /code_chunk_output -->

### 概述

#### 1.insecure registry

##### （1）没有设置insecure registry
* 则默认使用https协议连接仓库
所以必须信任颁发机构，即有ca证书，才能登录成功

##### （2)设置了insecure registry
* 首先尝试用`https`协议连接
  * 如果该端口提供了https协议，但是提示证书无效，会忽略这个错误，从而成功连接
* 最后尝试用`http`协议连接

#### 2.registry分类
* sponsor registry        
第三方registry，供客户和docker社区使用

* Mirror registry           
第三方registry，只让客户使用

* Vendor registry          
由发布docker镜像的供应商提供的registry

* Private registry         

***

### 使用

#### 1.查看有哪些docker仓库
```shell
curl -X GET <ip:port>/v2/_catalog
```
```shell
{"repositories":["kafka","alertmanager","busybox", ...]}
```

#### 2.查看某个仓库有哪些标签
```shell
curl -X GET <ip:port>/v2/<repostory>/tags/list
```
```shell
#curl -X GET <ip:port>/v2/tidb/tags/list
{"name":"tidb","tags":["v3.0.5"]}
```

#### 3.删除某个镜像
* 获取Docker-Content-Digest
```shell
#一定要加v，因为Docker-Content-Digest在响应头中
curl -v -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET <ip:port>/v2/<repository>/manifests/<tag>

#Docker-Content-Digest: sha256:995053b0f94980e1a40d38efd208a1e8e7a659d1d48421367af57d243dc015a2
```

* 删除指定镜像
```shell
curl -X DELETE <ip:port>/v2/<repository>/manifests/<Docker-Content-Digest>
```

#### 4.去仓库服务器上清理刚刚删除的镜像
```shell
#d:dry run，先dry run一下，防止删错
/usr/bin/docker-registry garbage-collect /etc/docker/registry/config.yml -d

#确认无误后，删除镜像
/usr/bin/docker-registry garbage-collect /etc/docker/registry/config.yml
```
