# apiserver

[toc]

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
[更多配置](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)

#### 2.修改配置文件
修改后保存，配置立即生效
```shell
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```
