# overview

[toc]

### 概述

#### 1.容器有两个维度的 资源限制

##### （1）requests： `containers.resources.requests`
* 需求，申明需要的资源
* **影响调度过程**

##### （2）limits： `containers.resources.limits`

* 限制，硬限制

##### （3）达到limits后触发容器的OOM
* 容器会被删掉，然后重新创建
* pod会进入`OOMKilled`状态，然后重启
* 当重启次数过多，则pod的状态变为：`CrashLoopBackOff`
```shell
$ kubectl describe ...

#可以查看
Last State:     Terminated
    Reason:       OOMKilled
```

##### （4）未达到limits而触发系统的OOM
系统会停止相关进程，可能导致容器报错退出，如果是这种情况：
* 容器会被删掉，然后重新创建
* pod会进入`ERROR`状态，然后重启
* 当重启次数过多，则pod的状态变为：`CrashLoopBackOff`

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

#### 5.QoS class（服务质量类型）
```shell
#通过下面命令查看
kubectl describe pods xx
```
##### （1）guaranteed
该pod内每个容器都设置了requests和limits，并且：
  * `内存的requests == 内存的limits`
  * `cpu的requests == cpu的limits`

##### （2）burstable

##### （3）besteffort
该pod内没有一个容器设置requests和limits
