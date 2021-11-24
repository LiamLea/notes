# overview

[toc]

### 概述

![](./imgs/overview_01.png)

#### 1.有三类probe

|类别|特点|装配方式|限制|
|-|-|-|-|
|Language based native agent（基于语言的本地代理）|嵌入到代码中，相当于是代码的一部分（比如java agent是通过嵌入到JVM中，动态嵌入到代码中）|自动装配和手动装配|只支持特定的framework和library|
|Service Mesh probes|比如通过istio-adapter去获取istio的数据|||
|3rd-party instrument library|集成第三方工具的数据|||

#### 2.有三个维度的数据

|数据类型|说明|
|-|-|
|Tracing|分布式链路数据|
|Metrics|性能指标|
|Logging|日志数据|
