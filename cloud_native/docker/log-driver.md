[toc]
# log-dirver
### 概述
#### 1.支持的logging drivers
|Driver|说明|
|-|-|
|none|不保存日志，即docke logs不会查到任何东西|
|local|日志保存为一般格式|
|json-file|**默认**，日志保存为json格式|
|syslog|将日志写入syslog|
|journald|将日志写入journald|
|fluntd|将日志发往fluentd|
|...||

#### 2.日志的生命周期
* 只有当容器被**删除**时，日志才会被删除
* 容器重启或者容器停止，日志都不会被删除

### 使用
#### 1.查看当前使用的log-driver
```shell
docker info

#Logging Driver: xx
```

#### 2.查看log的具体配置
```shell
docker inspect xx

#HostConfig.LogConfig
```

#### 3.使用json-file
* 注意：daemon.json对逗号的使用很严格，如果后面没有内容了，不要加逗号，否则会报错
* 只有把容器删掉重新创建，这下面的配置才会生效（重启docker只对新创建的容器有效)
* 也可以通过logrotate实现对容器日志的轮替
```yaml
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "hostname",    #将hostname这个标签记录进日志中
    "env": "os,kernel"      #将os和kernel这两个环境变量记录到日志中
  }
}
```
```shell
docker run -itd --labels hostname=host-1 -e os=linux -e kernel="3.14" xx
```
日志就会有如下记录
```json
"attrs":{"hostname":"host-1","os":"linux","kernel":"3.14"}
```
