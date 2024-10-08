# servie fault tolerance

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [servie fault tolerance](#servie-fault-tolerance)
    - [概述](#概述)
      - [1.servie fault tolerance](#1servie-fault-tolerance)
        - [（1）what](#1what)
        - [（2）why](#2why)
      - [2.原则：设置在消费侧（即调用方）](#2原则设置在消费侧即调用方)
      - [3.服务降级（fallback）](#3服务降级fallback)
        - [（1）发生的条件](#1发生的条件)
      - [4.服务熔断（circuit breaker）](#4服务熔断circuit-breaker)
        - [（1）断路器状态](#1断路器状态)
        - [（2）降级策略](#2降级策略)
        - [（3）断路器相关参数（以 异常比例 为例)](#3断路器相关参数以-异常比例-为例)
        - [（4）断路器工作原理（以 异常比例 为例)](#4断路器工作原理以-异常比例-为例)
      - [3.服务限流（以sentinel为例）](#3服务限流以sentinel为例)
        - [（1）限流指标](#1限流指标)
        - [（2）限流模式](#2限流模式)
        - [（3）限流效果](#3限流效果)
        - [（4）其他限流策略](#4其他限流策略)

<!-- /code_chunk_output -->

### 概述

#### 1.servie fault tolerance

##### （1）what
用于处理分布式系统的 延迟 和 容错
能够保障一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性

* 服务降级（fallback）
* 服务熔断（circuit break）
* 服务限流（flowlimit）

##### （2）why

* 场景一：
  用户同时调用 A、B、C、D这几个服务，其中C服务响应非常慢，会导致整个系统的性能下降，从而导致其他服务的性能下降
* 场景二：
  用户调用A，A->B->C->D，其中C服务响应非常慢，当有更多用户请求过来时，会将A和B的资源占满，导致系统崩溃

#### 2.原则：设置在消费侧（即调用方）

#### 3.服务降级（fallback）

##### （1）发生的条件
* 运行异常
* 超时
* 服务熔断触发服务降级
* 线程池/信号量打满触发服务降级

#### 4.服务熔断（circuit breaker）
当链路的某个微服务出错或或者响应时间过长，会进行服务的降级，进而熔断该节点微服务的调用，快速返回错误的响应信息
当检测到该服务调用响应正常后，恢复调用链路

##### （1）断路器状态

|断路器状态|说明|
|-|-|
|closed|断路器关闭，允许所有请求通过|
|open|断路器打开，直接返回fallback方法，不去调用服务端|
|half-open|经过一段时间，让一个请求通过，如果成功，则切换为closed状态，如果失败，则切换为open状态|

##### （2）降级策略
* 慢调用比例
  * 在给定的时间窗口内，请求数达到设置的阈值 和 请求的平均响应时间小于设置的阈值，则进行熔断
  * 经过指定的时间窗口恢复
* 异常比例
  * 在给定的时间窗口内，请求数 和 错误率 都达到设置的阈值，则进行熔断
* 异常数（类似于异常比例）
* 在给定的时间窗口内，请求数 和 错误数 都达到设置的阈值，则进行熔断

##### （3）断路器相关参数（以 异常比例 为例)
* 快照时间窗
  * 统计在这个时间窗内的请求和错误数据，从而决定断路器的状态
  * 默认10s: default_metricsRollingStatisticalWindow = 10000
* 请求总数阈值
  * 在快照时间窗内，必须满足请求总数阈值才有资格熔断
  * 默认为20: default_circuitBreakerRequestVolumeThreshold = 20
* 错误百分比阈值
  * 错误率达到这个阈值，才会打开断路器
  * 默认为50%: default_circuitBreakerErrorThresholdPercentage = 50
* 睡眠时间
  * open状态，经过这么长时间，会进入half-open状态，允许一个请求通过
  * 默认5s: default_circuitBreakerSleepWindowInMilliseconds = 5000

##### （4）断路器工作原理（以 异常比例 为例)
![](./imgs/hystrix_01.jpg)

* 断路器初始为closed状态
* closed状态下
  * 失败的情况 超过 设置的阈值 则将断路器切换为open状态
  * 否则一直处于closed状态
* open状态下
  * 经过一段时间切换为half-open状态
* half-open状态下
  * 会允许一个请求通过
  * 如果该请求成功，则切换为closed状态
  * 如果该请求失败，则切换为open状态

#### 3.服务限流（以sentinel为例）

##### （1）限流指标
|指标|说明|
|-|-|
|QPS|对每秒接收的请求数做限制|
|线程数|对处理请求的线程数做限制|

##### （2）限流模式
|模式|说明（资源指接口）|
|-|-|
|直接|当本资源达到限流条件时，限流|
|关联|当关联的资源达到限流条件时，限流|
|链路|当从指定资源访问到本资源的请求达到限流条件时，限流|

##### （3）限流效果

|效果|说明|
|-|-|
|快速失败|直接返回错误信息|
|预热（warm up）|慢慢将限制提高到设置的阈值（但访问量下去后，下次还是会重新进行预热）|
|排队等待|达到限制后，则排队等待|

* 预热的工作原理
  * 默认coldFactor=3，即请求QPS从 threshold/3开始，经 预热时长 逐渐升至设置的QPS阈值

##### （4）其他限流策略

* 热点规则
  * 即对包含某个参数的请求进行限流
* 系统规则
  * 根据当前服务的指标（比如CPU、总QPS等）进行限流
