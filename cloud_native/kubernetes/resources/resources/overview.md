# overview

[toc]

### 概述

#### 1.容器有两个维度的 资源限制

##### （1）requests： `containers.resources.requests`
* 需求，申明需要的资源
* **影响调度过程**

##### （2）limits： `containers.resources.limits`

* 限制，硬限制
* 达到限制，container会被kill（**OOMKilled**），pod会被重新启动
```shell
kubecl describe ...
#可以看到容器的状态
#    Last State:     Terminated
#      Reason:       OOMKilled
```

```shell
$ kubectl describe ...

#可以查看
Last State:     Terminated
    Reason:       OOMKilled
```

#### 2.cpu单位
最好用`m`表示，因为1m是最小精度

```shell
1cpu代表1个虚拟cpu，即1个核心
1 cpu == 1000m cpu        #m是千分之一的意思
                          #500m cpu 就相当于 0.5 个cpu
```

#### 3.内存单位
```shell
k（或K） ----    10^3 = 1000
Ki      ----    2^10 = 1024

m（或M） ----    10^6 = 1000000
Mi      ----    2^20 = 1024*1024

#i：binary
```

#### 4.ephemeral storage
存储的内容都是**临时**的，pod重启后，内容会丢失

##### （1）存储的内容（临时的）
* emptyDir volumes
* 容器的日志
* 容器的可写层

##### （2）作用
* 用于限制Pods对可写层、容器日志、emptyDir volumes
* 如果没有ephemeral storage，则pods会对容器的**可写层等** **无限的使用**，导致磁盘容量很快就用光

##### （3）kubernetes开启这个功能
在kubelet中配置（默认是开启的）
```shell
--feature-gates LocalStorageCapacityIsolation=true
```

##### （4）使用
```yaml
spec.containers[].resources.requests.ephemeral-storage
spec.containers[].resources.limits.ephemeral-storage
```

#### 5.qos class（服务质量类型）
```shell
#通过下面命令查看
kubectl describe pods xx
```
##### （1）guaranteed（高优先级）
该pod内每个容器都设置了requests和limits，并且：
内存的requests == 内存的limits
cpu的requests == 内存的limits

##### （2）burstable（中优先级）

##### （3）besteffort（低优先级）
该pod内没有一个容器设置requests和limits

**当资源不够用时，先杀死优先级的pod**

#### 6.LimitRange 资源
如果容器没有设置requests和limits，LimitRange资源会自动给该容器设置
* LimitRange的作用范围是其所在namespace
