# resources management

[toc]

### 概述

#### 1.kubelet只支持两种文件系统

##### （1） nodefs
**kubelet** 用于存储volumes, daemon logs等等
即`/var/lib/kubelet/`目录下的**文件系统**（包括其本身所在的文件系统和挂载在这个目录下的文件系统）

##### （2）imagefs
**容器** 用于存储镜像和可写层
如果用的是overlay2驱动的话，image就是`/var/lib/docker/overlay2/`目录下的**文件系统**（包括其本身所在的文件系统和挂载在这个目录下的文件系统）

#### 2.kubelet预留资源

##### （1）为k8s组件预留资源
```yaml
kubeReserved:
  cpu: xx
  memory: xx
  ephemeral: xx
```

##### （2）为系统（非k8s组件）预留资源
```yaml
systemReserved:
  cpu: xx
  memory: xx
  ephemeral: xx
```

#### 3.可用资源计算方法

```shell
Available = Capacity - kubeReserved - systemReserved - EvictionThreshold

#Available 表示总共可以使用的资源，不是剩余可以使用的资源
#Available 可以通过kubectl describe nodes xx可以查看到
#Capacity 表示这个资源的总量
#EvictionThreshold 如果是ephemeral-storage，这个阈值就是nodefs阈值的量
```

***

### Eviction Policy(驱逐策略)

#### 1.驱逐策略
* 当**资源的真实剩余量**小于**阈值**时，开始驱逐
* 或 当**k8s资源使用量**大于 **总共的可用量（Avaiable）** 时，开始驱逐

#### 2.驱逐信号
|驱逐信号|说明|
|-|-|
|memory.available|memory.available = node.status.capacity.memory - memory.workingSet|
|nodefs.available|nodefs.available = fs.available|
|nodefs.inodesFree|nodefs.inodesFree = fs.inodesFree|
|imagefs.available|imagefs.available = imagefs.available|
|imagefs.inodesFree|imagefs.inodesFree = imagefs.inodesFree|

#### 3.驱逐阈值（可以是百分比，可以是有单位的数值）
注意：nodefs和imagefs可能用的是不同的文件系统，所有者**两个阈值是没有任何关联的**
* 如果 nodefs 文件系统满足驱逐阈值，kubelet
  * 删除停止的pod及其容器
  * 删除未使用的镜像
</br>
* 如果 imagefs 文件系统满足驱逐阈值，kubelet通
  * 删除所有未使用的镜像
</br>
* 如果上面的操作还是无法释放更多的空间，kubelet就会**驱逐pod**来释放空间

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

#### 4.驱逐信号导致节点的状态
|节点状态|驱逐信号|
|-|-|
|MemoryPressure|memory.available|
|DiskPressure|nodefs.available</br>nodefs.inodesFree</br>imagefs.available</br>imagefs.inodesFree|

#### 5.ephemeral storage过低，导致相关资源被驱逐
* 当pod的ephemeral storage**超过**启动时设置的**limit**时，**该pod**会被**驱逐**
* 当node上的**ephemeral storage过低**时，node会给自己打上**short on local storage** **污点**，不能忍受这个污点的pods会被驱逐

#### 6.影响驱逐哪些pod的因素

##### （1）影响因素
* pod的资源使用率是否超过requests（所以与Qos有关）和资源使用情况
* pod的优先级

##### （2）驱逐算法
* 优先驱逐 资源使用量超过requests的pods
  * 根据pod的优先级和使用量的多少，进一步确定pod的驱逐顺序
* 最后驱逐 资源使用量小于requests的pods
  * 根据pod的优先级，进一步确定pod的驱逐顺序
