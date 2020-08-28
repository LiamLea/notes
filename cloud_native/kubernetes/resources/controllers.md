# controllers
[toc]
### 概述
#### 1.定义
* **监视**集群的状态，**调整**集群的状态到**更接近** **期望**的状态
  * 通过监视apiserver，从而监视集群的状态
  * controller中的spec字段 就是 期望的状态
#### 2.pod控制器类型
|Controller|说明|
|-|-|
|ReplicaSet|用于创建pod的副本，并且控制pod副本的数量达到要求|
|Deployment|工作在ReplicaSet之上，功能更强大</br>三层架构：</br>&emsp;Deployment控制ReplicaSet（可能有多个）</br>&emsp;ReplicaSet控制pods</br>&emsp;查看pods的详细信息时，显示的控制器也是ReplicaSet
|DaemonSet|确保符合条件的node上只运行指定pod的一个副本|
|Job|只要指定pod完成特定任务后退出，即不会再重启pod|
|Cronjob|周期性运行|
|StatefulSet|管理有状态的pod|

***

### 使用
#### 1.ReplicaSet
##### （1）资源清单
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

##### （1）有两种更新策略（strategy）
* Recreate				
  * 删一个，建一个
  </br>
* RollingUpdate			
  * 根据定义的最大多出数量和最少不可获得数量进行相应的操作
  * 比如：最少不可获得的数量为1，就需要先创建一个，再删除一个，保证最少不可获得的数量为1

##### （2）更新的原理
* 会创建新的ReplicaSet来控制更新后的pods
* 原来的ReplicaSet不会删除，可以方便回滚（回滚：使得相应的ReplicaSet开始工作，使其它的不工作）
* 默认保留的ReplcaSet数量为10

##### （3）资源清单
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
##### （4）回滚
```shell
#查看有多少个版本，和版本号
kubectl rollout history TYPE NAME		

#查看每个版本具体的ReplicaSet
kubectl get rs -l xx1=xx -o wide

kubectl rollout undo TYPE NAME
#默认回滚到上一个版本
#--to-revision=版本号，回滚到指定版本
```

#### 3.DaemonSet（两种更新策略：OnDelete和RollingUpdate，只能先删再更新）

##### （1）清单内容
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
#### 4.statefulSet（是控制器）
##### （1）pod是有状态的
* pod是有序的
* pod名称是稳定、持久、有效、唯一：`<STATEFULSET_NAME>-<NUMBER>`
* 重新创建pod，创建顺序是一定的，绑定的volume也是对应的

##### （2）需要关联service
注意：只有通过StatefulSet控制器创建的pod才有域名
* 该service用于控制 该StatefulSet控制器创建的pod 所在的域
所以
  * service必须在StatefulSet前创建（因为需要用service控制pods所在的域，从而给每一个pod设置一个唯一的域名）
  * service和StatefulSet必须绑定相同的pod
</br>
* StatefulSet会为其管理的 pod 设置域名解析（在DNS中添加解析记录），所以唯一标识了一个pod
  * 所在的域即是该service的域，所以pod的域名为：`<POD_NAME>.<SERVICE_NAME>.<NAMESPACE>.svc.<CLUSTERNAME>`


##### （3）修改更新策略：
```yaml
spec.updateStrategy.rollingUpdate.partition: N
#N默认等于0，即更新所有
#当pod的数字>=N时才会被更新，从而可以控制更新测试
```

##### （4）创建statefulSet控制器
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
