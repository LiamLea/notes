# 客户端命令

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [客户端命令](#客户端命令)
    - [istioctl](#istioctl)
      - [1.查看envoy状态和配置](#1查看envoy状态和配置)
      - [2.利用envoy接口查看envoy信息](#2利用envoy接口查看envoy信息)
      - [3.查看envoy的配置（本质就是看filters等信息）](#3查看envoy的配置本质就是看filters等信息)
    - [查看pilot的信息](#查看pilot的信息)
      - [1.查看service registry](#1查看service-registry)
      - [2.查看当前的mesh配置](#2查看当前的mesh配置)

<!-- /code_chunk_output -->

### istioctl

#### 1.查看envoy状态和配置

* 查看所有envoy proxy的状态
```shell
istioctl proxy-status
#[参考: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/operations/dynamic_configuration]
#CDS: cluster discovery service（能够发现cluster中的service信息）
#LDS: listener discovery service
#EDS: endpoint discovery service（发现endpoint信息）
#RDS: route discovery service
```

* 查看某个envoy proxy的配置
所有的envoy配置应该都是一样的
```shell
istioctl proxy-config all <proxy-name>
#all包括：listener、cluster等
```

* 查看某个service或pod的destinationRule配置
```shell
$ istioctl experimental describe service <svc_name>.<ns>
# DestinationRule: my-destination-rule.istio-test for "reviews"
#    Matching subsets: v1,v2,v3

$ istioctl experimental describe pod <pod_name>.<ns>
# DestinationRule: my-destination-rule.istio-test for "reviews"
#    Matching subsets: v1
#       (Non-matching subsets v2,v3)
```

#### 2.利用envoy接口查看envoy信息
```shell
kubectl exec $POD -c istio-proxy -- curl 'localhost:15000/command'
#注意localhost:15000/config_dump输出的信息中：draining_state（表示之前的配置），active_state（表示当前的配置）
```

#### 3.查看envoy的配置（本质就是看filters等信息）
比如查看是否开启access_log，查看envoy的filters信息，当没有配置access_log相关的filters时，则表示没有开启

***

### 查看pilot的信息

```shell
kubectl exec -n istio-system -it <istiod_pod> -- curl http://127.0.0.1:8080/debug
```

#### 1.查看service registry
```shell
curl http://127.0.0.1:8080/debug/endpointz
```

```json
{
  "svc": "alertmanager-webhook-dingtalk.monitor.svc.cluster.local:http",
  "ep": [
    {
      "service": {
        "Attributes": {
          "ServiceRegistry": "Kubernetes",
          "Name": "alertmanager-webhook-dingtalk",
          "Namespace": "monitor",
          "Labels": null,
          "ExportTo": null,
          "LabelSelectors": {
            "app": "alertmanager-webhook-dingtalk"
          },
          "ClusterExternalAddresses": {
            "Addresses": null
          },
          "ClusterExternalPorts": null
        },
        "ports": [
          {
            "name": "http",
            "port": 80,
            "protocol": "HTTP"
          }
        ],
        "creationTime": "2022-05-08T15:10:53Z",
        "hostname": "alertmanager-webhook-dingtalk.monitor.svc.cluster.local",
        "clusterVIPs": {
          "Addresses": {
            "Kubernetes": [
              "10.96.82.20"
            ]
          }
        },
        "defaultAddress": "10.96.82.20",
        "Resolution": 0,
        "MeshExternal": false,
        "ResourceVersion": "18784447"
      },
      "servicePort": {
        "name": "http",
        "port": 80,
        "protocol": "HTTP"
      },
      "endpoint": {
        "Labels": {
          "app": "alertmanager-webhook-dingtalk",
          "istio-locality": "",
          "pod-template-hash": "fcdc48b7b",
          "topology.istio.io/cluster": "Kubernetes",
          "topology.istio.io/network": ""
        },
        "Address": "10.244.247.56",
        "ServicePortName": "http",
        "EnvoyEndpoint": null,
        "ServiceAccount": "spiffe://cluster.local/ns/monitor/sa/default",
        "Network": "",
        "Locality": {
          "Label": "",
          "ClusterID": "Kubernetes"
        },
        "EndpointPort": 8060,
        "LbWeight": 0,
        "TLSMode": "disabled",
        "Namespace": "monitor",
        "WorkloadName": "alertmanager-webhook-dingtalk",
        "HostName": "",
        "SubDomain": "",
        "TunnelAbility": 0
      }
    }
  ]
}
```

#### 2.查看当前的mesh配置
```shell
curl http://127.0.0.1:8080/debug/mesh
```
