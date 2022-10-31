# observability

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [observability](#observability)
    - [概述](#概述)
      - [1.三个维度](#1三个维度)
        - [（1）metrics](#1metrics)
        - [（2）tracing（目前只支持http协议）](#2tracing目前只支持http协议)
        - [（3）logs](#3logs)
      - [2.tracing](#2tracing)
        - [（1）前提](#1前提)

<!-- /code_chunk_output -->

### 概述

#### 1.三个维度

#####（1）metrics

* proxy agent自身的指标（无法关闭）
[参考](https://istio.io/latest/docs/concepts/observability/#control-plane-metrics)

* Standard Metrics（通过envoyfilter实现的）
  * disable telemetry，这些指标就会关闭
  * 本质是通过envoy filter采集的
[参考](https://istio.io/latest/docs/reference/config/metrics/)

* envoy stats（默认没有开启）
  * 需要明确指定，才会采集相关指标
[参考](https://istio.io/latest/docs/ops/configuration/telemetry/envoy-stats/)

#####（2）tracing（目前只支持http协议）

#####（3）logs
* access log

#### 2.tracing

##### （1）前提
* 应用需要支持传递 `x-b3-*`http header
  * 因为envoy不能将进入流量和外出流量进行关联，所以需要应用传递相应的http头
