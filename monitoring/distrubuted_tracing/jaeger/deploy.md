# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署](#部署)
      - [1.docker部署jaeger](#1docker部署jaeger)
      - [2.k8s部署jaeger](#2k8s部署jaeger)
        - [（1）安装operator](#1安装operator)
        - [（2）安装](#2安装)

<!-- /code_chunk_output -->

### 部署

#### 1.docker部署jaeger

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

#### 2.k8s部署jaeger
[参考](https://www.jaegertracing.io/docs/1.42/operator/)

##### （1）安装operator
```shell
kubectl create ns observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.42.0/jaeger-operator.yaml -n observability
```

##### （2）安装
* `vim install.yaml`
```yaml
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: jaeger-prod
spec:
  strategy: production
  collector:
    maxReplicas: 5
    resources:
      limits:
        cpu: 2000m
        memory: 4Gi
  storage:
    type: elasticsearch
    options:
      es:
        server-urls: http://elasticsearch-master.log:9200
        index-prefix: test-jaeger
        username: elastic
        password: elastic
  query:
    options:
      query:
        base-path: /jaeger
      prometheus:
        server-url: "http://prometheus:9090"
    metricsStorage:
      type: prometheus
  ingress:
    hosts:
    - "home.liamlea.local"
    ingressClassName: "nginx"
    annotations:
      cert-manager.io/cluster-issuer: ca-issuer

  # ui:
  #   options:
  #     #可以添加外部url
  #     menu:
  #     - label: "About Jaeger"
  #       items:
  #         - label: "Documentation"
  #           url: "https://www.jaegertracing.io/docs/latest"
```
```shell
kubectl apply -f install.yaml -n <ns>
```
