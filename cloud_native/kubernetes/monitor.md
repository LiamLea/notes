[toc]
# metrics-server
### 概述
#### 1.metrics-server特点
* kubelet的cadvisor会收集指标（cpu和内存）,从而能够合适的调度pod
* metrcis-server只不过把通过api的方式暴露出来，
### 安装
metrcs-server通过api方式暴露k8s集群的指标
#### 1.下载yaml文件
```shell
github -> kubernetes -> cluster -> addons -> metrics-server
```

#### 2.修改metrics-server-deployment.yaml
修改kubelet-port端口，设置为实际的端口（ss -tulnp | grep kubelet）
```yaml
command:
  - /metrics-server
  - --metric-resolution=30s
  - --kubelet-port=10250
  - --kubelet-insecure-tls
  - --kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP
```

#### 3.修改resource-reader.yaml
```yaml
#在rules.resources下添加一项：
rules.resources:
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
***
# kube-state-metrics
apiserver需要设置：`--enable-aggregator-routing=true`
### 概述
#### 1.kube-state-metrics特点
* 监听aip-server，获取资源实例的状态（包括副本数、标签、运行时间等等）
### 安装
利用helm进行安装
```shell
helm fetch stable/kube-state-metrics
```
