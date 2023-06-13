
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [client](#client)
  - [1.连接redis](#1连接redis)
  - [2.连接redis集群](#2连接redis集群)
  - [3.常用命令](#3常用命令)
    - [（1）配置相关](#1配置相关)
    - [（2）基本信息相关](#2基本信息相关)
    - [（3）集群相关](#3集群相关)
    - [（4）pub/sub相关](#4pubsub相关)

<!-- /code_chunk_output -->

### client

[参考](https://redis.io/commands/)

#### 1.连接redis

```shell
redis-cli -h <ip> -p <port> -a <password>
```

#### 2.连接redis集群
```shell
redis-cli -c -h <ip> -p <port> -a <password>
```

#### 3.常用命令

##### （1）配置相关
* 查看配置
```shell
config get *
```

##### （2）基本信息相关

* 查看客户端信息
```shell
client info
```

##### （3）集群相关

* 查看集群信息
```shell
cluster info
```

##### （4）pub/sub相关

* 往一个channel发布消息
```shell
PUBLISH <channel> <message>
```

* 监听某个channel
```shell
SUBSCRIBE <channel>
```
