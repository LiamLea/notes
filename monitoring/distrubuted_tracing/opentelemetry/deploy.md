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

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
   metrics:
     receivers: [otlp]
     processors: [batch]
     exporters: [otlp]
```

***

### 部署java agent

[参考](https://github.com/open-telemetry/opentelemetry-java/tree/main/sdk-extensions/autoconfigure)

#### 1.重要配置
```shell
otel.service.name=<servie_name>

# otel.traces.exporter=none，不发送tracing
otel.exporter.otlp.endpoint=<otlp_endpoint> #默认tracing、metrics、logging都会发往这个地址

# otel.metrics.exporter=none，不发送metrics
otel.exporter.otlp.metrics.endpoint=<collector_endpoint>    #指定metrics发往的地址（会覆盖上面的配置）

#默认就是none，表示不发送日志数据
otel.logs.exporter=none
```
