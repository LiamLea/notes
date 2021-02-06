# distributed tracing

[toc]

### 概述

#### 1.distributed tracing
分布式跟踪，用于跟踪请求在分布式系统中传播的情况
现有的分布式跟踪系统都是采用了google 的Dapper标准

#### 2.openTracing（与openCensus合并为了openTelemetry）
是一种api标准，用于分布式跟踪系统
openTelemetry支持云原生的软件

#### 3.observability（可观察性）

##### （1）metrics

##### （2）distributed traces

##### （3）access logs

#### 3.相关术语

##### （1）trace
一个trace代表一个调用链

##### （2）span
在整个调用链中，每一次调用都会产生一个或多个span
包含 调用的服务、操作、时间戳、span上下文（trace id, span id等）、其他元数据（标签、日志等）

#### 4.Automatic and manual instrumentation

##### （1）automatic instrumentation（自动测量）
使用代理，附加到正在运行的应用程序并提取数据
* 无需更改代码

##### （2）manual instrumentation（手动测量）
需要在代码中开始和结束一个span
* 需要利用client libraries和SDKs






#### APM(application performance management)
APM核心的技术是distributed tracing(分布式链路追踪系统)

#### distributed tracing
* 现有的分布式Trace基本都是采用了google 的Dapper标准
* 能够记录一个请求的调用链，从而能够快速定位哪个接口有问题

#### open tracing
提供平台无关、厂商无关的API，使得能够方便在应用中添加追踪系统
* trace
一个trace代表一个调用链
* span
trace中被命名并计时的连续性的执行片段，相当于一个调用
* log
每个span可以多次log，即生成多条日志
* tag
每个span可以有多个tag
