# traffic management

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [traffic management](#traffic-management)
    - [概述](#概述)
      - [1.流量管控流程](#1流量管控流程)
      - [2.服务治理](#2服务治理)
        - [（1）timeout](#1timeout)
        - [（2）retries](#2retries)
        - [（3）circuit breakers（断路器，是一种保护机制）](#3circuit-breakers断路器是一种保护机制)
        - [（4）fault injection（故障注入，是一种测试机制）](#4fault-injection故障注入是一种测试机制)
        - [（5）failure recovery（故障恢复）](#5failure-recovery故障恢复)

<!-- /code_chunk_output -->

### 概述

#### 1.流量管控流程
![](./imgs/traffic_management_01.png)

#### 2.服务治理

##### （1）timeout
设置envoy proxy等待响应超过这个时间，则认为超时（即失败）
在VitualService中设置，无需修改代码
##### （2）retries
设置envoy proxy尝试连接服务的最大次数
在VirualService中设置
##### （3）circuit breakers（断路器，是一种保护机制）
设置envoy proxy支持的最大并发数、最大失败次数等
当达到上限，流量暂时就不会路由到该envoy proxy
在DestinationRule中设置
##### （4）fault injection（故障注入，是一种测试机制）
可以注入两种故障：delay 和 abort
在VirtualService中设置
##### （5）failure recovery（故障恢复）
对应用来说时透明的，即不需要配置
如果应用本身设置了故障恢复，可能会和istio的故障恢复冲突
有些故障是istio无法恢复的，需要应用自己解决（比如503错误）
