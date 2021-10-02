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
