# distributed tracing

[toc]

### 概述

#### 1.distributed tracing
* 现有的分布式Trace基本都是采用了google 的Dapper设计
* 在一个请求链中传播context，从而记录一条请求链的状态

#### 2.tracing相关概念

![](./imgs/overview_01.png)

|term|description|
|-|-|
|trace|一个trace代表一个调用链|
|span|在一个trace中的一个调用|

##### （1）span相关属性（以Jaeger为例子）

|span属性|说明|
|-|-|
|operation name|一个span都有一个operation name（不同的span可以重复），用 调用链接 命名|
|span kind|server（处理请求）或client（发送请求）|
|start time|开始时间|
|duration|执行时间|
|ST (self-time)|自身花费的时间（去除调用其他服务的时间）|
|node id|实例的id，表示具体的哪个实例产生的这个span|

##### （2）示例
![](./imgs/overview_02.png)

* 同一个颜色：代表同一个service

* 同一个服务，连续有两个span
  * 一个是server类型的，一个是client类型的（即这个服务首先被访问，然后这个服务去访问其他服务）
![](./imgs/overview_03.png)

#### 3.tracing fields

|field|description|
|-|-|
|spanid|定义当前的span|
|parentid|前一个span|
|traceid|唯一标识一条调用链|
|traceflags|元数据（可以自定义）|

#### 4.opentelemetry（标准化）

将OpenTracing和OpenCensus合并
* 提供 监控数据 存入 后端存储 的API标准
* 提供 各种语言的SDK（遵循API标准）
  * 用于装配在服务上，采集服务的signals（包括：traces、metrics、logs、baggage）

##### （1）术语

|term|description|
|-|-|
|OTel|opentelemetry|
|OTLP|opentelemetry protocol|

##### （2）signals（监控数据）

|signal|description|
|-|-|
|traces|链路数据|
|metrics|指标数据（如：读写的总字节数、进程资源的使用的等）|
|logs|访问日志等（还不成熟）|
|baggage|用户在context中定义的元数据|

##### （3）sample数据

* span数据格式

```json
{
  //基本信息
  "trace_id": "7bba9f33312b3dbb8b2c2c62bb7abe2d",
  "name": "/v1/sys/health",
  "parent_id": "",
  "span_id": "086e83747d0e381e",

  //开始和结束时间
  "start_time": "2021-10-22 16:04:01.209458162 +0000 UTC",
  "end_time": "2021-10-22 16:04:01.209514132 +0000 UTC",

  //状态（当发生异常，且处理了则为ERROR，未处理UNSET）
  "status_code": "STATUS_CODE_OK",
  "status_message": "",

  //元数据
  "attributes": {
    "net.transport": "IP.TCP",
    "net.peer.ip": "172.17.0.1"
  },

  //日志数据
  "events": {
    "name": "",
    "message": "OK",
    "timestamp": "2021-10-22 16:04:01.209512872 +0000 UTC"
  }
}
```

#### 5.前提
* 应用需要传递相应的http header
  * 所以需要对应用进行更改
    * 有两种装配模式
    * java更容易，因为可以通过字节码进行注入，不需要更改任何代码）

#### 6.两种装配模式

##### （1）automatic instrumentation
使用指定的框架和库，这样能够自动生产span

##### （2）manual instrumentation
需要在代码中调用相应的SDK，开始和结束一个span

#### 7.采集策略

* Sample everything
  * 适合测试环境，不适合生产环境，成本比较大

#### 8.常用语言的装配

下面以opentelemtry为例子，[参考](https://opentelemetry.io/docs/instrumentation/)

|语言|装配方式|原理|修改代码程度|支持的采集内容|
|-|-|-|-|-|
|java|自动|利用字节码注入，修改代码|无|tracs、metrics、logs|
|python|自动|通过相应的telemetry库利用monkey patch，在运行时重写相应的方法和类（需要了解代码应用了哪些库，然后需要安装相应的telemetry库）|无|tracs、metrics、logs|
|go|手动||需要修改代码|tracs、metrics|
