# overview

[toc]

### 概述

#### 1.架构
![](./imgs/overview_01.png)

* client
  * 负责采集tracing数据并push到collector
  * jaeger client libraries会被弃用，使用opentelemetry
* collector
  * 负责收集tracing数据，然后存储数据库
  * 并且可以调整client的采样频率
* agent（不是必须的）
  * 是装在本地，用于收集所在机器的tracing数据，然后统一发到collector

#### 2.常用端口

[参考](https://www.jaegertracing.io/docs/1.36/getting-started/)

|port|protocol|description|
|-|-|-|
|4317|HTTP|OLTP (opentelemetry protocol) over gRPC|
|4318|HTTP|OLTP (opentelemetry protocol) over HTTP|
|9411|HTTP|zipkin|
|14250|HTTP|jaeger over gRPC|
|14268|HTTP|jaeger over HTTP|
|16685|HTTP|query over gRPC|
|16686|HTTP|query over HTTP|
