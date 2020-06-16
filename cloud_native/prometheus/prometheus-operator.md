# promethus operator
[toc]
### 概述
![](./imgs/prometheus-operator_01.png)
#### 1.管理的资源
* Promethus
  * 用于部署promethues（StatefulSet）
* Alertmanager
  * 用于部署alertmanager（StatefulSet）
* ServiceMonitor
  * 用于配置被监控的targets
### 监控
#### 1.Prometheus资源清单
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
```
#### 2.ServiceMonitor资源清单
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
  jobLabel: app

  #选择发现哪些service
  #通过标签选择service
  selector:
    matchLabels:
      app: "system"

  #选择发现哪些endpoints（即target）
  #通过端口名称选择endpoints
  endpoints:
  - interval: 15s
    path: /metrics
    port: <PORT_NAME>       #只获取名字为<PORT_NAME>的端口的/metrics的指标
  - path: /metrics
    port: <PORT_NAME>       #如果有要获取不同<PORT_NAME>的端口的/metics（有几个就会生成几个job）
```

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
