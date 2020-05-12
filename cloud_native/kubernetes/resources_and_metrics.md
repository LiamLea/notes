[toc]
# resources
### 基础概念
#### 1.容器有两个维度的资源限制
```yaml
spec.resources.requests     #需求，最低保障
spec.resources.limits       #限制，硬限制
```

#### 2.cpu单位
```shell
1cpu代表1个虚拟cpu，即1个核心
1 cpu == 1000m cpu        #m是千分之一的意思
                          #500m cpu 就相当于 0.5 个cpu
```

#### 3.内存单位
```shell
  k（或K）	-- 		10^3 = 1000
  Ki		--		2^10 = 1024

  m（或M）	--		10^6 = 1000000
  Mi		--		2^20 = 1024*1024

#i：binary
```
#### 4.qos class（服务质量类型）
通过下面命令查看
```shell
kubectl describe pods xx
```
（1）guaranteed（高优先级）
  该pod内每个容器都设置了requests和limits，并且：
  内存的requests == 内存的limits
  cpu的requests == 内存的limits

（2）burstable（中优先级）

（3）besteffort（低优先级）
  该pod内没有一个容器设置requests和limits

**当资源不够用时，先杀死优先级的pod**

***
# metrics
### 基础概念
#### 1.两类指标
* 核心指标
由metrics-server采集，包括cpu、内存、磁盘等使用率
</br>
* 非核心指标（自定义指标）
由第三方组件采集，采集指标的范围更广

### 安装metrics-server

#### 1.下载yaml文件
```shell
github -> kubernetes -> cluster -> addons -> metrics-server
```

#### 2.修改metrics-server-deployment.yaml
```shell
修改kubelet-port端口，设置为实际的端口（ss -tulnp | grep kubelet）
```

#### 3.修改resource-reader.yaml
```shell
  在rules.resources下添加一项：
  - nodes/stats
```

#### 4.安装metrics-server
```shell
kubectl apply -f .
```

#### 5.验证
```shell
kubectl api-version     #会有metrics相关的项
kubectl top nodes
kubectl top pods
```

### 使用
#### 1.设置自定义指标

（1）安装prometheus

（2）安装kube-state-metrics		
用于将采集都的指标转换为k8s能够识别的格式

（3）安装k8s-prometheus-adapter
用于将自定义的指标整合为一个api服务，供k8s集群使用

#### 2.HPA（horizontal pod autoscaler）控制器

* 能够根据某些指标对在statefulSet、replicaSet等集合中的pod数量进行动态伸缩
* HPA目前支持四种类型的指标，分别是Resource、Object、External、Pods
* 其中在稳定版本autoscaling/v1中只支持对CPU指标的动态伸缩
```shell
kubectl autoscale TYPE NAME --min=xx --max=xx --cpu-percent=xx

#--cpu-percent用于设置每个pod的cpu利用不超过此处，如果超过了会自动添加pod
```
```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: xx
spec:
  scaleTargetRef:
    apiVersion: apps/v1
  kind: xx							#比如：Deployment
  name: xx
  minReplicas: xx
  maxReplicas: xx
  targetCPUUtilizationPercentage: xx
```
***
# kubelet Garbage Collection(垃圾回收)
### 基础概念
#### 1.垃圾回收分为两类
* imgae collection，镜像回收
* container collection，容器回收
#### 2.镜像回收
（1）两个参数
* image-gc-high-threshold（百分比）

* image-gc-low-threshold（百分比）

（2）镜像回收策略

磁盘使用率超过上限阈值将触发垃圾回收
垃圾回收将删除最近最少使用的镜像，直到磁盘使用率满足下限阈值

#### 3.容器回收
（1）三个参数
* MinAge
* MaxPerPodContainer
每个 pod 内允许存在的死亡容器的最大数量
* MaxContainers
全部死亡容器的最大数量

（2）容器回收策略
pod 内已经被删除的容器一旦年龄超过 MinAge 就会被清理

***

# resource limit
### 基础概念
#### 1.kubelet只支持两种文件系统
* nodefs
**kubelet** 用于存储volumes, daemon logs等等（即`/var/lib/kubelet/`目录下的**文件系统**）
</br>
* imagefs
**容器** 用于存储镜像和可写层（如果用的是overlay2驱动的话，image就是`/var/lib/docker/overlay2/`目录下的**文件系统**）
</br>

### 2.Eviction Policy(驱逐策略)

#### 2.1驱逐信号
|驱逐信号|说明|
|-|-|
|memory.available|memory.available = node.status.capacity.memory - memory.workingSet|
|nodefs.available|nodefs.available = fs.available|
|nodefs.inodesFree|nodefs.inodesFree = fs.inodesFree|
|imagefs.available|imagefs.available = imagefs.available|
|imagefs.inodesFree|imagefs.inodesFree = imagefs.inodesFree|

#### 2.2.驱逐阈值（可以是百分比，可以是有单位的数值）
* 如果 nodefs 文件系统满足驱逐阈值，kubelet通过**驱逐 pod 及其容器**来释放磁盘空间。
* 如果 imagefs 文件系统满足驱逐阈值，kubelet通过**删除所有未使用的镜像**来释放磁盘空间
##### （1）hard evication threshold
```yaml
evictionHard:
  imagefs.available: 15%
  memory.available: 100Mi
  nodefs.available: 10%
  nodefs.inodesFree: 5%
```
##### （2）soft evication threshold
```yaml
evictionSoft:
  memory.available: 1.5Gi

EvictionSoftGracePeriod:      #在驱逐 pod 前软驱逐阈值应该被控制的时长
  memory.available: 1m30s

EvictionMaxPodGracePeriod: 180    #当满足软驱逐阈值并终止 pod 时允许的最大宽限期值（秒数）

EvictionPressureTransitionPeriod: 180   #是 kubelet 从压力状态中退出之前必须等待的时长，防止节点在软驱逐阈值的上下振荡
```

#### 2.3.驱逐信号导致节点的状态
|节点状态|驱逐信号|
|-|-|
|MemoryPressure|memory.available|
|DiskPressure|nodefs.available</br>nodefs.inodesFree</br>imagefs.available</br>imagefs.inodesFree|
