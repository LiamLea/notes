# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署](#部署)
      - [1.部署jaeger](#1部署jaeger)

<!-- /code_chunk_output -->

### 部署

#### 1.部署jaeger

* All-in-one
  * agent
  * collector
  * UI
```shell
docker run -d --name jaeger \
  -e METRICS_STORAGE_TYPE=prometheus \  #指定用prometheus存储metrics
  -e PROMETHEUS_SERVER_URL=http://prometheus:9090 \ #指定metrics地址
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.39
```
