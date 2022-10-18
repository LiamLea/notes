# promethus operator

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [promethus operator](#promethus-operator)
    - [概述](#概述)
      - [1.架构图](#1架构图)
      - [2.自定义的资源](#2自定义的资源)
      - [3.监控的内容](#3监控的内容)
    - [使用](#使用)
      - [1.prometheus-operator资源清单](#1prometheus-operator资源清单)
      - [2.Prometheus资源清单](#2prometheus资源清单)
      - [3.grafana数据持久化](#3grafana数据持久化)
        - [（1）插件等数据持久化](#1插件等数据持久化)
        - [（2）dashboards持久化](#2dashboards持久化)
    - [监控](#监控)
      - [1.监控系统组件](#1监控系统组件)
      - [2.监控k8s节点](#2监控k8s节点)
      - [3.监控集群信息](#3监控集群信息)
      - [4.监控其他软件](#4监控其他软件)
        - [（1）修改clusterRole的权限](#1修改clusterrole的权限)
        - [（2）查看某个软件暴露出的采集端口](#2查看某个软件暴露出的采集端口)
        - [（3）使用ServiceMonitor添加target](#3使用servicemonitor添加target)
    - [告警](#告警)
      - [1.Alertmanager资源清单](#1alertmanager资源清单)
      - [2.自定义alertmanager](#2自定义alertmanager)
        - [（1）创建alertmanager.yaml文件](#1创建alertmanageryaml文件)
        - [（2）生成secret](#2生成secret)
        - [（3）部署Alertmanager](#3部署alertmanager)

<!-- /code_chunk_output -->

### 概述
#### 1.架构图
![](./imgs/prometheus-operator_01.png)
#### 2.自定义的资源
* Promethus
  * 用于部署promethues（StatefulSet）
* Alertmanager
  * 用于部署alertmanager（StatefulSet）
* ServiceMonitor
  * 用于配置被监控的targets

#### 3.监控的内容
* 集群状态（通过kube-state-metrics）
* 节点（通过node exporter）
* kubelet
* apiserver
* kube-scheduler
* kube-controller-manager

***

### 使用
#### 1.prometheus-operator资源清单
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    k8s-app: prometheus-operator
  name: prometheus-operator
spec:
  selector:
    matchLabels:
      k8s-app: prometheus-operator
  replicas: 1
  template:
    metadata:
      labels:
        k8s-app: prometheus-operator
    spec:
      containers:
      - args:

        #由于kubelet不是自托管的组件，所以需要给该kubelet创建service和endpoints，这样prometheus才能使用服务发现监控kubelet
        #在kube-system命名空间下创建名为kubelet的service和endpoints
        - --kubelet-service=kube-system/kubelet

        - --config-reloader-image=quay.io/coreos/configmap-reload:v0.0.1
        image: quay.io/coreos/prometheus-operator:v0.17.0
        name: prometheus-operator
        ports:
        - containerPort: 8080
          name: http
```

#### 2.Prometheus资源清单
```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
  namespace: monitoring

spec:
  image: quay.io/prometheus/prometheus:v2.17.2
  replicas: 1

  #配置加载的serviceMonitor

  #配置加载指定namespace中的serviceMonitor，为空表示当前namespace
  serviceMonitorNamespaceSelector: {}

  #配置加载指定标签的serviceMonitor，为空表示加载所有
  serviceMonitorSelector: {}

  #配置加载的PrometheusRule
  ruleSelector:
    matchLabels:
      prometheus: k8s
      role: alert-rules

  #配置alertmanager的地址
  alerting:
    alertmanagers:
    - name: alertmanager-main
      namespace: monitoring
      port: web

  #使用持久化存储
  storage:
    volumeClaimTemplate:
      apiVersion: v1
      kind: PersistentVolumeClaim
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 100Gi
        storageClassName: <STORAGE_CLASS>
```
#### 3.grafana数据持久化
```shell
vim kube-prometheus-master/manifests/grafana-deployment.yaml
```
##### （1）插件等数据持久化
```yaml
volumes:
  - name: grafana-storage
    persistentVolumeClaim:
      claimName: <PVC_NAME>
```

##### （2）dashboards持久化
* 修改dashboards的导入路径
```shell
vim kube-prometheus-master/manifests/grafana-dashboardSources.yaml

#"path": "/grafana-dashboard-definitions/0"
```

* 将dashboards放入一个目录中，然后挂载此目录到上面设置的目录下
***

### 监控

#### 1.监控系统组件
* operator会为kubelet创建service
* apiserver已经存在service
* kube-scheduler
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    namespace: kube-system
    name: kube-scheduler-prometheus-discovery
    labels:
      k8s-app: kube-scheduler
  spec:
    selector:
      k8s-app: kube-scheduler
    type: ClusterIP
    clusterIP: None
    ports:
    - name: http-metrics
      port: 10251
      targetPort: 10251
      protocol: TCP
  ```
* kube-controller
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    namespace: kube-system
    name: kube-controller-manager-prometheus-discovery
    labels:
      k8s-app: kube-controller-manager
  spec:
    selector:
      k8s-app: kube-controller-manager
    type: ClusterIP
    clusterIP: None
    ports:
    - name: http-metrics
      port: 10252
      targetPort: 10252
      protocol: TCP
  ```

#### 2.监控k8s节点
* 通过DaemonSet安装node-exporter
* 为node-exporter创建service

#### 3.监控集群信息
* 通过Deployment安装kube-state-metrics
* 为kube-state-metrics创建service
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kube-state-metrics
    k8s-app: kube-state-metrics
  name: kube-state-metrics
spec:
  selector:
    app: kube-state-metrics
  clusterIP: None
  ports:
  - name: https-main
    port: 8443
    targetPort: https-main
    protocol: TCP
  - name: https-self
    port: 9443
    targetPort: https-self
    protocol: TCP
```

#### 4.监控其他软件
##### （1）修改clusterRole的权限
* 默认prometheus绑定的role权限有限
* 需要修改即role的权限，从而能够监控其他namespace
```shell
vim kube-prometheus-master/manifests/prometheus-clusterRole.yaml
```
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-k8s
rules:
- apiGroups:
  - ""
  resources:
  - nodes/metrics
  - services
  - endpoints
  - pods
  verbs:
  - get
  - list
  - watch
- nonResourceURLs:
  - /metrics
  verbs:
  - get
```

##### （2）查看某个软件暴露出的采集端口
```shell
kubectl describe pods <POD> -n <NAMESPACE>

#看annotations字段
#如果开放了采集端口，会在这里面描述
```

##### （3）使用ServiceMonitor添加target
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: <NAME>
  namespace: monitoring       #promethues默认只读取本命名空间的serviceMonitor
                              #也可以通过Prometheus.spec.serviceMonitorNamespaceSelector字段修改
spec:

  #用于设置target的job标签
  #用自动发现的service的app="system"这个标签的值"system"设置job标签(即job="system")
  jobLabel: <JOB_NAME>

  #指定在哪些namespace空间中进行发现
  namespaceSelector:
    matchNames:
    - <NAMESPACE>

  #选择发现哪些service
  #通过标签选择service（而不是endpoints）
  selector:
    matchLabels:
      <LABEL>: <VALUE>

  #选择发现哪些endpoints（即target）
  #通过端口名称选择endpoints
  #进行job的配置
  endpoints:
  - interval: 15s
    path: /metrics
    port: <PORT_NAME>       #会创建一个job，获取名字为<PORT_NAME>的端口的/metrics的指标
  - path: /metrics
    port: <PORT_NAME>       #如果要获取不同<PORT_NAME>的端口的/metics（有几个就会生成几个job）
```

***

### 告警
#### 1.Alertmanager资源清单
```yaml
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: alertmanager
  namespace: monitoring
spec:
  replicas: 1
```
只有给出有效的配置，Alertmanager才会启动

#### 2.自定义alertmanager
##### （1）创建alertmanager.yaml文件
```yaml
#自定义配置
```
##### （2）生成secret
```shell
kubectl create secret generic alertmanager-<ALERTMANAGER_NAME> --from-file=alertmanager.yaml -n monitoring
#<ALERTMANAGER_NAME>为即将创建的Alertmanager资源的名称
```
##### （3）部署Alertmanager
alertmanager会自动挂载`alertmanager-<ALERTMANAGER_NAME>`这个secret
