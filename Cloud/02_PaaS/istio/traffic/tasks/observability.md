# observability

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [observability](#observability)
    - [metrics](#metrics)
      - [1.三类metrics](#1三类metrics)
    - [log](#log)
      - [1.kiali中几种log的集中展示](#1kiali中几种log的集中展示)
    - [tracing（目前只支持http协议）](#tracing目前只支持http协议)
      - [1.前提](#1前提)
      - [2.context propagator](#2context-propagator)
        - [（1）http header](#1http-header)

<!-- /code_chunk_output -->

### metrics

#### 1.三类metrics

* proxy agent自身的指标（无法关闭）
[参考](https://istio.io/latest/docs/concepts/observability/#control-plane-metrics)

* Standard Metrics（通过envoyfilter实现的）
  * disable telemetry，这些指标就会关闭
  * 本质是通过envoy filter采集的
[参考](https://istio.io/latest/docs/reference/config/metrics/)

* envoy stats（默认没有开启）
  * 需要明确指定，才会采集相关指标
[参考](https://istio.io/latest/docs/ops/configuration/telemetry/envoy-stats/)

***

### log

#### 1.kiali中几种log的集中展示

* access log 通过istio-proxy采集
* container log
* span info

***

### tracing（目前只支持http协议）

**本质：context propagation**

[参考](https://istio.io/latest/docs/tasks/observability/distributed-tracing/overview/)

#### 1.前提

* 应用需要传递相应的http header，因为envoy不能将进入流量和外出流量进行关联，所以需要应用传递相应的http头

* 必须传递的http header: `x-request-id`
  * 用于关联 日志 和 tracing
* 其他需要传递的http header（根据使用的trace backend决定），参考下方表格

|使用的trace backend|应用需要支持的http header|
|-|-|
|Zipkin, Jaeger, Stackdriver等|`x-b3-*`|
|Datadog|`x-datadog-*`|
|Lightstep|`x-ot-span-context`|

#### 2.context propagator

##### （1）http header
```yaml
x-request-id: c688b06e-8d93-9c6a-952b-01ac20e1a3e9

#使用的是b3multi propagator
x-b3-traceid: 33b048580e8e53788bc12faadc74e914
x-b3-spanid: 47164b7954a4b30c
x-b3-parentspanid: 0694bd1dd428ffd2
x-b3-sampled: 1
```
