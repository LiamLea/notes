# metrics

[toc]

### 概述

#### 1.两类指标

##### （1）核心指标

由metrics-server采集，包括cpu、内存、磁盘等使用率

##### （2）非核心指标（自定义指标）
由第三方组件采集，采集指标的范围更广

***

### 使用

#### 1.设置自定义指标

##### （1）安装prometheus

##### （2）安装kube-state-metrics		
转换为prometheus的监控指标（供prometheus采集）

##### （3）安装k8s-prometheus-adapter
* 用于将prometheus的指标整合为一个api服务（autoscaling/v2beta1），供k8s的HPA使用
* apiserver需要设置允许api聚合：`--enable-aggregator-routing=true`

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

#### 3.VPA（Vertical Pod Autoscaler）控制器
Lower bound — the minimum resource recommended for the container.
Upper Bound — the maximum resource recommended for the container.
Uncapped Target — the previous recommendation from the autoscaler.
参考：https://learnk8s.io/setting-cpu-memory-limits-requests
