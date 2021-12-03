# Log Collection Design

[toc]

### 设计

#### 1.采集流程设计

* filebeat采集日志，并进行multiline处理，然后发往kafka
* logstash从kafka中读取日志，并进行清洗，后存入es

#### 2.index设计
* 每个应用会分配一个app_id，是一个唯一的值，格式：`<app_name>-<app_env>-<addtition>-<log_type>`
* 每个应用的index就是其app_id
* 在kibana中，可以使用index pattern进行index聚合

#### 3.采集问题

##### （1）采集容器内的文件
* 方法一
  * 通过emptyDir将需要采集的日志挂载出来
* 方法二（建议）
  * 通过link file将日志文件链接到stdout或者stderr，需要日志的文件名一样
  ```shell
  #比如，制作镜像时，指定一下
  ln -s /proc/1/fd/1 /var/log/a.log
  ln -s /proc/1/fd/1 /var/log/b.log
  ```

#### 4.日志的分类
目前分为三类，后续有新的解析方式，需要增加日志类别

|日志类别|说明|区别方式|
|-|-|-|
|access|访问日志|`if [request]`|
|app|应用日志|`if ![request] and [logtime]`|
|raw|原始日志（没有相关grok能够匹配）|`if ![request] and ![logtime]`|

#### 5.使用方式

##### （1）filebeat
需要配置的地方
* 通过condition匹配出需要特殊处理的容器
  * multiline的处理
  * 时区的设置（当日志中缺少时区）

##### （2）logstash
需要配置的地方
* 当有新的日志格式需要处理时
  * 增加解析规则
  * date中增加相应规则

***

### filebeat采集

#### 1.输出到kafka中的日志格式
```shell
"labels": {
  "app_name": "应用名称",
  "app_env": "所在环境，比如：dev",
  "addition": "用于补充设置app_id的唯一性（可以利用namespace进行补充）",
  "timezone": "当无法通过日志匹配出时区时，需要指定时区（如果不指定默认为UTC时区）",
  "host": "主机名（如果在容器内就是容器名或者pod名）"
}
"message": ""
```

#### 2.filebeat的配置

注意：multiline要在这里处理

```yaml
#添加宿主机上的某些日志
filebeat.inputs:
- type: log
  paths:
  - "xx"
  fields:
    labels:
      app_name: "app名称"
      addition: "附加信息"
      timezone: "时区"
      host: xx
  fields_under_root: true

#通过emptyDir将需要采集的日志挂载出来，然后在宿主机就能通过指定路径读取改日志
filebeat.autodiscover:
  providers:

  - type: kubernetes
    templates:

      #需要特殊处理的日志
      - condition:
          regexp:
            kubernetes.pod.name: "iot-.*-backend"
        config:
        - type: log
          paths:
          - "/var/lib/kubelet/pods/${data.kubernetes.pod.uid}/volumes/kubernetes.io~empty-dir/volume-log/*/*.log"

        - type: container
          paths:
          - "/var/log/containers/*${data.kubernetes.container.id}.log"
          multiline.type: pattern
          multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
          multiline.negate: true
          multiline.match: after

      #收集k8s中所有容器的日志（需要排除上面特殊处理的日志）
      - condition:
          and:
          - not:
              regexp:
                kubernetes.pod.name: "filebeat|logstash"
          - not:
              regexp:
                kubernetes.pod.name: "iot-.*-backend"
        config:
        - type: container
          paths:
          - "/var/log/containers/*${data.kubernetes.container.id}.log"

#给容器日志添加相应标签
processors:
- add_labels:
    labels:
      app_env: test
- add_labels:
    labels:
      timezone: UTC
    when:
      not:
        has_fields: ['labels.timezone']

- copy_fields:
    fields:
    - from: kubernetes.container.name
      to: labels.app_name
    - from: kubernetes.namespace
      to: labels.addition
    - from: kubernetes.pod.name
      to: labels.host
    fail_on_error: false
    ignore_missing: true
    when:
      has_fields: ['kubernetes']

#输出到kafka
output.kafka:
  hosts: ["10.172.0.103:39092", "10.172.0.103:39093", "10.172.0.103:39094"]
  topic: 'all-logs_topic'
```

***

### logstash清洗

#### 1.清洗后的格式
```shell
"@timestamp": "2020-06-23T07:07:17.000Z",

"labels": {
  "app_id": "应用id（唯一），logstash根据这个确定日志发送到哪个index",
  "app_name": "应用名称",
  "app_env": "所在环境，比如：dev",
  "log_type": "日志类型(访问日志:access_、错误日志:error_、应用日志:app_等)，logstash需要根据此类型选择合适的解析形式，比如：access，当log_type为raw时，表示不需要清洗",
  "host": "主机名（如果在容器内就是容器名或者pod名）"
},

"level": "日志级别",
"trace_id": "请求链的id",
"module": "哪个模块（代码）产生的日志",
"message": "",

"request": {
    "remote_addr": "192.168.10.128",
    "request_method": "",
    "request_path": "",
    "request_time": <float>, #"请求时间（毫秒）(float类型)"
    "request_host": "访问地址",
    "http_version": "",
    "bytes_sent": <int>, #"发送的字节数（整数类型）"
    "status": <int> , #"返回码（整数类型）"
    "user_agent": "",
    "params": "请求中的参数"
}
```

#### 2.logstash配置

* container type采集到的日志，默认用容器中日志记录的时间作为`@timestamp`
* log type采集到的日志，默认用采集的时间作为`@timestamp`

```python
input {
  kafka {
    bootstrap_servers => "10.172.0.103:39092,10.172.0.103:39093,10.172.0.103:39094"
    topics => ["all-logs_topic"]
    auto_offset_reset => "earliest"
    group_id => "logstash-test-1"
    codec => json
  }
}

filter {
  #进行grok清洗
  grok{
    match => {
      "message" => [
        "%{IP:[request][remote_addr]}.*?\[%{HTTPDATE:logtime}\]\s+\"%{WORD:[request][request_method]}\s+%{URIPATH:[request][request_path]}(?:\?*(?<[request][params]>\S+))?\s+HTTP/%{NUMBER:[request][http_version]}\"\s+%{INT:[request][status]}\s+%{NOTSPACE:[request][bytes_sent]}(?:\s+\"(?<[request][host]>.*?)\")?(?:\s+\"(?<[request][user_agent]>.*?)\")?(?:\s*%{NUMBER:[request][request_time]})?",
        "\[%{TIMESTAMP_ISO8601:logtime}\].*?\[%{UUID:trace_id}\].*?\[%{LOGLEVEL:level}\s*\].*?\[(?<module>\S+)\]\s*--\s*(?<message>.*)",
        "%{DATESTAMP:logtime}\s+\[%{LOGLEVEL:level}\]\s%{POSINT:pid}#%{NUMBER:tid}:\s(?<message>.*)"  
      ]
    }
    overwrite => ["message"]
  }

  #根据解析出来的字段添加log_type
  if [request] {
    mutate {
        add_field => {
         "[labels][log_type]" => "access"
        }
       convert => {
        "[request][status]" => "integer"
        "[request][bytes_sent]" => "integer"
        "[request][request_time]" => "float"
       }
    }
  } else if [logtime] {
    mutate {
      add_field => {
       "[labels][log_type]" => "app"
      }
    }
  } else {
    mutate {
      add_field => {
       "[labels][log_type]" => "raw"
      }
    }
  }

  #设置level
  if ! [level] {
    mutate {
       add_field => {
        "level" => "INFO"
       }
    }
    grok {
      match => {
        "message" => "\b%{LOGLEVEL:level}\b"
      }
      overwrite => ["level"]
    }
    mutate {
      uppercase => [ "level" ]
    }
  }

  #清洗时间（如果清洗失败，使用默认时间）
  date {
     match => ["logtime", "dd/MMM/yyyy:HH:mm:ss Z", "yyyy-MM-dd HH:mm:ss"]
     target => "@timestamp"
     timezone => "%{[labels][timezone]}"
  }

  #统一清洗
  prune {
    whitelist_names => ["^@","^labels$","^level$","^trace_id$","^module$","^message$","^request$"]
    add_field => {
      "[labels][app_id]" => "%{[labels][app_name]}-%{[labels][app_env]}-%{[labels][addition]}-%{[labels][log_type]}"
    }
    remove_field => [ "[labels][timezone]" ]
  }
}

output {
  #stdout用于测试
  #stdout { codec => json }

  elasticsearch {
    hosts => "<IP:PORT>"
    index => "%{[labels][app_id]}"
  }
}
```

***

### 相关grok

#### 1.access日志

##### （1）解析规则一

* 样例数据
```
192.168.41.9 - - [28/May/2020:11:34:37 +0800] "GET / HTTP/1.1" 200 623 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36" 1.000

192.168.41.9 - - [28/May/2020:11:34:37 +0800] "GET /?a=b HTTP/1.1" 200 623 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"

192.168.33.41 - weblogic [20/Jul/2020:04:31:55 +0800] "GET /wls-exporter/metrics HTTP/1.1" 200 223109

10.233.72.106 - - [29/Nov/2021:08:58:00 +0000] "OPTIONS /cogiot-iot/network/backend/user/check/root HTTP/1.1" 200 -
```

* grok

```python
#通用格式（如果有其他格式，需要继续增加解析规则）
"%{IP:[request][remote_addr]}.*?\[%{HTTPDATE:logtime}\]\s+\"%{WORD:[request][request_method]}\s+%{URIPATH:[request][request_path]}(?:\?*(?<[request][params]>\S+))?\s+HTTP/%{NUMBER:[request][http_version]}\"\s+%{INT:[request][status]}\s+%{NOTSPACE:[request][bytes_sent]}(?:\s+\"(?<[request][host]>.*?)\")?(?:\s+\"(?<[request][user_agent]>.*?)\")?(?:\s*%{NUMBER:[request][request_time]})?"
```

#### 2.app日志

##### （1）解析规则一
* 样例数据
```shell
[2021-11-29 06:50:27] -- [644256fa-0526-403f-a021-42725919ed13] -- [INFO ]: [com.cogiot.websocket.handler.CogiotWebsocketHandler] -- receive msg from sxw:{"type":0,"data":"ping"}
```

* grok
```shell
"\[%{TIMESTAMP_ISO8601:logtime}\].*?\[%{UUID:trace_id}\].*?\[%{LOGLEVEL:level}\s*\].*?\[(?<module>\S+)\]\s*--\s*(?<message>.*)"
```

##### （2）解析规则二
* 样例数据
```shell
2020/05/28 15:30:50 [emerg] 2515#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
```

* grok
```shell
"%{DATESTAMP:logtime}\s+\[%{LOGLEVEL:level}\]\s%{POSINT:pid}#%{NUMBER:tid}:\s(?<message>.*)"
```
