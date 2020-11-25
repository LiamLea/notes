# pod
[toc]
### 基础概念
```plantuml
card "init containers" as a
card "container执行启动命令" as e
card "postStart" as b
card "container probes" as c
a -> e
e -> b
b -> c
```
#### 1.定义
一组containers的集合，这些containers共享**net**和**ipc**命名空间，共享**volume**
#### 2.pod phase（生命周期）
影响字段：
```yaml
Pod.status.phase
```
pod的生命周期只有以下几种情况
|阶段|说明|
|-|-|
|Pending|一个或多个容器未被创建（比如：未拉取完镜像、pod未调度完成|
|Running|所有容器都被创建，至少有一个容器正在运行或重启|
|Succeed|所有容器都正常终止了，并且不会再启动|
|Failed|所有容器都终止了，至少有一个是失败的终止（即退出码不为0）|
|UnKown|因为某些原因无法取得 Pod 的状态，通常是因为与 Pod 所在主机通信失败|

![](./imgs/pod_01.jpg)

#### 2.pod conditions（pod状态）
影响字段：
```yaml
Pod.status.conditions
```
|Type|说明|Status</br>（True、False或Unkown）|lastProbeTime</br>（上次探测pod状态的时间戳）|lastTransitionTime</br>（从一个状态转换为另一种状态的时间戳）|reason</br>（状态切换的原因）|message</br>（对该状态切换的详细说明）|
|-|-|-|-|-|-|-|
|PodScheduled|该pod是否调度成功||||||
|Initialized|所有初始化容器是否启动成功||||||
|Ready|pod是否能够处理请求（可能只有一个containers处于就绪状态）||||||
|ContainersReady|所有容器是否都处于Ready状态||||||

</br>

#### 3.container states（容器状态）
影响字段:
```yaml
Pod.status.containerStatuses[].state
```
State|说明
-|-
Waiting|容器的默认状态
Running|成功执行了容器的启动命令和postStart钩子
Terminated|表明容器运行结束

</br>

#### 4.container probes（ 容器 探测）
探测是针对容器的，而不是pod
##### 4.1三种探针
每种探针可能的结果：Success，Failure，Unkown
探针|说明
-|-
exec|**执行指定命令**，如果该命令退出码为0，表明探测成功
tcpSocket|对**指定ip上的port**探测，如果这个ip上的**port**是**打开**的，表明探测成功
httpGet|对**指定ip上的port**探测，发送**GET请求**到这个ip:port，如果**返回码在200~400之间**，表明探测成功

</br>

##### 4.2三种情形下的探测
情形|语句|影响字段|说明（未设置则默认探测成功）|探测失败|何时需要这种情形的探测|
-|-|-|-|-|-
启动探测|startupProbe|`Pod.status.containerStatuses.started`|探测容器是否**启动**，只有这这个探测成功才会进行其他情形的探测|会kill该容器|当启动过慢时，如果不设置启动探测，就会进行存活和就绪探测，结果因为还没启动完成导致探测失败，导致容器被kill，是不合理的
存活探测|livenessProbe||探测容器是否**运行**|会kill该容器|当容器中的进程遇到问题或者不健康的状态时，**不会自行崩溃**
就绪探测|readinessProbe|`Pod.status.containerStatuses.ready`|探测容器是否**准备好提供服务**|会将该pod的地址，从对应的service的endpoints中删除|如果要**仅在探测成功时**才开始**向 Pod 发送流量**

</br>

#### 5.Init containers
##### 5.1 特点
* 总是运行到完成
* 多个init containers必须按顺序执行，init containers完成后才能运行其他容器
##### 5.2 使用init containers的好处
* init containers可以提供一些运维工具，如：sed、awk等
* Init 容器提供了一种机制来阻塞或延迟应用容器的启动，直到满足了一组先决条件。一旦前置条件满足，Pod内的所有的应用容器会并行启动

#### 6.Container Lifecycle Hooks（容器生命周期钩子）
* postStart
`Pod.spec.containers.lifecycle.postStart`
* preStop
`Pod.spec.containers.lifecycle.preStop`

#### 7.`kubectl get pods`能够查看到的pods状态
状态|说明
-|-
Init:N/M|有M个初始化容器，只有N个初始化容器执行成功
Init:Error|有一个初始化容器执行失败
Init:CrashLoopBackOff|有一个初始化容器多次执行失败
PodInitializing</br>Running|所有初始化容器都执行成功

***

### 资源清单

```yaml

spec:

  #设置使用的容器
  containers:
  - name: xx
    image: xx
    imagePullPolicy: xx

    #挂在逻辑卷
    volumeMounts:
    - name: xx
      mountPath: xx

  volumes:
  - name: xx
    configMap:
      name: xx

  #设置网络，当使用主机网络时，需要进行以下设置
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet      #必须设置这一项，不然无法访问到service
```
