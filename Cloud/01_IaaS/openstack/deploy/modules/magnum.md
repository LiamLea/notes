# magnum


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [magnum](#magnum)
    - [deploy](#deploy)
      - [1.修改配置](#1修改配置)
      - [2.部署](#2部署)
    - [使用 (有外网)](#使用-有外网)
      - [1.下载并上传镜像](#1下载并上传镜像)
      - [2.设置ssh key用于登陆虚拟机](#2设置ssh-key用于登陆虚拟机)
      - [3.创建k8s cluster template](#3创建k8s-cluster-template)
      - [4.创建k8s cluster](#4创建k8s-cluster)
    - [使用 (没有外网)](#使用-没有外网)
      - [1.准备](#1准备)
        - [(1) etcd discovery](#1-etcd-discovery)
        - [(2) helm client](#2-helm-client)
    - [troubleshooting](#troubleshooting)
      - [1.debug策略](#1debug策略)

<!-- /code_chunk_output -->

### deploy

#### 1.修改配置

```shell
vim /etc/kolla/globals.yml
```

```yaml
enable_magnum: true
```

#### 2.部署
```shell
kolla-ansible -i ./multinode deploy
```

***

### 使用 (有外网)

#### 1.下载并上传镜像
* 下载虚拟机镜像
    * 根据[文档](https://docs.openstack.org/magnum/latest/user/#kubernetes)中的image配置项下载[镜像](https://fed*oraproject.org/en/coreos/download/?tab=cloud_operators)

* 上传虚拟机镜像到openstack

* 下载容器镜像到本地镜像仓库
    * 根据[文档](https://docs.openstack.org/magnum/latest/user/#kubernetes)中的container_infra_prefix配置项下载


#### 2.设置ssh key用于登陆虚拟机

* 将公钥上传
    * 这里命名为: magnumkey
* 后续可用私钥登陆虚拟机

#### 3.创建k8s cluster template

```shell
#  container_infra_prefix只能设置一层（不能设置其他层），且必须以/结尾，因为bug
#  kubelet_options="--resolv-conf /run/systemd/resolve/resolv.conf"指定这个是因为存在coredns和systemd-resolved的冲突的buf（参考: https://github.com/coredns/coredns/blob/master/plugin/loop/README.md#troubleshooting-loops-in-kubernetes-clusters）
openstack coe cluster template create k8s-cluster-template \
  --image fedora-coreos-38 \
  --keypair magnumkey \
  --external-network public1 \
  --dns-nameserver 172.16.3.2 \
  --flavor compute-4c8g --master-flavor compute-4c8g\
  --docker-volume-size 5 \
  --network-driver flannel \
  --coe kubernetes \
  --labels container_infra_prefix="172.16.2.101:5000/",auto_healing_enabled=false,auto_scaling_enabled=false,kubelet_options="--resolv-conf /run/systemd/resolve/resolv.conf"
```

* 在图形界面配置（有bug）
    * docker volume设为空
    * 设置Insecure Registry
        * 172.16.2.101:5000

* [更多labels](https://docs.openstack.org/magnum/latest/user/#kubernetes)

#### 4.创建k8s cluster

```shell
openstack coe cluster create k8s-test \
    --cluster-template k8s-cluster-template \
    --keypair magnumkey \
    --master-count 1 --node-count 2
```


***

### 使用 (没有外网)

#### 1.准备

##### (1) etcd discovery

[参考](https://etcd.io/docs/v3.5/op-guide/clustering/#custom-etcd-discovery-service)

##### (2) helm client

* 添加label
    * `helm_client_url="http://172.16.3.2/helm-v3.2.1-linux-amd64.tar.gz"`

***

### troubleshooting

#### 1.debug策略

* 登陆到虚拟机中
```shell
$ ssh core@<ip>
$ sudo -i
```

* 查看heat-container-agent服务
    * 要确保这个服务正常启动
```shell
systemctl status heat-container-agent.service
``` 