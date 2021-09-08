# metric

[toc]

### 概述

#### 1.metric分类

##### （1）两类指标

|类别|说明|
|-|-|
|核心指标|由metrics-server采集，包括cpu、内存、磁盘等使用率|
|非核心指标（自定义指标）|由第三方组件采集，采集指标的范围更广|

##### （2）三类metric api

|metric api类型|api|需要的组件（负责提供api）|说明|
|-|-|-|-|
|资源metric api|`metrics.k8s.io`|prometheus-adapter（或metrics-server）|metrcis-server：kubelet的cadvisor会收集pods的指标（cpu和内存）， metrcis-server只不过把通过api的方式暴露出来</br>prometheus-adapter：利用的是prometheus中的指标|
|自定义metric api|`custom.metrics.k8s.io`|prometheus-adapter||
|外部metric api|`external.metrics.k8s.io`|prometheus-adapter||

#### 2.查看各个api中的指标

##### （1）查看`metrics.k8s.io` api
```shell
kubectl get --raw '/apis/metrics.k8s.io/v1beta1'
kubectl get --raw '/apis/metrics.k8s.io/v1beta1/namespaces/default/pods'
```

##### （2）查看`custom.metrics.k8s.io` api
```shell
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1'

#后面查询必要具体到某个object
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/nfs-client-nfs-client-provisioner-58896ffb58-mwvb4/threads'
```

***

### 部署

#### 1.前提：apiserver需要`--enable-aggregator-routing=true`

#### 2.安装metrics-server

* 添加chart仓库
```shell
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

* 安装
```shell
helm install metrics-server stable/metrics-server -n kube-system \
  --set args[0]="--kubelet-port=10250" \
  --set args[1]="--kubelet-insecure-tls" \
  --set args[2]="--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP"
```

* 验证
```shell
kubectl api-version     #会有metrics相关的项
kubectl top nodes
kubectl top pods
```

#### 3.配置prometheus-adapter的rules

##### （1）resourceRules
用于配置`metrics.k8s.io` api 提供的指标

##### （2）resourceRules
用于配置`external.metrics.k8s.io` api 提供的指标

##### （3）rules
用于配置`custom.metrics.k8s.io` api 提供的指标

#### 4.安装prometheus-adapter
将promethues指标转换成k8s的metric，通过metric api暴露出来

##### （1）`values.yaml`
```yaml

#配置prometheus地址
prometheus:
  url: http://prometheus-server.monitor
  port: 80
  path: ""


#配置转换规则（即将哪些prometheues指标转换成k8s的metric
rules:
  #提供custom.metrics.k8s.io api
  default: true     #default使用默认暴露的一些指标
  custom: []        #添加其他需要暴露的指标（自定义）

  #提供external.metrics.k8s.io api
  external: []

  #提供metrics.k8s.io api
  resource:
    cpu:
      containerQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>, container!=""}[3m])) by (<<.GroupBy>>)
      nodeQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>, id='/'}[3m])) by (<<.GroupBy>>)
      resources:
        overrides:
          node:
            resource: node
          namespace:
            resource: namespace
          pod:
            resource: pod
      containerLabel: container
    memory:
      containerQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>, container!=""}) by (<<.GroupBy>>)
      nodeQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>,id='/'}) by (<<.GroupBy>>)
      resources:
        overrides:
          node:
            resource: node
          namespace:
            resource: namespace
          pod:
            resource: pod
      containerLabel: container
    window: 3m
```
