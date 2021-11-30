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

***

### filebeat采集

#### 1.输出到kafka中的日志格式
```shell
"labels": {
  "app_name": "应用名称",
  "app_env": "所在环境，比如：dev",
  "addition": "用于补充设置app_id的唯一性（可以利用namespace进行补充）",
  "log_type": "日志类型(访问日志:access_、错误日志:error_、应用日志:app_等)，logstash需要根据此类型选择合适的解析形式，比如：access，当log_type为raw时，表示不需要清洗",
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
      app_name: xx
      addition: ""
      log_type: access
      host: xx
  fields_under_root: true

#通过emptyDir将需要采集的日志挂载出来，然后在宿主机就能通过指定路径读取改日志
filebeat.autodiscover:
  providers:

    - type: kubernetes
      templates:

      - condition:
          regexp:
            kubernetes.pod.name: "iot-.*-backend"
        config:
        - type: log
          paths:
          - "/var/lib/kubelet/pods/${data.kubernetes.pod.uid}/volumes/kubernetes.io~empty-dir/volume-log/*/*.log"
          fields:
            labels:
              log_type: access
          fields_under_root: true

        - type: container
          paths:
          - "/var/log/containers/*${data.kubernetes.container.id}.log"
          multiline.type: pattern
          multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
          multiline.negate: true
          multiline.match: after
          fields:
            labels:
              log_type: app_iot
          fields_under_root: true

      - condition:
          regexp:
            kubernetes.pod.name: "iot-.*-ui"
        config:
        - type: container
          paths:
          - "/var/log/containers/*${data.kubernetes.container.id}.log"
          fields:
            labels:
              log_type: access
          fields_under_root: true

#给容器日志添加相应标签
processors:
- add_labels:
    labels:
      app_env: test

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
    "request_time": "请求时间（毫秒）(float类型)",
    "request_host": "访问地址",
    "http_version": "",
    "bytes_sent": "发送的字节数（整数类型）",
    "status": "返回码（整数类型）",
    "user_agent": "",
    "params": "请求中的参数"
}
```

#### 2.logstash配置
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
  if [labels][log_type] == "access" {

  } else if [labels][log_type] == "raw" {

  } else {
    drop {}
  }

  #统一清洗
  prune {
    whitelist_names => ["^@","^labels$","^level$","^trace_id$","^module$","^message$","^request$"]
    add_field => {
      "[labels][app_id]" => "%{[labels][app_name]}-%{[labels][app_env]}-%{[labels][addition]}-%{[labels][log_type]}"
    }
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
* 样例数据
```
192.168.41.9 - - [28/May/2020:11:34:37 +0800] "GET / HTTP/1.1" 200 623 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36" 1.000

192.168.41.9 - - [28/May/2020:11:34:37 +0800] "GET /?a=b HTTP/1.1" 200 623 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"

192.168.33.41 - weblogic [20/Jul/2020:04:31:55 +0800] "GET /wls-exporter/metrics HTTP/1.1" 200 223109
```
* 解析规则
```python
if [labels][log_type] == "access" {
  grok{
    match => {
      "message" => "%{IP:[request][remote_addr]}.*?\[%{HTTPDATE:logtime}\]\s+\"%{WORD:[request][request_method]}\s+%{URIPATH:[request][request_path]}(?:\?*(?<[request][params]>\S+))?\s+HTTP/%{NUMBER:[request][http_version]}\"\s+%{INT:[request][status]}\s%{INT:[request][bytes_sent]}(?:\s+\"(?<[request][host]>.*?)\")?(?:\s+\"(?<[request][user_agent]>.*?)\")?(?:\s*%{NUMBER:[request][request_time]})?"
    }
  }

  date {
     match => ["logtime", "dd/MMM/yyyy:HH:mm:ss Z"]
     target => "@timestamp"
  }

  mutate {
     add_field => {
      "level" => "INFO"
     }
     convert => {
      "[request][status]" => "integer"
      "[request][bytes_sent]" => "integer"
      "[request][request_time]" => "float"
     }
  }
}
```

#### 2.error日志

##### （1）nginx error日志
* 样例数据
```
2020/05/28 15:30:50 [emerg] 2515#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
```
* 解析规则
```python
if [fields][type] == "error_nginx" {

  grok{
    match => {
      "message" => "%{DATESTAMP:logtime}\s+\[%{LOGLEVEL:severity}\]\s%{POSINT:pid}#%{NUMBER:tid}:\s(?<message>.*)"
    }
    overwrite => ["message"]
  }

  date {
    match => ["logtime", "yyyy/MM/dd HH:mm:ss"]
    timezone => "Asia/Shanghai"
    target => "@timestamp"
  }
}
```

#### 3.交换机

##### （1）cisco交换机
* 样例数据
```
*Aug  6 05:10:36.671: %LINK-3-UPDOWN: Interface GigabitEthernet0/1, changed state to down
```
* 解析规则
```python
if [fields][type] == "switch_cisco" {
  if [message] =~ "^\*" {
    grok {
      match => {
        "message" => "\*(?<logtime>([^:]*:[^:]*:[^:]*)):\s%{GREEDYDATA:type}:\s%{GREEDYDATA:message}"
      }
      overwrite => ["message"]
    }
  }
  else {
    drop {}
  }

  date {
    match => ["logtime", "MMM dd HH:mm:ss.SSS","MMM  d HH:mm:ss.SSS"]
    timezone => "Asia/Shanghai"  
    target => "@timestamp"
  }
}
```

##### （2）H3c交换机
* 样例数据
  * filebeat采集时使用multiline合并为一行（将以冒号结尾的并入下一行
```
%Apr 26 12:01:52:527 2000 S5820X_24 OPTMOD/4/MODULE_IN:
 Ten-GigabitEthernet1/0/12: The transceiver is 10G_BASE_SR_SFP.
```

* 解析规则
```python
if [fields][type] == "switch_h3c" {
  if [message] =~ '^%' {
    grok{
      match => {
        "message" => "\%%{GREEDYDATA:logtime}\s%{NOTSPACE:model}\s%{NOTSPACE:type}:\s*%{GREEDYDATA:message}"
      }
      overwrite => ["message"]
    }
  }
  else {
    drop {}
  }

  date {
    match => ["logtime", "MMM dd HH:mm:ss:SSS yyyy","MMM  dd HH:mm:ss:SSS yyyy"]
    timezone => "Asia/Shanghai"  
    target => "@timestamp"
  }
}
```

#### 4.应用日志
* 样例数据
```shell
[2021-11-29 06:50:27] -- [644256fa-0526-403f-a021-42725919ed13] -- [INFO ]: [com.cogiot.websocket.handler.CogiotWebsocketHandler] -- receive msg from sxw:{"type":0,"data":"ping"}
```

* 解析规则

```python
if [labels][log_type] == "app_iot" {

  grok{
    match => {
      "message" => "\[%{TIMESTAMP_ISO8601:logtime}\].*?\[.*?\].*?\[%{LOGLEVEL:level}\s*\].*?\[(?<module>\S+)\]\s*--\s*(?<message>.*)"
    }
    overwrite => ["message"]
  }

  date {
     match => ["logtime", "yyyy-MM-dd HH:mm:ss"]
     target => "@timestamp"
     timezone => "UTC"
  }
}
```
