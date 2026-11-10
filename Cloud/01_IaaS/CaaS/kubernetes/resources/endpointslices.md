# Endpointslices

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Endpointslices](#endpointslices)
    - [Overview](#overview)
      - [1.EndpointSlice](#1endpointslice)
        - [(1) why replace Endpoints](#1-why-replace-endpoints)
        - [(2) how it slices](#2-how-it-slices)
      - [2.Conditions](#2conditions)

<!-- /code_chunk_output -->


### Overview

#### 1.EndpointSlice

* replacement of Endpoints: backends of a service are split into multiple slices (max 100 endpoints per slice)
* created automatically for a Service with selector, linked by label `kubernetes.io/service-name: <service_name>`

```shell
kubectl get endpointslices -l kubernetes.io/service-name=<service_name>
```

##### (1) why replace Endpoints
* Endpoints: one big object per service, any pod change resends the whole object to every node (kube-proxy)
* EndpointSlice: only the changed slice is resent, and it can carry more info (conditions, zone)
* e.g. a service has 300 pods, and pod-5 restarts:
```
Endpoints:      [ pod-1 ... pod-300 ]          -> resend all 300 IPs to every node

EndpointSlice:  slice-a [ pod-1   ... pod-100 ] -> resend only this slice (100 IPs)
                slice-b [ pod-101 ... pod-200 ]    unchanged, not sent
                slice-c [ pod-201 ... pod-300 ]    unchanged, not sent
```

##### (2) how it slices
* same ports (and IPv4/IPv6) -> same slice
* fill a slice up to 100, if all slices are full -> create a new slice
* existing IPs never move: delete a pod -> only remove its IP from its slice

* e.g. service `web` (assume max 3 per slice to keep it short)
```shell
# 5 pods
$ kubectl get endpointslices -l kubernetes.io/service-name=web
NAME        ADDRESSTYPE   PORTS   ENDPOINTS
web-aaaaa   IPv4          80      10.0.0.1,10.0.0.2,10.0.0.3     #full
web-bbbbb   IPv4          80      10.0.0.4,10.0.0.5              #1 free spot

# delete pod 10.0.0.2 -> only web-aaaaa is updated
web-aaaaa   IPv4          80      10.0.0.1,10.0.0.3
web-bbbbb   IPv4          80      10.0.0.4,10.0.0.5

# add 2 pods (10.0.0.6, 10.0.0.7) -> fill free spots first
web-aaaaa   IPv4          80      10.0.0.1,10.0.0.3,10.0.0.6
web-bbbbb   IPv4          80      10.0.0.4,10.0.0.5,10.0.0.7

# add 1 pod (10.0.0.8) -> all full, create a new slice
web-aaaaa   IPv4          80      10.0.0.1,10.0.0.3,10.0.0.6
web-bbbbb   IPv4          80      10.0.0.4,10.0.0.5,10.0.0.7
web-ccccc   IPv4          80      10.0.0.8
```

#### 2.Conditions

| Condition | Meaning |
|---|---|
| ready | pod is Ready and not terminating -> receives new traffic |
| serving | pod is Ready, regardless of terminating |
| terminating | pod is being deleted |

* see [pod.md - Terminate a Pod](./pod.md#11terminate-a-pod)
