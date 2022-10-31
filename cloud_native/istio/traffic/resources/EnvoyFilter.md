# EnvoyFilter

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [EnvoyFilter](#envoyfilter)
    - [概述](#概述)
      - [1.本质：配置envoy的filter等](#1本质配置envoy的filter等)
    - [使用](#使用)
      - [1.清单文件](#1清单文件)
      - [2.demo: 基于请求划分指标](#2demo-基于请求划分指标)
        - [（1） 根据 访问路径 定义 新的属性](#1-根据-访问路径-定义-新的属性)
        - [（2）新增指标](#2新增指标)
        - [（3）开启新指标](#3开启新指标)
      - [3.验证](#3验证)

<!-- /code_chunk_output -->

### 概述

#### 1.本质：配置envoy的filter等

***

### 使用

#### 1.清单文件
[参考](https://istio.io/latest/docs/reference/config/networking/envoy-filter/#EnvoyFilter)
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: custom-filter
  namespace: istio-system
spec:
  configPatches:

    #指定配置在envoy的哪部分，常用：LISTENER、FILTER_CHAIN	、NETWORK_FILTER等
    # 注意用于HTTP_FILTER，生效的前提是用的http协议
  - applyTo: HTTP_FILTER    

    #具体配置在哪些envoy上、具体配置在哪里
    match:
      #常用context: ANY、SIDECAR_INBOUND（在流量进入时应用此filter）、SIDECAR_OUTBOUND（在流量外出时应用此filter）等
      # 比如：在流量进入时生成指标（e.g. istio_requests_total{source_workload="unknown", destination_workload="productpage-v1"}）
      # 比如：在流量外出时生成指标（e.g. istio_requests_total{source_workload="productpage-v1", destination_workload="details-v1"}）
      context: SIDECAR_INBOUND

    #具体配置的内容
    patch:
      #操作：ADD、REMOVE、INSERT_xx等
      operation: INSERT_BEFORE  #在匹配的filter列表最前面插入
      value: {}
```

#### 2.demo: 基于请求划分指标
[参考](https://istio.io/latest/docs/tasks/observability/metrics/classify-metrics/)

##### （1） 根据 访问路径 定义 新的属性
* `attribute_gen_service.yaml`
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: istio-attributegen-filter
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_INBOUND
      proxy:
        proxyVersion: '1\.15.*'
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
            subFilter:
              name: "istio.stats"
    patch:
      operation: INSERT_BEFORE
      value:
        name: istio.attributegen
        typed_config:
          "@type": type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              configuration:
                "@type": type.googleapis.com/google.protobuf.StringValue
                value: |
                  {
                    "attributes": [
                      {
                        "output_attribute": "istio_operationId",
                        "match": [
                          {
                            "value": "ListReviews",
                            "condition": "request.url_path == '/reviews' && request.method == 'GET'"
                          },
                          {
                            "value": "GetReview",
                            "condition": "request.url_path.matches('^/reviews/[[:alnum:]]*$') && request.method == 'GET'"
                          },
                          {
                            "value": "CreateReview",
                            "condition": "request.url_path == '/reviews/' && request.method == 'POST'"
                          }
                        ]
                      }
                    ]
                  }
              vm_config:
                runtime: envoy.wasm.runtime.null
                code:
                  local: { inline_string: "envoy.wasm.attributegen" }
```

##### （2）新增指标
```shell
kubectl -n istio-system get envoyfilter stats-filter-1.15 -o yaml > stats-filter-1.15.yaml
vim stats-filter-1.15.yaml
```
* 添加一下内容
```yaml
name: istio.stats
typed_config:
  '@type': type.googleapis.com/udpa.type.v1.TypedStruct
  type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
  value:
    config:
      configuration:
        "@type": type.googleapis.com/google.protobuf.StringValue
        value: |
          {
            "metrics": [
             {
               "name": "requests_total",
               "dimensions": {
                 "request_operation": "istio_operationId"
               }
             }]
          }
```
* 效果如下（注意context跟`attribute_gen_service.yaml`对应：SIDECAR_INBOUND）
```yaml
...
- applyTo: HTTP_FILTER
  match:
    context: SIDECAR_INBOUND
    listener:
      filterChain:
        filter:
          name: envoy.filters.network.http_connection_manager
          subFilter:
            name: envoy.filters.http.router
    proxy:
      proxyVersion: ^1\.15.*
  patch:
    operation: INSERT_BEFORE
    value:
      name: istio.stats
      typed_config:
        '@type': type.googleapis.com/udpa.type.v1.TypedStruct
        type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
        value:
          config:
            configuration:
              '@type': type.googleapis.com/google.protobuf.StringValue
              value: |
                {
                  "debug": "true",
                  "stat_prefix": "istio",
                  "disable_host_header_fallback": true,
                  "metrics": [
                   {
                     "name": "requests_total",
                     "dimensions": {
                       "request_operation": "istio_operationId"
                     }
                   }]
                }
            root_id: stats_inbound
            vm_config:
              code:
                local:
                  inline_string: envoy.wasm.stats
              runtime: envoy.wasm.runtime.null
              vm_id: stats_inbound
...
```

#####（3）开启新指标
```yaml
meshConfig:
  defaultConfig:
    extraStatTags:
    - request_operation
```

#### 3.验证
* 访问页面
* 查看指标是否包含相应标签`request_operation`
```shell
istio_requests_total{app="reviews", request_operation="GetReview", ...}
```
