# observability

[toc]

### 概述

#### 1.三个维度
* metrics
* distributed tracing（目前只支持http协议）
* logs

#### 2.distributed tracing

##### （1）前提
* 应用需要支持传递 `x-b3-*`http header
  * 因为envoy不能将进入流量和外出流量进行关联，所以需要应用传递相应的http头
