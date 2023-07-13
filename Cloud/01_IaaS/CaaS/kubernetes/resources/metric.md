# metric

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [metric](#metric)
    - [概述](#概述)
      - [1.所有的指标都来自kubelet cadvisor](#1所有的指标都来自kubelet-cadvisor)
      - [2.metric分类](#2metric分类)
        - [（1）两类指标](#1两类指标)
        - [（2）三类metric api](#2三类metric-api)
      - [3.查看各个api中的指标](#3查看各个api中的指标)
        - [（1）查看`metrics.k8s.io` api](#1查看metricsk8sio-api)
        - [（2）查看`custom.metrics.k8s.io` api](#2查看custommetricsk8sio-api)
    - [部署](#部署)
      - [1.前提：apiserver需要`--enable-aggregator-routing=true`](#1前提apiserver需要-enable-aggregator-routingtrue)
      - [2.安装metrics-server](#2安装metrics-server)
      - [3.prometheus-adapter的rules](#3prometheus-adapter的rules)
        - [（1）rule的分类](#1rule的分类)
        - [（2）rule的四个部分](#2rule的四个部分)
        - [（3）rule的编写](#3rule的编写)
        - [（4）custom metrics API提供的某个指标的详情](#4custom-metrics-api提供的某个指标的详情)
      - [4.安装prometheus-adapter](#4安装prometheus-adapter)
        - [（1）`values.yaml`](#1valuesyaml)

<!-- /code_chunk_output -->

### 概述

#### 1.所有的指标都来自kubelet cadvisor
```shell
kubectl get --raw "/api/v1/nodes/node-1/proxy/metrics/cadvisor"
```

#### 2.metric分类

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

#### 3.查看各个api中的指标

##### （1）查看`metrics.k8s.io` api
```shell
kubectl get --raw '/apis/metrics.k8s.io/v1beta1'
kubectl get --raw '/apis/metrics.k8s.io/v1beta1/namespaces/default/pods'
```

##### （2）查看`custom.metrics.k8s.io` api
[参考](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/custom-metrics-api.md)
```shell
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1'

#后面查询必要具体到某个object
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/nfs-client-nfs-client-provisioner-58896ffb58-mwvb4/cpu_cfs_throttled'
#注意查看namespace的指标时，api中namespace不加s
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespace/default/cpu_cfs_throttled'
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
#当无法采集到所在node的 指标时，需要将网络模式设为host

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

#### 3.prometheus-adapter的rules

##### （1）rule的分类

|rules类型|说明|
|-|-|
|resourceRules|用于配置`metrics.k8s.io` api 提供的指标|
|resourceRules|用于配置`external.metrics.k8s.io` api 提供的指标|
|rules|用于配置`custom.metrics.k8s.io` api 提供的指标|

##### （2）rule的四个部分

|rules的部分|说明|
|-|-|
|discovery|发现该rule需要的所有prometheus指标|
|association|将prometheus metrics和k8s resources关联（比如某个指标是描述某个pod的，就需要通过在这里实现关联）|
|naming|将prometheus metrics中的名称 转换成 custom metrics API提供的指标的名称|
|querying|custom metrics API提供的指标的值是如何计算的|



##### （3）rule的编写
* discovery（发现）
匹配出需要转换的promtheus metrics
```yaml
#匹配符合要求的metrics
seriesQuery: '{__name__=~"^container_.*_total",container!="POD",namespace!="",pod!=""}'
#filters会对匹配出来的再进行一次过滤
seriesFilters:
  - isNot: "^container_.*_seconds_total"
````

* association（关联）
将prometheus metrics和k8s resources关联（比如某个指标是描述某个pod的，就需要通过在这里实现关联）
注意：label的值就是对应的k8s resource对象的名称
```yaml
#Group可以省略，不需要指明
#注意：需要明确namespace
#下面两种方式可以结合，主要使用第二种

#比如：有kube_<group>_<resource>这个标签的metric，且其中标签值为xx，则这个metric就会关联 叫xx的<resource>的对象
#比如：{kube_app_deployment = "nginx-ingress"}，则这个metric就会 关联 叫nginx-ingress的deployment对象（这里没有明确namespace，可以通过下面的设置明确namespace）
resources:
  template: "kube_<<.Group>>_<<.Resource>>"

#比如：{namespace: "test", "name": "pod-adsfdv"}，就会关联 test这个命名空间中的叫pod-adsfdv的pod
resources:
  overrides:
    namespace:
      resource: namespace
    name:
      resource: pod
```

* naming（命名）
将prometheus metrics中的名称 转换成 custom metrics API提供的指标的名称
```yaml
#这里是将<name>_total转换成<name>_per_second
#比如：http_requests_total 转换成 http_requests_per_second
name:
  matches: "^(.*)_total$" #当这里为空时，就相当于".*"，没有匹配到的就不会生成api提供的指标
  as: "${1}_per_second"   #当这里为空时，有匹配组时相当于"${1}"，没有匹配组时就相当于"${0}"
```

* querying（查询）
custom metrics API提供的指标的值是如何计算的
```yaml
metricsQuery: "sum(rate(<<.Series>>{<<.LabelMatchers>>}[2m])) by (<<.GroupBy>>)"
# <<.Series>>  代表prometheus metric的名字
# <<.LabelMatchers>> 代表label过滤，比如：namespace="kafka", pod=~"pod.*"
# <<.GroupBy>>  代表用什么分组，比如：pod
# 这些变量都已经默认定义好了
#在此基础上可以添加一些内容，比如container标签不能等于POD：
#metricsQuery: "sum(rate(<<.Series>>{<<.LabelMatchers>>,container!="POD"}[2m])) by (<<.GroupBy>>)"
```

##### （4）custom metrics API提供的某个指标的详情
```json
{
  "kind": "MetricValueList",
  "apiVersion": "custom.metrics.k8s.io/v1beta1",
  "metadata": {
      "selfLink": "/apis/custom.metrics.k8s.io/v1beta1/namespaces/kafka/pod/kafka-0/cpu_cfs_throttled"
  },
  "items": [
      {
          "describedObject": {
            //下面的信息通过association决定的
              "kind": "Pod",
              "namespace": "kafka",
              "name": "kafka-0",
              "apiVersion": "/v1"
          },

          //metricName由naming部分决定的
          "metricName": "cpu_cfs_throttled",   
          "timestamp": "2021-09-13T08:09:00Z",
          //value由quering部分决定的
          "value": "0",
          "selector": null
      }
  ]
}
```

#### 4.安装prometheus-adapter
将promethues指标转换成k8s的metric，通过metric api暴露出来

##### （1）`values.yaml`
```yaml

#配置prometheus地址（一定要配置）
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
          kubernetes_io_hostname:     #之前这里是node，由于描述node的metric没有这个node标签，导致无法查看node资源的使用率，现在改成这个就可以了
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
          kubernetes_io_hostname:
            resource: node
          namespace:
            resource: namespace
          pod:
            resource: pod
      containerLabel: container
    window: 3m
```
