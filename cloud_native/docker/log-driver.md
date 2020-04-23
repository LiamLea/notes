[toc]
# log-dirver
### 概述
#### 支持的logging drivers
|Driver|说明|
|-|-|
|none|不保存日志，即docke logs不会查到任何东西|
|local|日志保存为一般格式|
|json-file|**默认**，日志保存为json格式|
|syslog|将日志写入syslog|

#### 1.查看当前使用的log-driver
```shell
docker info
```
```
...
Logging Driver: json-file
...
```
