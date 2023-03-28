# kubectl
apiserver的客户端程序，是k8s集群的管理入口


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [kubectl](#kubectl)
    - [配置](#配置)
      - [1.配置文件：`~/.kube/config`](#1配置文件kubeconfig)
    - [基本使用](#基本使用)
      - [1.创建service](#1创建service)
      - [2.删除所有evicted状态的pods](#2删除所有evicted状态的pods)
      - [3.强制删除](#3强制删除)
      - [4.查看已创建的资源实例](#4查看已创建的资源实例)
      - [5.查看已创建的某种资源实例](#5查看已创建的某种资源实例)
      - [6.查看某个实例的详细信息](#6查看某个实例的详细信息)
      - [7.查询node节点的状态](#7查询node节点的状态)
    - [管理pods和controllers](#管理pods和controllers)
      - [1.创建pods](#1创建pods)
      - [2.动态扩容和缩容pods](#2动态扩容和缩容pods)
      - [3.升级镜像](#3升级镜像)
      - [4.在容器内执行指令](#4在容器内执行指令)
      - [5.查看日志](#5查看日志)
      - [6.暂停和恢复 daemonset](#6暂停和恢复-daemonset)
    - [管理标签和污点](#管理标签和污点)
      - [1.给资源打标签](#1给资源打标签)
      - [2.删除资源的某个标签](#2删除资源的某个标签)
      - [3.给node打上污点](#3给node打上污点)
      - [4.删除某个污点](#4删除某个污点)
    - [其他操作](#其他操作)
      - [1.在某台master上开启代理](#1在某台master上开启代理)
      - [2.查询发生的事件（用于排错）](#2查询发生的事件用于排错)
    - [查看集群信息](#查看集群信息)
      - [1.查看集群信息](#1查看集群信息)
    - [常用命令](#常用命令)
      - [1.查询所有Pods的requests和limits](#1查询所有pods的requests和limits)
      - [2.查询所有pod和其uid](#2查询所有pod和其uid)
    - [插件使用](#插件使用)
      - [1.安装插件管理工具: krew](#1安装插件管理工具-krew)
      - [2.安装其他插件](#2安装其他插件)
      - [3.常用插件](#3常用插件)
        - [（1）sniff: 在pod内进行抓包](#1sniff-在pod内进行抓包)

<!-- /code_chunk_output -->


### 配置

#### 1.配置文件：`~/.kube/config`

```yaml
apiVersion: v1
kind: Config

#定义集群信息（可以设置多个）
clusters:
- name: <CUSTOME_CLUSTER_NAME>
  cluster:
    server: https://<IP>:<PORT>

    #不能同时设置ca和insecure，只能设置一个
    #当有ca证书时
    certificate-authority-data: <CA_CONTENT>
    #当没有ca证书或者ca证书不正确时，设置：
    insecure-skip-tls-verify: true

#定义用户信息（可以设置多个）
users:
- name: <CUSTOME_USER_NAME>
  user:
    #当用normal user认证时，需要这样设置
    #证书内容需要进行base64编码：cat xx | base64 | tr -d '\n'
    client-certificate-data: <CERTIFICATE>
    client-key-data: <PRIVATE_KEY>

    #当使用serviceaccount时，需要设置token，账号无需指定
    #<TOKEN>获取方式：
    # 1.根据serviceaccount获取存储token的secret
    # 2.获取token内容并且base64 --decode：kubectl get secret -o yaml
    token: <TOKEN>

#上下文信息，就是进行组合，将用户和集群进行组合（即用指定用户登录指定集群）
contexts:
- name: <CUSTOME_CONTEXT_NAME>
  context:
    cluster: <CLUSTER_NAME>
    user: <USER_NAME>

#指定当前使用的上下文，即使用指定用户登录指定集群
current-context: <CONTEXT_NAME>
```

***

### 基本使用

#### 1.创建service
```shell
kubectl expose TYPE NAME \        #TYPE：控制器的类型，NAME：控制器名字必须是已存在的
          --name=服务名字 \
          --port=xx \             #service的端口号
          --target-port=xx        #target-port为容器的端口号
```

#### 2.删除所有evicted状态的pods
```shell
kubectl get pods --all-namespaces --field-selector 'status.phase==Failed' -o json | kubectl delete -f -
```

#### 3.强制删除
```shell
kubectl delete ...  --force --grace-period=0
```

#### 4.查看已创建的资源实例
```shell
kubectl get all         #不能获取指定命名空间下的全部资源

kubectl api-resources \
         --verbs=list \	      #过滤出支持list这个动作的资源
         --namespaced \	      #过滤出属于名称空间范围的资源
         -o name \            #过滤出资源的名字
         --show-labels         #查看资源的所有标签

#可以将过滤出的资源放入一个文件中
#然后遍历每一个资源，进行kubectl get，从而获取该名称空间下的已创建的全部资源
```

#### 5.查看已创建的某种资源实例
```shell
kubectl get xx
    -A               #获取所有命名空间下的
    -n xx            #-n指明名称空间，不加-n，默认是default名称空间
    -o wide          #-o指明输出格式，wide输出扩展信息
    -l xx=yy         #过滤含有xx这个标签且标签值为yy的资源
                     #也可以-l xx直接过滤含有xx标签的pods  
    --field-selector xx=yy    #过滤xx字段为yy的资源
                              #字段即kubectl describe xx能够查看到的字段
                              #比如：--filed-selector metadata.namespace=default,statu.phase!=Running

#标签有两种关系判断：
#  等值关系：=    !=
#  集合关系：KEY in (VALUE1,VALUE2,...)   
#           KEY not in (VALUE1,...)
#           !KEY  
```      

#### 6.查看某个实例的详细信息
```shell
kubectl describe TYPE NAME      #TYPE：资源类型，NAME：资源名称，查看某个资源的详细信息

kubectl get TYPE NAME

    -o yaml

    -o jsonpath='{$}'
#'{<JSONPATH>}'
#'{<JSONPATH>}xxx'
#'{<JSONPATH}{"\n"}'
```

#### 7.查询node节点的状态
```shell
kubectl describe nodes xx
```
|Type|说明|Status</br>（True、False或Unkown）|lastProbeTime</br>（上次探测pod状态的时间戳）|lastTransitionTime</br>（从一个状态转换为另一种状态的时间戳）|reason</br>（状态切换的原因）|message</br>（对该状态切换的详细说明）|
|-|-|-|-|-|-|-|
|NetworkUnavailable|是否网络不可达||||||
|MemoryPressure|是否有内存压力||||||
|DiskPressure|是否有磁盘压力||||||
|PIDPressure |是否有pid压力||||||
|Ready|是否准备就绪|

***

### 管理pods和controllers

#### 1.创建pods
```shell
kubectl run NAME \          #NAME为pod控制器的名字
      --image=xx \                
      --replicas=xx \        #replicas指明副本数，至少为1，即只有1个容器
      --command -- 具体名
```

#### 2.动态扩容和缩容pods
```shell
kubectl scale --relicas=xx 控制器名
```

#### 3.升级镜像
```shell
kubectl set image deployment 控制器名 容器名=新的镜像名
```       

#### 4.在容器内执行指令
```shell
kubectl exec NAME [-c xx] [-it] -- 命令
```

#### 5.查看日志
```shell
kubectl logs POD_NAME
            -c xx         #指定要查看的容器
            --since=5s    #显示最近5s的日志，当日志特别的的时候，这个选项很实用（可以将结合-f使用）
            -f            #follow
            -p            #previous，查看该容器的上一个实例（常用于查询终止的容器的日志）
                          #当容器重新启动，kubelet会保留该容器上一个终止的实例
```

#### 6.暂停和恢复 daemonset

* 暂停daemonset
```shell
kubectl -n <namespace> patch daemonset <daemonset> -p '{"spec": {"template": {"spec": {"nodeSelector": {"non-existing": "true"}}}}}'
```

* 恢复daemonset
```shell
kubectl -n <namespace> patch daemonset <daemonset> --type json -p='[{"op": "remove", "path": "/spec/template/spec/nodeSelector/non-existing"}]'
```

***

### 管理标签和污点

#### 1.给资源打标签
```shell
kubectl label TYPE NAME xx1=xx ... xxn=xx       
```

#### 2.删除资源的某个标签
```shell
kubectl label TYPE NAME 标签名-
```

#### 3.给node打上污点
```shell
kubectl taint nodes NODENAME KEY1=VAVLUE1:EFFECT
#EFFECT的取值：
#   NoSchedule          仅影响调度过程，对现存pod不产生影响
#   NoExecute           既影响调度过程，又影响现存pod，不能容忍的pod将被驱逐
#   PreferNoSchedule    仅影响调度过程，不能容忍的pod实在找不到node，该node可以接收它

```

#### 4.删除某个污点
```shell
kubectl taint nodes NODENAME 污点名-

#当使用这种方法无法删除时，使用下面命令删除
#kubectl edit nodes NODENAME
```

***

### 其他操作

#### 1.在某台master上开启代理
```shell
kubectl proxy --address="0.0.0.0" --port=8080 --accept-hosts='^.*' --accept-paths='^.*'

#之后就可以利用url获得相关资源
#比如：
#  curl 127.0.0.1:8080/api/v1/namespaces

#可以直接使用下面的命令，无需开启代理
# kubectl get --raw "/api/v1/namespaces"
```

#### 2.查询发生的事件（用于排错）
```shell
kubectl get events --sort-by=.metadata.creationTimestamp -n xx
```

***

### 查看集群信息

#### 1.查看集群信息
```shell
kubectl cluster-info dump

#可以查找以下信息：
# service-cluster-ip-range
# cluster-cidr
```

***

### 常用命令

#### 1.查询所有Pods的requests和limits
```shell
kubectl get pods -n aiops-dev -o custom-columns="Name:metadata.name,CPU-request:spec.containers[*].resources.requests.cpu"
```

#### 2.查询所有pod和其uid
```shell
kubectl get pods -A -o custom-columns=PodName:.metadata.name,PodUID:.metadata.uid
```

***

### 插件使用

#### 1.安装插件管理工具: krew
[参考](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
```shell
export OS="$(uname | tr '[:upper:]' '[:lower:]')"
export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
export KREW="krew-${OS}_${ARCH}"

#设置代理，不然无法下载
HTTPS_PROXY="http://10.10.10.250:8123" curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"

tar zxvf "${KREW}.tar.gz"

#设置代理，不然无法下载
HTTPS_PROXY="http://10.10.10.250:8123" ./"${KREW}" install krew
```

#### 2.安装其他插件
```shell
HTTPS_PROXY="http://10.10.10.250:8123" kubectl krew install <plugin>
```

#### 3.常用插件

#####（1）sniff: 在pod内进行抓包
```shell
#过滤: -f "port 9848"
#如果不输出成文件，需要存在wireshark
kubectl sniff <pod_name>  -o /tmp/<xx>.pcap
```
