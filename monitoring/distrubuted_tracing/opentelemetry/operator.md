# opentelemetry operator

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [opentelemetry operator](#opentelemetry-operator)
    - [概述](#概述)
      - [1.operator功能](#1operator功能)
      - [2.自动装配agent原理](#2自动装配agent原理)
    - [使用](#使用)
      - [1.创建Instrumentation资源](#1创建instrumentation资源)

<!-- /code_chunk_output -->

[参考](https://github.com/open-telemetry/opentelemetry-operator)

### 概述

#### 1.operator功能
* 自动部署collector（通过`OpenTelemetryCollector`资源）
* 自动装配agent（通过`Instrumentation`资源）

#### 2.自动装配agent原理

* 挂载agent包到容器中
* 通过环境变量，设置agent
  * 以java为例，设置了以下环境变量:
    ```yaml
    - name: JAVA_TOOL_OPTIONS
      value: ' -javaagent:/otel-auto-instrumentation/javaagent.jar'
    - name: OTEL_SERVICE_NAME
      value: blade-auth
    - name: OTEL_EXPORTER_OTLP_ENDPOINT
      value: http://10.10.10.232:4317
    - name: OTEL_PROPAGATORS
      value: tracecontext,baggage,b3
    - name: OTEL_TRACES_SAMPLER
      value: parentbased_traceidratio
    - name: OTEL_TRACES_SAMPLER_ARG
      value: "1"

    - name: OTEL_RESOURCE_ATTRIBUTES_POD_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
    - name: OTEL_RESOURCE_ATTRIBUTES_NODE_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: spec.nodeName
    - name: OTEL_RESOURCE_ATTRIBUTES
      value: k8s.container.name=auth,k8s.deployment.name=blade-auth,k8s.namespace.name=demo,k8s.node.name=$(OTEL_RESOURCE_ATTRIBUTES_NODE_NAME),k8s.pod.name=$(OTEL_RESOURCE_ATTRIBUTES_POD_NAME),k8s.replicaset.name=blade-auth-79b986bb9d
    ```

***

### 使用

[清单文件参考](https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api.md)

#### 1.创建Instrumentation资源
* 在需要需要自动装配的namespace下创建
  * 配置的含义参考deploy文档
```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: my-instrumentation
spec:
  #默认tracing、metrics、logging都会发往这个地址
  exporter:
    endpoint: http://otel-collector:4317
  propagators:
    - tracecontext
    - baggage
    - b3
  sampler:
    type: parentbased_traceidratio
    argument: "0.25"

  #通过环境变量配置opentelemetry agent
  #下面两个配置表示不发送traces和metrics（当与istio结合时这样使用）
  env:
  - name: OTEL_TRACES_EXPORTER
    value: none
  - name: OTEL_METRICS_EXPORTER
    value: none
```

* 自动装配：在pod上添加指定的annotation
  * java:
    * `instrumentation.opentelemetry.io/inject-java: "true"`
    * 指定特定的容器: `instrumentation.opentelemetry.io/container-names: "myapp,myapp2"`
  * python:
    * `instrumentation.opentelemetry.io/inject-python: "true"`
  * NodeJs:
    * `instrumentation.opentelemetry.io/inject-nodejs: "true"`
  * DotNet:
    * `instrumentation.opentelemetry.io/inject-dotnet: "true"`
