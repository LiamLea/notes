# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [概述](#概述)
      - [1.组件](#1组件)
      - [2.能够数据](#2能够数据)
    - [在docker上安装](#在docker上安装)
    - [在k8s上安装](#在k8s上安装)
      - [1.配置](#1配置)

<!-- /code_chunk_output -->

### 概述

#### 1.组件
|组件|说明|是否需要安装|
|-|-|-|
|NGINX Ingress|web入口||
|Registry|镜像仓库，可以push和pull镜像|
|Redis|缓存|
|数据库（postgresql）|存储配置等信息|
|minio|提供对象存储服务|
|GitLab/Gitaly|后台服务，专门负责访问磁盘以高效处理 git 操作，并缓存耗时操作。所有的 git 操作都通过 Gitaly 处理|
|GitLab/Sidekiq|后台任务处理，负责异步处理后台的任务|
|GitLab/Unicorn|Gitlab 自身的 Web 服务器，包含了 Gitlab 主进程，负责处理快速/一般任务|
|GitLab/GitLab Shell|用于 SSH 交互|
|GitLab/Migrations|用于数据库迁移|
|GitLab/Workhorse|反向代理，处理 Git Push/Pull 请求，处理到 Rails 的连接|
|Gitlab/Runner|执行CI/CD相关任务|

#### 2.能够数据
一些数据存在关系型数据库，一些数据存在非关系数据库（minio）
* 代码
* lfs（large file storage）
* artifacts
* uploads
* packages
* MR diffs（merge request diffs）

***

### 在docker上安装
[参考](https://docs.gitlab.com/ee/install/docker.html)
```shell
mkdir /var/gitlab
export GITLAB_HOME=/var/gitlab

docker run --detach \
 --hostname gitlab.example.com \
 --env GITLAB_OMNIBUS_CONFIG="external_url 'https://10.10.10.249/';" \
 --publish 443:443 --publish 80:80 --publish 22:22 \
 --name gitlab \
 --restart always \
 --volume $GITLAB_HOME/config:/etc/gitlab \
 --volume $GITLAB_HOME/logs:/var/log/gitlab \
 --volume $GITLAB_HOME/data:/var/opt/gitlab \
 --shm-size 256m \
 gitlab/gitlab-ee:latest

#获取root初始化密码
cat $GITLAB_HOME/config/initial_root_password
```

***

### 在k8s上安装

#### 1.配置
```shell
vim gitlab/values.yaml
```
```yaml
#global的配置是全局的配置，可以覆盖不在global中的某些配置
#不在global中的配置是对某个软件的具体配置
global:
  edition: ce     #安装社区版

  hosts:
    domain: example.com   #设置base domain
    externalIP: "https://xx:30443"    #设置对外宣称的访问地址

  ingress:
    annotations.<annotation-key>: xx    #设置annotations
    configureCertmanager: false     #是否配置certmanager
                                    #如果不配置且没有指定secret，则会利用shared-secrets组件自动生成自签证书
    class: "nginx"          #设置kubernetes.io/ingress.class

  psql:
    password:               #如果不设置，会用postgresql下面设置的
      secret: xx
      key: xx

  redis:
    password:
      enabled: true
      secret: xx           #如果不设置，会用redis下面设置的
      key: xx

  registry:                #用于存储镜像的仓库
    enabled: false

  grafana:
    enabled: false

  minio:                   #用于对象存储
    enabled: true

  shell:
    port: xx              #设置ssh开启的端口号（同时也是对外声明的ssh端口号，所以最好跟ingress暴露的端口号一样）

  appConfig:
    ldap:
      preventSignin: false
      servers:
        main:                 #这个配置的标识
          label: "LDAP"
          host: "xx"
          port: 389
          uid: "xx"           #用条目中的哪个属性字段做为登录的uid（一般也设为uid）
          bind_dn: "cn=admin.dc=xx,dc=xx"
          password:
            secret: xx
            key: xx

prometheus:
  install: false

nginx-ingress:
  enabled: false

certmanager:
  createCustomResource: false   #是否创建crd
  install: false

upgradeCheck:
  enabled: false        #不检查更新

certmanager:
  install: false
  createCustomResource: false

nginx-ingress:
  enabled: false

gitlab-runner:
  enabled: false

````
