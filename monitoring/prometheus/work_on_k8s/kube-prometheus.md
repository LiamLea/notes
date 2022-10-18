# kube-prometheus

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kube-prometheus](#kube-prometheus)
    - [概述](#概述)
    - [使用](#使用)
      - [1.部署](#1部署)
      - [2.添加job](#2添加job)
        - [（1）创建service，代理相应的exporter的`<IP>:<PORT>`](#1创建service代理相应的exporter的ipport)
        - [（2)创建serviceMonitor](#2创建servicemonitor)
    - [自定义配置](#自定义配置)
      - [1.安装相关工具，或者直接使用工具镜像](#1安装相关工具或者直接使用工具镜像)
      - [2.创建目录并初始化](#2创建目录并初始化)
      - [3.配置](#3配置)
        - [（1）example配置](#1example配置)
        - [（2）监控其他命名空间的配置](#2监控其他命名空间的配置)
        - [（3）持久化存储配置](#3持久化存储配置)
        - [（4）添加grafana模板](#4添加grafana模板)
      - [4.下载`build.sh`到当前目录](#4下载buildsh到当前目录)
      - [5.生成清单文件](#5生成清单文件)
      - [5.利用生成的清单文件进行部署](#5利用生成的清单文件进行部署)

<!-- /code_chunk_output -->

### 概述
### 使用
#### 1.部署
```shell
kubectl apply -f manifests/setup
kubectl apply -f manifests/
```

#### 2.添加job
* 通过`service`和`serviceMonitor`资源添加（这两个资源需要在同一个命名空间，但不需要和kube-prometheus在同一个）
* 该service代理的符合要求的endpoints都会被加入到该job中
* 添加的job名：`<serviceMonitor_NAMESPACE>/<sericeMonitor_NAME>/<NUMBER>`
##### （1）创建service，代理相应的exporter的`<IP>:<PORT>`
```yaml
# vim svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: "host-5-19"
  labels:
    app: "system"
spec:
  ports:
  - name: http
    targetPort: 9100
    port: 9100
```
```yaml
# vim endpoints.yaml

apiVersion: v1
kind: Endpoints
metadata:
  name: "host-5-19"
subsets:
- addresses:
  - ip: 3.1.5.19
  - ip: 3.1.5.21
  ports:
  - name: http
    port: 9100
```
```shell
kubectl apply -f svc.yaml endpoints.yaml -n xx
```
##### （2)创建serviceMonitor
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: "test-sm"
spec:

  #配置job中的一些参数
  endpoints:
  - interval: 15s
    path: /metrics
    port: <PORT_NAME>       #只获取名字为<PORT_NAME>的端口的/metrics的指标
  - path: /metrics
    port: <PORT_NAME>       #如果有要获取不同<PORT_NAME>的端口的/metics（有几个就会生成几个job）

  #用于设置target的job标签
  #用自动发现的service的app="system"这个标签的值"system"设置job标签(即job="system")
  jobLabel: app
  selector:
    matchLabels:
      app: "system"
```

### 自定义配置
利用jsonnet生成的资源清单
#### 1.安装相关工具，或者直接使用工具镜像
```shell
docker pull quay.io/coreos/jsonnet-ci
```
#### 2.创建目录并初始化
```shell
mkdir my-kube-prometheus; cd my-kube-prometheus
docker run --rm -v $(pwd):$(pwd) --workdir $(pwd) quay.io/coreos/jsonnet-ci jb init
docker run --rm -v $(pwd):$(pwd) --workdir $(pwd) quay.io/coreos/jsonnet-ci jb install github.com/coreos/kube-prometheus/jsonnet/kube-prometheus@release-0.5
```
#### 3.配置
* 所有配置要写到一个配置文件中：`xx.jsonnet`
* 一定要注意格式，有时候格式错不会报错

##### （1）example配置
```jsonnet
{
  _config+:: {
    namespace: "default",
    versions+:: {
        alertmanager: "v0.17.0",
        nodeExporter: "v0.18.1",
        kubeStateMetrics: "v1.5.0",
        kubeRbacProxy: "v0.4.1",
        prometheusOperator: "v0.30.0",
        prometheus: "v2.10.0",
    },

    imageRepos+:: {
        prometheus: "quay.io/prometheus/prometheus",
        alertmanager: "quay.io/prometheus/alertmanager",
        kubeStateMetrics: "quay.io/coreos/kube-state-metrics",
        kubeRbacProxy: "quay.io/coreos/kube-rbac-proxy",
        nodeExporter: "quay.io/prometheus/node-exporter",
        prometheusOperator: "quay.io/coreos/prometheus-operator",
    },

    prometheus+:: {
        names: 'k8s',
        replicas: 2,
        rules: {},
    },

    alertmanager+:: {
      name: 'main',
      config: |||
        global:
          resolve_timeout: 5m
        route:
          group_by: ['job']
          group_wait: 30s
          group_interval: 5m
          repeat_interval: 12h
          receiver: 'null'
          routes:
          - match:
              alertname: Watchdog
            receiver: 'null'
        receivers:
        - name: 'null'
      |||,
      replicas: 3,
    },

    kubeStateMetrics+:: {
      collectors: '',  // empty string gets a default set
      scrapeInterval: '30s',
      scrapeTimeout: '30s',

      baseCPU: '100m',
      baseMemory: '150Mi',
    },

    nodeExporter+:: {
      port: 9100,
    },
  },
}
```
##### （2）监控其他命名空间的配置
```jsonnet
local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') + {
  _config+:: {
    namespace: 'monitoring',
    prometheus+:: {
      namespaces+: ['my-namespace', 'my-second-namespace'],
    },
  },
  prometheus+:: {
    serviceMonitorMyNamespace: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'my-servicemonitor',
        namespace: 'my-namespace',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            port: 'http-metrics',
            path: '/metrics',
          },
        ],
        selector: {
          matchLabels: {
            app: 'myapp',
          },
        },
      },
    },
  },

};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
```

##### （3）持久化存储配置
```jsonnet
local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';  // https://github.com/ksonnet/ksonnet-lib/blob/master/ksonnet.beta.3/k.libsonnet - imports k8s.libsonnet
// * https://github.com/ksonnet/ksonnet-lib/blob/master/ksonnet.beta.3/k8s.libsonnet defines things such as "persistentVolumeClaim:: {"
//
local pvc = k.core.v1.persistentVolumeClaim;  // https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#persistentvolumeclaim-v1-core (defines variable named 'spec' of type 'PersistentVolumeClaimSpec')

local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/kube-prometheus-anti-affinity.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-managed-cluster.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-node-ports.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-static-etcd.libsonnet') +
  // (import 'kube-prometheus/kube-prometheus-thanos-sidecar.libsonnet') +
  {
    _config+:: {
      namespace: 'monitoring',
    },

    prometheus+:: {
      prometheus+: {
        spec+: {  // https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
          // If a value isn't specified for 'retention', then by default the '--storage.tsdb.retention=24h' arg will be passed to prometheus by prometheus-operator.
          // The possible values for a prometheus <duration> are:
          //  * https://github.com/prometheus/common/blob/c7de230/model/time.go#L178 specifies "^([0-9]+)(y|w|d|h|m|s|ms)$" (years weeks days hours minutes seconds milliseconds)
          retention: '30d',

          // Reference info: https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/storage.md
          // By default (if the following 'storage.volumeClaimTemplate' isn't created), prometheus will be created with an EmptyDir for the 'prometheus-k8s-db' volume (for the prom tsdb).
          // This 'storage.volumeClaimTemplate' causes the following to be automatically created (via dynamic provisioning) for each prometheus pod:
          //  * PersistentVolumeClaim (and a corresponding PersistentVolume)
          //  * the actual volume (per the StorageClassName specified below)
          storage: {  // https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#storagespec
            volumeClaimTemplate:  // (same link as above where the 'pvc' variable is defined)
              pvc.new() +  // http://g.bryan.dev.hepti.center/core/v1/persistentVolumeClaim/#core.v1.persistentVolumeClaim.new

              pvc.mixin.spec.withAccessModes('ReadWriteOnce') +

              // https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#resourcerequirements-v1-core (defines 'requests'),
              // and https://kubernetes.io/docs/concepts/policy/resource-quotas/#storage-resource-quota (defines 'requests.storage')
              pvc.mixin.spec.resources.withRequests({ storage: '100Gi' }) +

              // A StorageClass of the following name (which can be seen via `kubectl get storageclass` from a node in the given K8s cluster) must exist prior to kube-prometheus being deployed.
              pvc.mixin.spec.withStorageClassName('ssd'),

            // The following 'selector' is only needed if you're using manual storage provisioning (https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/storage.md#manual-storage-provisioning).
            // And note that this is not supported/allowed by AWS - uncommenting the following 'selector' line (when deploying kube-prometheus to a K8s cluster in AWS) will cause the pvc to be stuck in the Pending status and have the following error:
            //  * 'Failed to provision volume with StorageClass "ssd": claim.Spec.Selector is not supported for dynamic provisioning on AWS'
            //pvc.mixin.spec.selector.withMatchLabels({}),
          },  // storage
        },  // spec
      },  // prometheus
    },  // prometheus

  };

{ ['setup/0namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor is separated so that it can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
```

##### （4）添加grafana模板
```jsonnet

local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') + {
  _config+:: {
    namespace: 'monitoring',
  },
  grafanaDashboards+:: {
    'my-dashboard.json': (import '<PATH>/xx.json'),
  },
};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
```
#### 4.下载`build.sh`到当前目录
```shell
wget https://raw.githubusercontent.com/coreos/kube-prometheus/master/build.sh
chmod +x build.sh
```
#### 5.生成清单文件
```shell
docker run --rm -v $(pwd):$(pwd) --workdir $(pwd) quay.io/coreos/jsonnet-ci ./build.sh xx.jsonnet
```

#### 5.利用生成的清单文件进行部署
```shell
kubectl apply -f manifests/setup
kubectl apply -f manifests/
```
