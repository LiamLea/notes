# istioctl

[toc]

### 查看状态

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
