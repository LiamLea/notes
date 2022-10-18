# ngx_http_limit_req_module

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ngx_http_limit_req_module](#ngx_http_limit_req_module)
    - [概述](#概述)
      - [1.作用](#1作用)
      - [2.限流（Traffic shaping）算法](#2限流traffic-shaping算法)
        - [（1）漏桶算法（leaky bucket）](#1漏桶算法leaky-bucket)
        - [（2）令牌桶算法（token bucket）](#2令牌桶算法token-bucket)
        - [（3）区别](#3区别)
      - [2.实现原理](#2实现原理)
        - [（1）burst突发量](#1burst突发量)
        - [（2）delay（令牌桶，需要nginx版本大于1.15.7）](#2delay令牌桶需要nginx版本大于1157)
    - [使用](#使用)
      - [1.基础配置](#1基础配置)

<!-- /code_chunk_output -->

### 概述

#### 1.作用
根据key进行计数（key要用变量设置，如果用常量设置，所有请求都是相同的key，则就是用于控制总的速率），对 特定情况的 请求速率 进行限制

#### 2.限流（Traffic shaping）算法

##### （1）漏桶算法（leaky bucket）
流出去的水的速率是固定的（处理的速率），倒入的水是不固定的（接收的任务），但是只要超过桶的容积，水就会溢出（丢弃任务）
* 实现：FIFO队列，队列长度就是桶的容积，每个时间间隔会从队列中取出数据（流出去的水）

##### （2）令牌桶算法（token bucket）
桶里存放一定数量的令牌，流量到了，会先去桶里获取令牌，有了令牌才会被处理，没有令牌就会等待

##### （3）区别
|leaky bucket|token bucket|
|-|-|
|恒定速率，将突发流量转换成统一流量|速率不恒定，有最大并发量|
|当桶满了，新的数据会被丢弃|当桶满了，会等待|

#### 2.实现原理
* 请求速率
nginx以毫秒粒度追踪请求，因此120r/m等价于2r/s，等价于1r/500ms，即每500ms处理一个请求
</br>
* 实现
维护一个等待队列，该队列中存放当前来不及处理的请求
每个时间间隔，从等待队列中取出一定数量的请求，进行处理


##### （1）burst突发量
* 等到队列的长度，当队列满时，新的请求就会被拒绝
  * 比如rate=2r/4，此时来了5个并发请求，如果burst设为2，则就会有1个请求被拒绝，设为1，就会有2两个请求被拒绝
* 默认burst为0

##### （2）delay（令牌桶，需要nginx版本大于1.15.7）
令牌的数量 = delay的值（nodelay表示delay的值=burst的值）
* delay的值不能超过burst的值
* 当delay=0时，所有的超过请求能力的请求都会被延迟
* 每个时间间隔，令牌的数量都会加1

***

### 使用

#### 1.基础配置
* limit_req_zone
  * 上下文：http
```shell
#设置共享内存区域，用于保存某些key的连接计数
limit_req_zone <key> zone=<name>:<size> rate=<rate>;
#limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
# <key> 用于计数的key，这里不同ip访问时，$binary_remote_addr的值都不一样，会在addr这个内存空间中，将$binary_remote_addr的值作为key，该key对应的值 就是 指定时间内的请求数
# <name> 给该共享内存区域取名，这里就叫addr
# <size> 内存的大小，这里是10m，当内存满了，会返回error给后面的所有请求
# <rate> 指定请求速率的限制，这里是1r/s，即每秒最多处理一个请求
```

* limit_req
  * 上下文：http, server, location
```shell
#设置请求速率，会检查该内存区域内，自己的key对应的计数值，是否达到了限制值
limit_req zone=<zone_name> [burst=<number | default=0>] [nodelay | delay=<number | default=0>];
```

* limit_req_status
  * 上下文：http, server, location
```shell
#返回给被拒绝的请求的返回码
limit_req_status <return_code | default=503>;
```

* limit_req_log_level
  * 上下文：http, server, location
```shell
#当拒绝请求时，生成的日记的级别
limit_req_log_level <level | default=error>;
```
