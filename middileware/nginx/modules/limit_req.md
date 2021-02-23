# ngx_http_limit_req_module

[toc]

### 概述

#### 1.作用
根据key进行计数（key要用变量设置，如果用常量设置，所有请求都是相同的key，则就是用于控制总的并发数，没意义），对 特定情况的 请求速率 进行限制

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
  * 上下文：http server location
```shell
#设置请求速率，会检查该内存区域内，自己的key对应的计数值，是否达到了限制值
limit_req zone=<zone_name> [burst=<number | default=0>] [nodelay | delay=<number | default=0>];
#当请求超过处理的速率，新的请求会延迟
#burst 设置最大的同时请求数，同时的请求数（包括延迟的请求）超过burst的值，新的请求会返回错误（默认为0，即没有限制）
#nodelay 表示不延迟请求
#delay 延迟的请求数，默认为0，表示延迟所有请求
```

* limit_req_status
  * 上下文：http server location
```shell
#返回给被拒绝的请求的返回码
limit_req_status <return_code | default=503>;
```

* limit_req_log_level
  * 上下文：http server location
```shell
#当拒绝请求时，生成的日记的级别
limit_req_log_level <level | default=error>;
```
