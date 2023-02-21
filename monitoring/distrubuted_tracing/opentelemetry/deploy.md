# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署collector](#部署collector)
      - [1.部署](#1部署)
      - [2.配置](#2配置)
    - [部署java agent](#部署java-agent)
      - [1.重要配置](#1重要配置)

<!-- /code_chunk_output -->

### 部署collector

#### 1.部署
```shell
docker run -v $(pwd)/config.yaml:/etc/otelcol/config.yaml otel/opentelemetry-collector:0.64.1
```

#### 2.配置

[参考](https://opentelemetry.io/docs/collector/configuration/)

```yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

exporters:
  otlp:
    endpoint: "<backend_otlp>"  #比如发送到jaeger的collector
    tls:
      insecure: true
  prometheus:
    endpoint: "0.0.0.0:9464"    #prometheus需要配置：<ip>:9464/metrics

processors:
  batch:
  spanmetrics:
    metrics_exporter: prometheus  #发送到prometheus这个exporter上
    latency_histogram_buckets: [100us, 1ms, 2ms, 6ms, 10ms, 100ms, 250ms]
    dimensions:
      - name: http.method
        default: GET
      - name: http.status_code
    dimensions_cache_size: 1000
    aggregation_temporality: "AGGREGATION_TEMPORALITY_CUMULATIVE"

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [spanmetrics, batch]
      exporters: [otlp]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
```

***

### 部署java agent

[参考](https://github.com/open-telemetry/opentelemetry-java/tree/main/sdk-extensions/autoconfigure)

#### 1.重要配置
```shell
otel.service.name=<servie_name>

# otel.traces.exporter=none，不发送tracing（默认为otlp）
otel.exporter.otlp.endpoint=<otlp_endpoint> #默认tracing、metrics、logging都会发往这个地址

# otel.metrics.exporter=none，不发送metrics（默认为otlp）
otel.exporter.otlp.metrics.endpoint=<collector_endpoint>    #指定metrics发往的地址（会覆盖上面的配置）
#直接暴露metrics，不发往collector（与上面配置二选一即可）
otel.metrics.exporter=prometheus
otel.exporter.prometheus.port=9464
otel.exporter.prometheus.host=0.0.0.0

#默认就是none，表示不发送日志数据
otel.logs.exporter=none（默认为none）
```
