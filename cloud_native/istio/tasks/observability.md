# observability

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [observability](#observability)
    - [概述](#概述)
      - [1.三个维度](#1三个维度)
      - [2.tracing](#2tracing)
        - [（1）前提](#1前提)

<!-- /code_chunk_output -->

### 概述

#### 1.三个维度
* metrics
  * traffic
* tracing（目前只支持http协议）
* logs
  * pod log

#### 2.tracing

##### （1）前提
* 应用需要支持传递 `x-b3-*`http header
  * 因为envoy不能将进入流量和外出流量进行关联，所以需要应用传递相应的http头
