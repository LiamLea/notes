# kube-prometheus

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [kube-prometheus](#kube-prometheus)
    - [Usage](#usage)
      - [1.Generate Manifests](#1generate-manifests)
        - [(1) Install](#1-install)
        - [(2) Configuration](#2-configuration)
        - [(3) Generate Manifests](#3-generate-manifests)
      - [2.Apply Manifests](#2apply-manifests)
      - [3.Add Job](#3add-job)
        - [(1) create service for some exporter: `<IP>:<PORT>`](#1-create-service-for-some-exporter-ipport)
        - [(2) create serviceMonitor](#2-create-servicemonitor)

<!-- /code_chunk_output -->

### Usage

#### 1.Generate Manifests

##### (1) Install
```shell
$ mkdir my-kube-prometheus; cd my-kube-prometheus

# Creates the initial/empty `jsonnetfile.json`
$ jb init

# Install the kube-prometheus dependency
#   Creates `vendor/` & `jsonnetfile.lock.json`, and fills in `jsonnetfile.json`
$ jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main 

# if needed
#   In order to update the kube-prometheus dependency
$ jb update
```

##### (2) Configuration

```shell
$ wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/example.jsonnet -O example.jsonnet
```

* configure
  * configure through write overwritten configuration in your own file (e.g. example.jsonnet)
```shell
vim example.jsonnet
```

```jsonnet
local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/pyrra.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
    },
  };

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// { 'setup/pyrra-slo-CustomResourceDefinition': kp.pyrra.crd } +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
// { ['pyrra-' + name]: kp.pyrra[name] for name in std.objectFields(kp.pyrra) if name != 'crd' } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }
```

##### (3) Generate Manifests

* generate manifests in the `manifests/` directory
```shell
$ wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/build.sh -O build.sh
$ chmod +x build.sh

# docker run --rm -v $(pwd):$(pwd) --workdir $(pwd) quay.io/coreos/jsonnet-ci ./build.sh xx.jsonnet
$ /build.sh example.jsonnet
```

#### 2.Apply Manifests
```shell
kubectl apply --server-side -f manifests/setup
kubectl apply -f manifests/
```

#### 3.Add Job
* 通过`service`和`serviceMonitor`资源添加（这两个资源需要在同一个命名空间，但不需要和kube-prometheus在同一个）
* 该service代理的符合要求的endpoints都会被加入到该job中
* 添加的job名：`<serviceMonitor_NAMESPACE>/<sericeMonitor_NAME>/<NUMBER>`
##### (1) create service for some exporter: `<IP>:<PORT>`
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

##### (2) create serviceMonitor
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