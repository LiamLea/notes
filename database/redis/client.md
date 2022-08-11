[toc]

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
