### 概述
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
* tat
每个span可以有多个tag
