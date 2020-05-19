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

### 使用
#### 1.查看当前使用的log-driver
```shell
docker info

#Logging Driver: xx
```

#### 1.使用json-file
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
