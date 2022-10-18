# controllers

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [controllers](#controllers)
    - [概述](#概述)
      - [1.controller定义](#1controller定义)
      - [2.owner and dependent](#2owner-and-dependent)
    - [控制器](#控制器)
      - [1.ReplicaSet](#1replicaset)
        - [（1）特点](#1特点)
        - [（2）资源清单](#2资源清单)
      - [2.Deployment](#2deployment)
        - [（1）特点](#1特点-1)
        - [（2）更新（生成新版本）](#2更新生成新版本)
        - [（3）有两种更新策略（strategy）](#3有两种更新策略strategy)
        - [（4）资源清单](#4资源清单)
      - [3.DaemonSet（两种更新策略：OnDelete和RollingUpdate，只能先删再更新）](#3daemonset两种更新策略ondelete和rollingupdate只能先删再更新)
        - [（1）特点](#1特点-2)
        - [（2）清单内容](#2清单内容)
      - [4.StatefulSet](#4statefulset)
        - [（1）特点](#1特点-3)
        - [（2）为什么pod是有状态的](#2为什么pod是有状态的)
        - [（3）注意](#3注意)
        - [（4）其他](#4其他)
        - [（5）更新策略](#5更新策略)
        - [（6）创建statefulSet控制器](#6创建statefulset控制器)
      - [5.Job](#5job)
      - [6.Cronjob](#6cronjob)
    - [运维](#运维)
      - [1.更新](#1更新)
      - [2.回滚](#2回滚)
      - [3.暂停和恢复](#3暂停和恢复)

<!-- /code_chunk_output -->

### 概述

#### 1.controller定义
* **监视**集群的状态，**调整**集群的状态到**更接近** **期望**的状态
  * 通过**监视apiserver**，从而监视集群的状态
  * controller中的spec字段 就是 期望的状态

#### 2.owner and dependent
用来描述资源的关系，
一个controller是一组pod的所有者，对应的这些pod，从属于该controller
可以通过`metadata.ownerReferences`能够查看该资源（pod或控制器）的所有者

***

### 控制器

#### 1.ReplicaSet

##### （1）特点
用于创建pod的副本，并且控制pod副本的数量达到要求

##### （2）资源清单
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadate:
  name: xx
  namespace: default
spec:
  replicas: xx

  selector:         
  #有两种选择器：matchLabels，matchExpressions
  #用于选择需要管理的pod，template里会定义相应pod，所以metadata所定义的标签，这里要包含

    matchLabels:
      xx1: xx
      xx2: xx

  template:     #用来定义pod的模板（跟pod的清单基本上一样）

    metadata:   #不用指定pod的名字，因为会以 "控制器名-xx" 来命名pod
      labels:   #这里的标签一定要符合上面的selector的要求
        xx1: xx
        xx2: xx
    spec:
      containers:
      - name: xx
        image: xx
```

#### 2.Deployment

##### （1）特点
* Deployment管理ReplicaSet
  * Deployment有版本的概念，支持回滚
  * 一个版本对应一个ReplicaSet
* ReplicaSet管理pod

##### （2）更新（生成新版本）
当Deployment的**Pod template改变**，就会生成一个新的版本（即一个新的ReplicaSet）
之前的ReplicaSet不会删除，只会将之前的ReplicaSet的pod的数量置为0

##### （3）有两种更新策略（strategy）
* Recreate				
  * 删一个，建一个

* RollingUpdate（默认）
  * 根据定义的最大多出数量和最少不可获得数量进行相应的操作
  * 比如：最少不可获得的数量为1，就需要先创建一个，再删除一个，保证最少不可获得的数量为1

##### （4）资源清单
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xx
  namespace: default
spec:
  replicas: xx
  selector:
    matchLabels:
      xx1: xx
      xx2: xx

  revisionHistoryLimit: <NUM>   #保存的版本数
  strategy:                   #指定更新策略
    type: xx
    rollingUpdate:            #当更新策略为RollingUpdate（默认的策略），这项才有效
      maxSurge: xx            #最大多出的数量
      maxUnavailable: xx      #最少不可获得数量

  template:
    metadata:     
    #不用指定pod的名字，会自动设置Pod的名字
    #pod的名字：Deployment控制器的名字-xx-xx（其中"Deployment控制器的名字-xx"为生成的ReplicaSet控制器的名字）
      labels:
        xx1: xx
        xx2: xx
    spec:
      containers:
      - name: xx
        image: xx
```

#### 3.DaemonSet（两种更新策略：OnDelete和RollingUpdate，只能先删再更新）

##### （1）特点
确保符合条件的node上只运行指定pod的一个副本

##### （2）清单内容
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: xx
  namespace: default
spec:
  selector:
    matchLabels:
      xx1: xx
      xx2: xx
  template:
    metadata:
      labels:
        xx1: xx
        xx2: xx
    spec:
      containers:
      - name: xx
        image: xx
        env:
        - name: 变量名
          value: 变量值
```

#### 4.StatefulSet

##### （1）特点
* pod是有序的
  * 生成是按照{0..N-1}顺序生成的
    * 只有当前一个pod运行且处于就绪状态，才会部署下一个pod
  * 删除是逆序删除的
    * 只有当前一个pod被删除了，才会删除下一下pod
</br>
* pod有唯一的标识符
  * pod的名称：`<STATEFULSET_NAME>-<ORDINAL>`
</br>
* pod有唯一的网络标识（即域名，需要**headless service**）
  * 该pod所在的域由该headless service标识
  * 所以pod的域名为：`<POD_NAME>.<SERVICE_NAME>.<NAMESPACE>.svc.<CLUSTERNAME>`
</br>
* 当pod所在的node宕机或者跟master失去连接后
  * pod不会转移（因为防止由于网络原因，导致两个同样的pod存在）
  * 解决：
    * 确保不会同时存在两个同样的pod情况下，强制delete那个pod
    * 或者修复有问题的那个节点

##### （2）为什么pod是有状态的
* 每个pod都有一个唯一的标识符，和volume绑定时使用的是这个标识符
  * 所以，当重新创建pod，会根据标识符与已存在的volume绑定
  * 从而实现了有状态的

##### （3）注意
* pvc要在清单文件中指定
* 删除StatefulSet，pvc不会被删除
* 需要先创建一个headless service
* 删除StatefulSet，不保证pod一定会被删除，所以删除StatefulSet前，先将scale降为0

##### （4）其他
StatefulSet会为每个Pod添加一个标签：`statefulset.kubernetes.io/pod-name`，这样可以为每个pod单独设置一个svc

##### （5）更新策略
* OnDelete
需要手动删除pod，那个pod才会更新
</br>
* RollingUpdate（默认）
删除一个pod，重新创建，每次只会更新一个pod，只有当该pod更新好，才会更新下一个
  * `spec.updateStrategy.rollingUpdate.partition: <ORDINAL>`
    * 大于等于这个序号的pod才会被更新
    * 小于这个序号的pod不会更新，即使删除了该pod，重新生成的也是旧的
  * 当更新模板后，引入一个问题，导致pod无法运行，回滚后，需要将当前有问题的pod先删除


##### （6）创建statefulSet控制器
```yaml
#创建headless-service
apiVersion: v1
kind: Service
metadata:
  name: xx
  labels:
    xx: xx
spec:
  ports:
  - port: 80
    name: xx         #标记该端口
  clusterIP: Node    #设置成无头的service
  selector:
    xx: xx           #通过标签关联pod

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: xx
spec:
  serviceName: xx      #用于控制由statefulSet创建的pods所在的域
  replicas: xx
  selector:
    matchLabels:
      xx: xx        #通过标签关联pod，需要和无头的service设置成一样，因为他们需要关联相同的pod

  template:
    metedata:
      labels:
        xx: xx      #给创建的pod打上标签，需要与上面设置的一样
    spec:
      containers:
      - name: xx
        image: xx
        ports:
        - containerPort: xx     #声明要暴露的端口
          name: xx
        volumeMounts:
        - name: xx          #volume的名字
          mountPath: xx

  volumeClaimTemplates:     #这是一个模板，用于创建一个pvc

#用这个模板的意义在于：
#通过此方式创建的pv，statefulSet会唯一标识，并且与指定pod唯一对应
#从而保证了能够维护pod的状态

#注意：通过这种方式创建的pvc，删除资源时，pvc不会被删除

  - metadata:
      name: xx            #创建的volume的名字
    spec:
      accessModes: ["RWO"]
      resources:
        requests:
          storage: 2Gi
          #设置pv需要满足2Gi的条件（i代表按1024计算）
          #会自动匹配到符合条件的pv，并进行绑定
```

#### 5.Job
只要指定pod完成特定任务后退出，即不会再重启pod

#### 6.Cronjob
周期性运行

***

### 运维

#### 1.更新

#### 2.回滚
* 查看某一个controller所有版本
```shell
kubectl rollout history <CONTROLLER_TYPE> <CONTROLLER_NAME>
```

* 查看某一个controller某一版本的详细信息
```shell
kubectl rollout history <CONTROLLER_TYPE> <CONTROLLER_NAME> --revision=<NUMBER>
```

* 回滚到指定版本
```shell
kubectl rollout undo <CONTROLLER_TYPE> <CONTROLLER_NAME> --to-revision=<NUMBER>   #当为0时，表示回滚到最新版本
```

#### 3.暂停和恢复

* 暂停
```shell
kubectl rollout pause <CONTROLLER_TYPE> <CONTROLLER_NAME>
```

* 恢复
```shell
kubectl rollout resume <CONTROLLER_TYPE> <CONTROLLER_NAME>
```
