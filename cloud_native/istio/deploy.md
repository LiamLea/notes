# deploy

[toc]

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

#安装
istioctl install -f istio-1.13.4/manifests/profiles/default.yaml

#或者 在命令行中进行配置 istioctl install --set profile=<profile> ...
```



#### 2.给default命名空间打标

**用于之后部署应用，可以注入envoy代理**
```shell
kubectl label namespace default istio-injection=enabled
```
>给已经安装的应用注入envoy代理
>* 给该应用所在命名空间打上标签
>* 然后更新一下该应用的pods即可

#### 3.访问istio的dashboard（kiali）

>首先要kiali这个service设置成NodePort类型  
```shell
kubectl edit svc kiali -n istio-system
```
>访问即可  
>>http://3.1.5.15:20001/kiali/
账号密码为：admin/admin

#### 4.卸载istio
```shell
istioctl manifest generate -f <path> | kubectl delete -f -
#或者：istioctl manifest generate --set profile=<profile> | kubectl delete -f -
```

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

基础配置建议通过IstioOperator API配置
监控相关的配置建议通过Telemetry API配置

#### 1.IstioOperator
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

    #provider会在telemetry配置中用到
    #配置外部的providers
    extensionProviders:
    - name: zipkin
      zipkin:
        service: zipkin.istio-system.svc.cluster.local  #必须写完整
        port: 9411
        maxTagLength: 256
    #设置默认使用的providers
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
  values: {}
```

#### 2.Telemetry（本质就是配置filters）
* 配置生效的范围（优先级由低到高）：
  * 全局
    * `将Telemetry资源部署在istio-system这个命名空间下`
  * 某个namespace
    * `将Telemetry资源部署在某个namespace下`
  * 某个workload
    * `将Telemetry资源部署在某个namespace下 并 通过selector选择相应的workload`
* 配置内容：
  * metric
  * tracing
  * access log
* provider提供某一类功能的配置
  * 必须指定provider（如果不指定则使用defaultProvider，但是defaultProvider必须在meshConfig中指定，如果没设置defaultProvider并且也没指定provider，则配置不会生效)

* 默认提供三个provider（如果需要其他的，需要自己定义）
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

##### （1）使用telemetry进行配置
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
    customTags: {}

  #metrics配置
  metrics: {}
```

* kubectl apply使配置生效


#### 3.查看配置是否生效的方法（查看envoy的filters等信息）
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
