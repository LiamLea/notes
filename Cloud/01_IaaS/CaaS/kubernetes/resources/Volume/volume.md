# volume

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [volume](#volume)
    - [概述](#概述)
      - [1.在kubernetes中，存储卷是针对pod而言的，而不是container](#1在kubernetes中存储卷是针对pod而言的而不是container)
      - [2.存储卷种类](#2存储卷种类)
        - [（1）emptyDir](#1emptydir)
        - [（2）hostPath](#2hostpath)
        - [（3）local](#3local)
        - [（3）nfs](#3nfs)
        - [（4）PersistentVolumeClaim](#4persistentvolumeclaim)
        - [（5）ConfigMap（挂载时需要特别注意）](#5configmap挂载时需要特别注意)
      - [3.pvc](#3pvc)
      - [4.pv（是集群级别的资源，不属于某个名称空间，所有名称都可以用）](#4pv是集群级别的资源不属于某个名称空间所有名称都可以用)
        - [（1）与pvc关系](#1与pvc关系)
        - [（2）三种AccessModes](#2三种accessmodes)
        - [（3）两种pv reclaim policy（回收策略）](#3两种pv-reclaim-policy回收策略)
        - [（4）pv的4种阶段](#4pv的4种阶段)
      - [5.StorageClass](#5storageclass)
        - [（1）基本概念](#1基本概念)
        - [（2）StorageClass 资源是用于实现动态pv的](#2storageclass-资源是用于实现动态pv的)
      - [6.动态pv](#6动态pv)
      - [6.mountPath和subPath（注意！！！！！）](#6mountpath和subpath注意)
    - [基本使用](#基本使用)
      - [1.emptyDir的使用](#1emptydir的使用)
      - [2.hostPath的使用](#2hostpath的使用)
      - [3.nfs的使用](#3nfs的使用)
      - [4.pv和pvc的使用](#4pv和pvc的使用)
        - [（1）创建pv资源](#1创建pv资源)
        - [（2）创建pvc资源](#2创建pvc资源)
        - [（3）挂载pv](#3挂载pv)
      - [5.ConfigMap的使用](#5configmap的使用)
        - [（1）创建ConfigMap资源](#1创建configmap资源)
        - [（2）将ConfigMap中的配置注入pod](#2将configmap中的配置注入pod)
      - [7.动态pv（以nfs为例）](#7动态pv以nfs为例)
        - [（1）项目地址](#1项目地址)
        - [（2）存储信息](#2存储信息)
        - [（3）创建provisioner](#3创建provisioner)
        - [（4）创建StorageClass](#4创建storageclass)
        - [（5）创建一个pvc测试](#5创建一个pvc测试)
      - [8.local类型的pv的使用（使用指定node上的存储）](#8local类型的pv的使用使用指定node上的存储)
        - [（1）创建pv资源](#1创建pv资源-1)
        - [（2）使用该pv资源](#2使用该pv资源)
      - [9.创建动态local pv（新版本的k8s，不支持动态pv）](#9创建动态local-pv新版本的k8s不支持动态pv)
        - [（1）创建local pv provisioner](#1创建local-pv-provisioner)
        - [（2）创建storage class](#2创建storage-class)

<!-- /code_chunk_output -->

### 概述

#### 1.在kubernetes中，存储卷是针对pod而言的，而不是container
* 首先需要创建存储卷，即给基础架构容器创建存储卷
* 然后容器需要挂载存储卷，即使用基础架构容器的存储卷

#### 2.存储卷种类

##### （1）emptyDir
在节点上创建，当pod删除，该存储卷也会被删除

##### （2）hostPath
* 在pod所在节点上创建，当pod删除时，该存储卷不会被删除
* 当节点宕机了，pod就会调度到另一个节点上，数据就会丢失（可以利用nfs解决这种情况）

##### （3）local
跟hostPath类似
最大的区别是：**local volume与某个node绑定**
用于解决：**让pod使用指定node上的存储**
* 创建local类型的pv资源，该pv必须指定nodeAffinity，即该local只能在哪些node上创建
* 创建多个local类型的pv，并通过storageClassName进行分类
  比如这些pv是要给mysql用的，可以归类到pv-mysql这个类
* 使用时，指定storageClassName可以，动态从该类中的pv中，寻找符合要求的pv

##### （3）nfs
用nfs服务器提供的目录

##### （4）PersistentVolumeClaim

##### （5）ConfigMap（挂载时需要特别注意）
* 挂载configMap类型的存储卷，则该configMap中的键名就是文件名，键值就是文件内容
  比如，configMap中一个键值对为 aa=bb，则会在容器内的挂载目录下生成名为aa的文件，文件的内容为bb
</br>
* configmap通过volume方式挂载到容器内后，修改configmap，容器内的挂载内容也会更新（**例外**：当挂载时使用了subPath时，容器内挂载的内容不会自动更新）

#### 3.pvc

persistent volume claim，是一种资源
是一个抽象的概念，根据设定的条件，绑定相应的pv资源（和pv是一一对应的关系）
* 会自动匹配符合条件的pv，从而进行绑定
* 动态pv则是会自动生成pv，然后与之绑定

#### 4.pv（是集群级别的资源，不属于某个名称空间，所有名称都可以用）
  persistent volume，是一种资源
  是存储卷，映射到指定的后端存储空间（能够映射各种存储空间）


##### （1）与pvc关系
通过`claimRef`字段，建立与pvc的关系
```shell
kubectl get pv <PV> -o yaml
```

#####  （2）三种AccessModes
* ReadWriteMany
能被多个节点以读写方式挂载
</br>
* ReadWriteOnce
只能被一个节点以读写方式挂载
</br>
* ReadOnlyMany

##### （3）两种pv reclaim policy（回收策略）

不管哪种策略，实际并没有删除磁盘上的数据，删除的只是k8s资源

* Retain（静态pv默认）
  * 当删除与其绑定的pvc，将对应的pv状态置为released（即不对pv进行回收）
  * 但是该pv是无法使用的，因为其还保留了pvc的信息（`claimRef`）
  * 删除`claimRef`字段，就可以使用该pv了

* Delete（动态pv默认）
  * 当删除与其绑定的pvc，对应的pv也会被删除（即对pv进行回收）
    * 动态nfs还会把使用的目录打包，逻辑相当于删除了数据，实际是没有删除的
  * 一般只有动态pv能设置Delete回收策略

##### （4）pv的4种阶段
* Avaliable
  * 可使用的状态
* Bound
  * 被使用的状态
* Released
  * 对应的pvc被删除了，但集群还未回收该pv（即该pv无法使用）
* Failed
  * 自动回收该pv失败了

#### 5.StorageClass

##### （1）基本概念
* 默认pv是不属于任何StroageClass的
  * 创建pv时，设置storageClassName，将该pv划分为某一类中
  * 使用pv时，指定storageClassName，只会使用该类型中符合要求的pv
* 利用StorageClass可以对pv进行分类，使用时指定StorageClass，就在该类型的pv中寻找符合要求的pv

##### （2）StorageClass 资源是用于实现动态pv的

#### 6.动态pv
* 当创建pvc后，会自动生成pv与之绑定
* 自动创建的 PV ，会在nfs上生成目录：`${namespace}-${pvcName}-${pvName}`
* 而当这个PV被回收后，在nfs上生成的目录会被改名：`archieved-${namespace}-${pvcName}-${pvName}`


#### 6.mountPath和subPath（注意！！！！！）
mount操作 是将 volume 挂载 进容器内，所以volume中的内容会覆盖容器中的内容
* mounPath	指定容器内的挂载点
* subPath	指定volume中的路径，如果没有则创建
  * 没有subPath，则将volume挂载到挂载点上
  * 有subPath，则将volume中的某个路径挂载到挂载点上
  ```
  比如：mountPath为/tmp/test，subPath没设置，则将volume挂载到/tmp/test上
  比如：mountPath为/tmp/test，subPath为test，则把volume/test挂载到/tmp/test上
  ```

***

### 基本使用

#### 1.emptyDir的使用
创建一个自主式pod，使用emptyDir存储卷
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  labels:
    xx: xx
spec:
  containers:
  - name: xx
    image: xx
    volumeMounts:       #存储卷属于pod，容器需要挂载存储卷才能使用
    - name: xx          #已经存在的存储卷的名字
      mountPath: xx     #挂载点
  volumes:              #创建存储卷
  - name: xx
    emptyDir: {}        #empty是对象（即字典），{}表示为空，即使用默认值
```

#### 2.hostPath的使用
创建一个自主式pod，使用hostPath存储卷
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  labels:
    xx: xx
spec:
  containers:
  - name: xx
    image: xx
    volumeMounts:
    - name: xx          #使用的已存在的存储卷的名字
      mountPath: xx     #挂载点
  volumes:
  - name: xx
    hostPath:
      path: xx          #节点上的路径
      type: xx          #有多种类型，其中DirectoryOrCreate，表示path是一个目录，如果该目录不能存在则创建
```

#### 3.nfs的使用
创建一个自主式pod，使用nfs存储卷
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  labels:
    xx: xx
spec:
  containers:
  - name: xx
    image: xx
    volumeMounts:
    - name: xx          #使用的已存在的存储卷的名字
      mountPath: xx     #挂载点
  volumes:
  - name: xx
    nfs:
      path: xx
      server: xx        #ip地址
```

#### 4.pv和pvc的使用

##### （1）创建pv资源
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: xx
  labels:
    xx: xx
spec:
  nfs:              #这里指明存储空间的类型，这里用的是nfs
    path: xx
    server: xx
  accessModes: ["ReadWriteMany","ReadWriteOnce"]
  capacity:
    storage: xx     #描述该pv的容量（单位：Ki，Mi，Gi，...）
                    #注意：不是允许使用的容量，只是描述信息，便于pvc用来绑定相应的pv
  persistenVolumeReclaimPolicy: Retain

---     #这个是分隔符，下面可以定义其他资源

apiVersion: v1
kind: PersistentVolume
metadata:
  name: xx
  labels:
    xx: xx
spec:
  rbd:                #这里指明存储空间的类型，这里用的是rbd
    image: xx
    ... ...
  accessModes: ["RWX"]
  capacity:
    storage: xx
```

##### （2）创建pvc资源
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: xx
  namespace: default                #需要与pod在同一名称空间中
spec:
  accessModes: ["ReadWriteMany"]    #必须是pv定义的accessMode的子集
  resources:
    requests:
      storage: xx     #单位（Ki，Mi，Gi，...）
  selector:           #如果不用标签选择器进行选择，会根据要求自动选择符合要求的pv进行绑定
    matchLabels:
      xx1: xx
      xx2: xx
```
##### （3）挂载pv
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  namespace: default
spec:
  containers:
  - name: xx
    image: xx
    volumeMounts:
    - name: xx
      mountPath: xx
  volumes:
  - name: xx
    persistentVolumeClaim:
      claimName: xx           #指定已经存在的pvc的名字
```

#### 5.ConfigMap的使用

##### （1）创建ConfigMap资源
* 命令行
```shell
kubectl create configmap xx
        --from-file=文件路径      #文件名就是键，文件内容就是值
        --from-file=xx=文件路径   #xx就是键，文件内容就是值
        --from-literal=xx1=xx2   #xx1就是键，xx2就是值
```
* 清单格式：
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: xx
  namespace: websphere
data:
  xx: |      #使用“|”标注的文本内容缩进表示的块，可以保留块中已有的回车换行
    xxx
    xxx
    ...
```

##### （2）将ConfigMap中的配置注入pod
* 通过env的方式
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  namespace: default
  labels:
    xx1: xx
    xx2: xx
spec:
  containers:
  - name: xx
    image: xx
    env:
    - name: xx            #这里的xx为 新的环境变量的名字
      valueFrom:
        configMapKeyRef:
          name: xx        #这里的xx为 某个configMap的名字
          key: xx         #这里的xx为 该configMap种的某个键名
```
* 使用存储卷的方式
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xx
  namespace: default
  labels:
    xx1: xx
    xx2: xx
spec:
  containers:
  - name: xx
    image: xx
    volumeMounts:
    - name: xx          #xx为存储卷的名字
      mountPath: xx     #mounPath用于指定挂载点
      subPath: xx
  volumes:              #创建存储卷
  - name: xx            #xx为该存储卷取名字
    configMap:          #存储卷的类型为configMap
      name: xx          #xx为已经存在的configMap的名字

#注意：挂载configMap后
#键名就是文件名
#键值就是文件的内容
```

#### 7.动态pv（以nfs为例）
前提：运行该Pod的机器上都需要安装nfs-utils

可以直接通过helm安装：
```shell
helm install my-nfs-release \
  --set nfs.server=192.168.33.12 \
  --set nfs.path=/mnt/dev \
  stable/nfs-client-provisioner
```

##### （1）项目地址
* 在github kubernetes-incubator/external-storage/nfs-client中有nfs相关的yaml文件
* 在github上搜索external-storage就出来了

##### （2）存储信息
* 自动创建的pv,在nfs下创建的目录名：`<namespace>-<pvcName>-<pvName>`
* 当这个pv被删除后，会存储在nfs上，命名：`archieved-<namespace>-<pvcName>-<pvName>-<id>`

##### （3）创建provisioner
```shell
#如果需要部署到其他名称空间，则要修改清单文件

kubectl apply -f rbac.yaml        #授权

#修改deploment中nfs的信息后，在创建
#最重要的一项是PROVISIONER_NAME，这个是设置该provisioner的名字，后面Storage需要指定这个名字，才能使用
#  env:
#  - name: PROVISIONER_NAME
#    value: xx

kubectl apply -f deployment.yaml    #创建provisioner（即nfs的客户端）
```

##### （4）创建StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    #可以设置成默认的storageClass
    storageclass.kubernetes.io/is-default-class: "true"   
  name: xx            #重要，用于指定storage class的名字
provisioner: xx       #重要，需要指定上面创建的provisioner
reclaimPolicy: xx     #默认是Delete，即删除pvc，则自动删除对应的pv
                      #如果设置成Retain，即删除pvc，不自动删除对应的pv
```

##### （5）创建一个pvc测试

指定使用的storage class
会自动创建pv，并与该pvc绑定
```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim

#  annotations:
#    volume.beta.kubernetes.io/storage-class: xx
#这里等价于storageClassName: xx
#不过这种方式以后会丢弃

spec:
  storageClassName: xx        #这项十分重要，用于指定使用哪个storage class
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
```

#### 8.local类型的pv的使用（使用指定node上的存储）

##### （1）创建pv资源
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: xx
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: xx    #将该pv划分到某一个类中
  local:
    path: /tmp/mnt      #可以为目录的路径（该路径必须存在），也可以是块设备
                        #如果是块设备，必须设置fsType字段，即将该块设备格式化成什么文件系统
  #这一项必须要设置
  #用于指定该local能够应用于哪些node上（即只会在符合要求的node上，使用local存储）
  #所以使用了该pv的pod也会被调度到符合要求的node上
  nodeAffinity:        
    required:
      nodeSelectorTerms:

        #利用标签选择node
      - matchExpressions:    
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-1
```

##### （2）使用该pv资源
```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim

spec:
  storageClassName: xx       #这项十分重要，用于指定使用哪个storage class
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi

```

#### 9.创建动态local pv（新版本的k8s，不支持动态pv）

##### （1）创建local pv provisioner
```yaml
---
# Source: provisioner/templates/provisioner.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: local-provisioner-config
  namespace: default
data:
  useNodeNameOnly: "true"
  #下面那个名称（xxxx）很重要，需要根据这个创建storage class
  storageClassMap: |
    xxxx:      
       hostDir: /mnt/disks-by-id
       mountDir: /mnt/disks-by-id
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: local-volume-provisioner
  namespace: default
  labels:
    app: local-volume-provisioner
spec:
  selector:
    matchLabels:
      app: local-volume-provisioner
  template:
    metadata:
      labels:
        app: local-volume-provisioner
    spec:
      serviceAccountName: local-storage-admin
      containers:
      - image: "quay.io/external_storage/local-volume-provisioner:v2.2.0"
        name: provisioner
        securityContext:
          privileged: true
        env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        volumeMounts:
        - mountPath: /etc/provisioner/config
          name: provisioner-config
          readOnly: true
        - mountPath: /mnt/disks-by-id
          name: local-storage
          mountPropagation: "HostToContainer"
      volumes:
      - name: provisioner-config
        configMap:
          name: local-provisioner-config
      - name: local-storage
        hostPath:
          path: /mnt/disks-by-id
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: local-storage-admin
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: local-storage-provisioner-pv-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: local-storage-admin
  namespace: default
roleRef:
  kind: ClusterRole
  name: system:persistent-volume-provisioner
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: local-storage-provisioner-node-clusterrole
  namespace: default
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: local-storage-provisioner-node-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: local-storage-admin
  namespace: default
roleRef:
  kind: ClusterRole
  name: local-storage-provisioner-node-clusterrole
  apiGroup: rbac.authorization.k8s.io
```

##### （2）创建storage class
```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: xxxx      #这个是根据上面的配置决定的（从而关联起来）

#kubernetes.io/no-provisioner表示这是个动态loal pv
provisioner: kubernetes.io/no-provisioner

#WaitForFirstConsumer：当pod被调度后，才会创建pv与相应的pvc绑定
#Immediate：立即将pvc和pv绑定
volumeBindingMode: WaitForFirstConsumer   

reclaimPolicy: Retain
```
