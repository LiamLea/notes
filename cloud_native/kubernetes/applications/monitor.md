[toc]
# metrics-server
### 概述
#### 1.metrics-server特点
* kubelet的cadvisor会收集指标（cpu和内存）,从而能够合适的调度pod
* metrcis-server只不过把通过api的方式暴露出来，
### 安装
metrcs-server通过api方式暴露k8s集群的指标

**前提**：apiserver需要配置`--enable-aggregator-routing=true`

#### 1.添加chart仓库
```shell
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

#### 2.安装
```shell
helm insall metrics-server stable/metrics-server -n kube-system \
  --set args[0]="--kubelet-port=10250" \
  --set args[1]="--kubelet-insecure-tls" \
  --set args[2]="--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP"
```

#### 3.验证
```shell
kubectl api-version     #会有metrics相关的项
kubectl top nodes
kubectl top pods
```

***

# kube-state-metrics

### 概述
#### 1.kube-state-metrics特点
* 获取集群信息（而不是单个组件的），转换为prometheus的监控指标（供prometheus采集）
* 监听aip-server，获取资源实例的状态（包括副本数、标签、运行时间等等）
### 安装
利用helm进行安装
```shell
helm fetch stable/kube-state-metrics
```
