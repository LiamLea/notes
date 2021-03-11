# limit connections

[toc]

### 概述

#### 1.相关模块
* ngx_http_limit_conn_module
* ngx_stream_limit_conn_module

#### 2.作用
根据key进行计数（key要用变量设置，如果用常量设置，所有请求都是相同的key，则就是用于控制总的并发数，没意义），对 特定情况下的 并发连接数进行限制

#### 3.连接计数
当前正在被处理的连接（而不是当前正被打开的连接数，worker_connections是统计的当前正被打开的连接数）

***

### 配置

#### 1.基础配置
* limit_conn_zone
  * 上下文：http
```shell
#设置共享内存区域，用于保存某些key的连接计数
limit_conn_zone <key> zone=<name>:<size>;
#limit_conn_zone $binary_remote_addr zone=addr:10m;
# <key> 用于计数的key，这里不同ip访问时，$binary_remote_addr的值都不一样，会在addr这个内存空间中，将$binary_remote_addr的值作为key，该key对应的值就是当前连接数
# <name> 给该共享内存区域取名，这里就叫addr
# <size> 内存的大小，这里是10m，当内存满了，会返回error给后面的所有请求
```

* limit_conn
  * 上下文：http, server, location
```shell
#设置连接数限制，会检查该内存区域内，自己的key对应的计数值，是否达到了限制值
limit_conn <zone_name> <number>;
#limit_conn addr 1;
```

* limit_conn_status
  * 上下文：http, server, location
```shell
#当达到限制时，返回的返回码
limit_conn_status <return_code | default=503>;
```

* limit_conn_log_level
  * 上下文：http, server, location
```shell
#当达到限制时，生成的日记的级别
limit_conn_log_level <level | default=error>;
```

#### 2.demo

##### （1）限制每个ip能够连接指定api的并发数
```shell
limit_conn_zone "$binary_remote_addr/$uri" zone=addr:10m;   #当请求进来，会根据自身的"$binary_remote_addr/$uri"值，在addr内存空间中，进行计数
limit_conn addr 10;
```
