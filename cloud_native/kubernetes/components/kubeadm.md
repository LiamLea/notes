# kubeadm

[toc]

### 概述

#### 1.特点
* 用于创建k8s集群
* 配置的主要内容：
  * 集群的基本信息（集群名称）
  * etcd的存储目录
  * 网络相关（域名、使用的网段）

***

### kubeadm使用

#### 1.配置kubeadm
```shell
#生成默认配置
kubeadm config print init-defaults > /tmp/kubeadm.conf

#修改配置
vim /tmp/kubeadm.conf

#使用：执行kubeadm时指定该文件
```

```yaml
...
kind: InitConfiguration

#相当于--apiserver-advertise-address=<IP> --apiserver-bind-port=<PORT>
localAPIEndpoint:
  advertiseAddress: 3.1.5.241
  bindPort: 6443
...

---

...
kind: ClusterConfiguration
imageRepository: k8s.gcr.io

#--control-plane-endpoint=<VIP_OR_DNS>:<PORT>
controlPlaneEndpoint: 3.1.5.241:6443

#--kubernetes-version=v1.17.3
kubernetesVersion: v1.17.3

networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  podSubnet: 10.244.0.0/16
...
```

#### 2.`kubeadm init`上传的文件
会上传以下文件，以configmap形式存储：
* `kubeadm-config.kube-system`
  * kubeadm的配置
* `kubelet-config-1.17.kube-system`
  * kubelet的配置
* `cluster-info.kube-public`
  * 集群的信息，包括使用的相关证书的内容

`kubeadm join`, `kubeadm reset`，`kubeadm upgrade`会读取相关configmap里面的配置


#### 3.`kubeadm init`阶段解析

##### （1）预检查：`kubeadm init phase preflight`
```shell
kubeadm init phase preflight --config <kubeadm-config>
```
* 检查环境是否符合要求
* 拉取镜像

##### （2）生成证书：`kubeadm init phase certs`
```shell
kubeadm init phase certs all --config <kubeadm-config>
```
* 包括apiserver、etcd等所有需要的证书

##### （3）生成kubeconfig配置文件：`kubeadm init phase kubeconfig`
kubeconfig配置文件是用于连接apiserver的配置
```shell
kubeadm init phase kubeconfig all --config <kubeadm-config>
```
* 包括以下配置文件（`/etc/kubernetes/`）：
都是kubeconfig配置文件，只是用的密钥不一样
  * `admin.conf`（用于客户端连接apiserver）
  * `controller-manager.conf`（用于控制器连接apiserver）
  * `kubelet.conf`（用于kubelet连接apiserver）
  * `scheduler.conf`（用于调度器连接apiserver）

##### （4）生成kubelet的配置并启动Kubelet：`kubeadm init phase kubelet-start`
```shell
kubeadm init phase kubelet-start --config <kubeadm-config>

#/var/lib/kubelet/ 下生成相关文件
```

##### （5）生成用于构建控制平面的pod的清单文件：`kubeadm init phase control-plane`
kubelet会自定读取 指定目录（kubelet的配置）下的清单文件，然后启动相应pod
包括以下组件：
* apiserver
* controller-manager
* scheduler

```shell
kubeadm init phase control-plane all --config <kubeadm-config>
```

##### （6）生成etcd pod的清单文件：`kubeadm init phase etcd`
```shell
kubeadm init phase etcd local --config <kubeadm-config>
```

##### （7）上传配置到configmap：`kubeadm init phase upload-config`
包括以下配置：
* kubeadm
* kubelet

```shell
kubeadm init phase upload-config all --config <kubeadm-config>

#kubectl get cm -n kube-system 查看
```

##### （8）上传密钥：`kubeadm init phase upload-certs`
```shell
kubeadm init phase upload-certs --config <kubeadm-config> --upload-certs

#kubectl get secret kubeadm-certs -n kube-system
#这个密钥上传的作用是为了给其他master node加入集群时 使用的
```

##### （9）标识控制平面（即标识该节点为master）：`kubeadm init phase mark-control-plane`
```shell
kubeadm init phase mark-control-plane --config <kubeadm-config>

#本质就是给该节点打上标签和污点：
# adding the label "node-role.kubernetes.io/master=''"
# adding the taints [node-role.kubernetes.io/master:NoSchedule]
```

##### （10）生成引导令牌，用于其他节点加入该集群：`kubeadm init phase bootstrap-token`
```shell
kubeadm init phase bootstrap-token --config <kubeadm-config>

#会在kube-public命名空间下生成cluster-info configmap，用于节点获取ca等信息
```

##### （11）更新kubelet的最终配置：`kubeadm init phase kubelet-finalize`
```shell
kubeadm init phase kubelet-finalize all --config <kubeadm-config>
```

##### （12）安装必要的插件：`kubeadm init phase addon`
包括以下插件：
* coredns
* kube-proxy

```shell
kubeadm init phase addon all --config <kubeadm-config>
```

#### 3.`kubeadm alpha`

##### （1）重新生成证书：`kubeadm alpha certs renew`

* 查看证书的到期时间

```shell
kubeadm alpha certs check-expiration
```

* 重新生成所有证书
```shell
kubeadm alpha certs renew all
```
