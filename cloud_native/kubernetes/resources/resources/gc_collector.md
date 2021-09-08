# kubelet Garbage Collection(垃圾回收)

[toc]

### 基础概念

#### 1.垃圾回收分为两类

* imgae collection，镜像回收
* container collection，容器回收

#### 2.镜像回收

##### （1）两个参数
* image-gc-high-threshold（百分比）
* image-gc-low-threshold（百分比）

##### （2）镜像回收策略

磁盘使用率超过上限阈值将触发垃圾回收
垃圾回收将删除最近最少使用的镜像，直到磁盘使用率满足下限阈值

#### 3.容器回收

##### （1）三个参数
* MinAge
* MaxPerPodContainer
每个 pod 内允许存在的死亡容器的最大数量
* MaxContainers
全部死亡容器的最大数量

##### （2）容器回收策略
pod 内已经被删除的容器一旦年龄超过 MinAge 就会被清理
