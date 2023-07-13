# apiserver

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [apiserver](#apiserver)
    - [概述](#概述)
      - [1.特点](#1特点)
    - [配置](#配置)
      - [1.配置文件：`kube-apiserver.yaml`](#1配置文件kube-apiserveryaml)
      - [2.修改配置文件](#2修改配置文件)
      - [3.关于etcd的配置](#3关于etcd的配置)

<!-- /code_chunk_output -->

### 概述

#### 1.特点
* 配置的主要内容：
  * apiserver对外暴露的地址
  * etcd的连接信息
  * 与kubelet连接使用的密钥
  * nodePort的端口范围

***

### 配置

#### 1.配置文件：`kube-apiserver.yaml`
[参考文档](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)
```shell
#用于指定一个ca文件，用户可以用这个ca文件签署过的证书来进行认证
--client-ca-file
```

#### 2.修改配置文件
修改后保存，配置立即生效
```shell
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

#### 3.关于etcd的配置
```shell
--etcd-servers <stringSlice>
--etcd-cafile <string>
--etcd-certfile <string>
--etcd-keyfile <string>

--etcd-prefix <string | default: "/registry">

#默认使用的etcd v3 data存储格式，也可以设置成etcd2
--storage-backend <string | default: "etcd3">
```
