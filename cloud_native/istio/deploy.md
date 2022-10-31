# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署istio](#部署istio)
      - [1.安装istio](#1安装istio)
        - [（1）profile](#1profile)
        - [（2）安装istio](#2安装istio)
        - [（3）安装附件](#3安装附件)
      - [2.命名空间打标](#2命名空间打标)
      - [3.访问istio的dashboard（kiali）](#3访问istio的dashboardkiali)
      - [4.卸载istio](#4卸载istio)
    - [集成附件](#集成附件)
      - [1.jaeger](#1jaeger)
      - [2.prometheus/grafana](#2prometheusgrafana)
      - [3.kiali](#3kiali)
        - [（1）集成prometheus](#1集成prometheus)
        - [（2）集成jaeger](#2集成jaeger)
        - [（3）集成grafana](#3集成grafana)
    - [部署demo](#部署demo)
      - [1.创建应用](#1创建应用)
      - [2.创建istio ingress GateWay](#2创建istio-ingress-gateway)
      - [3.访问该应用，获取对外暴露的端口号](#3访问该应用获取对外暴露的端口号)
    - [配置（本质就是配置envoy，主要就是filters）](#配置本质就是配置envoy主要就是filters)
      - [1.关键概念](#1关键概念)
        - [（1）provider（重要）](#1provider重要)
        - [（2）metrics](#2metrics)
      - [2.IstioOperator](#2istiooperator)
      - [3.Telemetry（本质就是配置filters）](#3telemetry本质就是配置filters)
        - [（1）配置生效的范围（优先级由低到高）](#1配置生效的范围优先级由低到高)
        - [（2）使用telemetry进行配置](#2使用telemetry进行配置)
      - [4.查看配置是否生效的方法（查看envoy的filters等信息）](#4查看配置是否生效的方法查看envoy的filters等信息)

<!-- /code_chunk_output -->

### 部署istio

#### 1.安装istio

##### （1）profile
* 注意profile的配置是内置的，没办法修改，只能从外部覆盖
* 查看内置的profile
```shell
istioctl profile list
istioctl profile dump <profile>
```
![](./imgs/deploy_01.png)

##### （2）安装istio
```shell
#修改配置
vim istio-1.13.4/manifests/profiles/default.yaml

#列出镜像
istioctl manifest generate -f <path> | grep images:

#安装
istioctl install -f istio-1.13.4/manifests/profiles/default.yaml

#或者 在命令行中进行配置 istioctl install --set profile=<profile> ...
```

##### （3）安装附件
* 需要安装这些附近，监控功能才能用（不建议使用istio提供的yaml文件，因为不适合生产环境）：
  * prometheus
  * grafana
  * jaeger

#### 2.命名空间打标

打标后，当在该ns中启动pod时，admission controllers会利用webhook注入envoy
已启动的pod，需要重启才能注入envoy

```shell
kubectl label namespace <ns> istio-injection=enabled
```

#### 3.访问istio的dashboard（kiali）

```shell
kubectl edit svc kiali -n istio-system
#账号密码为：admin/admin
```

#### 4.卸载istio
```shell
#删除插件
kubectl delete -f samples/addons

istioctl manifest generate -f <path> | kubectl delete -f -
#或者：istioctl manifest generate --set profile=<profile> | kubectl delete -f -
```

***

### 集成附件

#### 1.jaeger

#### 2.prometheus/grafana

#### 3.kiali

[参考](https://kiali.io/docs/configuration/p8s-jaeger-grafana/)

##### （1）集成prometheus

* 修改配置
```yaml
spec:
  external_services:
    prometheus:
      url: "http://metrics.telemetry:9090/"
```

##### （2）集成jaeger

* 修改配置文件
```yaml
spec:
  external_services:
    tracing:
      enabled: true

      #query over gRPC
      use_grpc: true
      in_cluster_url: 'http://tracing.telemetry:16685/jaeger'

      #jaeger dashboard
      url: 'http://10.10.10.163:8080/jaeger'
```

##### （3）集成grafana

* 修改配置
```yaml
spec:
  external_services:
    grafana:
      enabled: true
      in_cluster_url: 'http://grafana.telemetry:3000/'
      url: 'http://my-ingress-host/grafana'
```

* 还需要设置custome dashboards
[参考](https://kiali.io/docs/configuration/custom-dashboard/)

***

### 部署demo

**部署在打标的命名空间中**

#### 1.创建应用
```shell
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
```
#### 2.创建istio ingress GateWay
```shell
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
```
#### 3.访问该应用，获取对外暴露的端口号
```shell
kubectl get svc -n istio-system
#查看刚创建的ingress gateway将80端口映射到宿主机哪个端口上
#访问url:
# http://$IP:$PORT/productpage
```

***

### 配置（本质就是配置envoy，主要就是filters）

* **基础配置** 建议通过IstioOperator API配置
* **监控相关的配置** 建议通过Telemetry API配置

#### 1.关键概念

##### （1）provider（重要）
* 提供 存取不同类型的telemetry数据 能力的组件
* 默认提供三个provider
```json
"extensionProviders": [
  {
    "name": "prometheus",
    "prometheus": {}
  },
  {
    "name": "stackdriver",
    "stackdriver": {}
  },
  {
    "name": "envoy",
    "envoyFileAccessLog": {
      "path": "/dev/stdout"
    }
  }
]
```

* 自定义provider
  * prometheus provider无法定义，因为prometheus主动采集的
```yaml
meshConfig:
  extensionProviders:

  #自定义zipkin类型的provider
  - name: zipkin
    zipkin:
      service: zipkin.istio-system.svc.cluster.local  #必须写完整
      port: 9411
      maxTagLength: 256
```

##### （2）metrics

* proxy agent自身的指标（无法关闭）
[参考](https://istio.io/latest/docs/concepts/observability/#control-plane-metrics)

* Standard Metrics
  * disable telemetry，这些指标就会关闭
  * 本质是通过envoy filter采集的
[参考](https://istio.io/latest/docs/reference/config/metrics/)

* envoy stats（默认没有开启）
  * 需要明确指定，才会采集相关指标
[参考](https://istio.io/latest/docs/ops/configuration/telemetry/envoy-stats/)

#### 2.IstioOperator
* profile的配置是内置的，没办法修改，只能从外部覆盖
  * 可以通过`istioctl install -f <path>`指定覆盖后的配置文件
  * 让配置生效：`istioctl install ...`

```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
name: xx
spec:
  #指定使用的profile（可以在下面对该profile中的配置进行覆盖）
  profile: default
  #指定仓库地址
  hub: docker.io/istio

  #组件的外部配置（即是否启用、k8s资源等）
  components:
    #基础组件（即相关的资源，e.g. serviceaccount、clusterrole等）
    base:
      enabled: true
    #istiod和相关的k8s资源（e.g. serviceaccount等）
    pilot:
      enabled: true
    cni:
      enabled: false
    egressGateways:
    - enabled: false
      name: istio-egressgateway
    ingressGateways:
    - enabled: true
      name: istio-ingressgateway
    istiodRemote:
      enabled: false


  #组件的内部配置（即mesh的配置）
  meshConfig:
    accessLogFile: "/dev/stdout"

    #是否开启auto mutual tls
    enableAutoMtls: <bool | default=true>

    #合并应用和envoy的metrics
    enablePrometheusMerge: <bool | default=true>

    #配置providers
    extensionProviders:
    - name: zipkin
      zipkin:
        service: zipkin.istio-system.svc.cluster.local  #必须写完整
        port: 9411
        maxTagLength: 256

    #设置 不同类型的telemetry 默认使用的providers（即在telemetry配置中没有指定的时，使用默认的provider）
    defaultProviders:
      accessLogging:
      - envoy
      tracing:
      - zipkin
      metrics:
      - prometheus

    #proxy（即envoy）的默认配置
    defaultConfig:  {}

  #组件的内部配置（用于补充meshConfig，会被逐步弃用）
  #但有些配置目前只能在这里配
  #参考: https://istio.io/v1.5/docs/reference/config/installation-options/
  values:
    pilot:
      #关闭自动识别协议（默认是开启的）
      enableProtocolSniffingForOutbound: false
      #默认是关闭的
      enableProtocolSniffingForInbound: false

```

#### 3.Telemetry（本质就是配置filters）

##### （1）配置生效的范围（优先级由低到高）
* 全局
  * `将Telemetry资源部署在istio-system这个命名空间下`
* 某个namespace
  * `将Telemetry资源部署在某个namespace下`
* 某个workload
  * `将Telemetry资源部署在某个namespace下 并 通过selector选择相应的workload`

##### （2）使用telemetry进行配置
```yaml
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: mesh-default
  namespace: istio-system
spec:
  #不指定provider，使用默认的

  #可以指定将配置应用到指定的workload
  selector: {}

  #访问日志配置
  accessLogging:
  - disabled: true

  #tracing配置
  tracing:
  - randomSamplingPercentage: 100
    disableSpanReporting: false
    customTags: {}

  #metrics配置
  # 生成新的metrics，对旧的metrics没有任何影响
  # disabled选项也是对新的metrics
  # metrics:
  # - providers:
  #   - name: prometheus
  #   overrides:
  #   - match:
  #       metric: ALL_METRICS
  #       mode: CLIENT_AND_SERVER
  #     disabled: true  
  #     tagOverrides:
  #       response_code:
  #         operation: REMOVE
  metrics: []
```

* kubectl apply使配置生效


#### 4.查看配置是否生效的方法（查看envoy的filters等信息）
* 查看access log配置
  * 查看envoy的tcp_proxy或http_connection_manager filter（当没有配置access_log时，表示没有开启）

* 查看tracing配置
  * 查看envoy的http_connection_manager filter
  ```json
  {
    "name": "envoy.filters.network.http_connection_manager",
    "typedConfig": {
        "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
    },
    "tracing": {
      "client_sampling": {},
      "random_sampling": {},
      "overall_sampling": {},
      "max_path_tag_length": {},
      "custom_tags": [],
      "provider": {}    //旧版的provider可能在boostrap中设置的
    }
  }
  ```
