# Log Collection Design

[toc]

### 设计

#### 1.采集流程设计

* filebeat采集日志，并进行multiline处理，然后发往kafka
* logstash从kafka中读取日志，并进行清洗，后存入es

#### 2.index设计
* 每个应用会分配一个app_id，是一个唯一的值，格式：`<app_name>_<app_env>_<addtition>_<log_type>`
* 每个应用的index就是其app_id
* 在kibana中，可以使用index pattern进行index聚合

***

### filebeat采集

#### 1.输出到kafka中的日志格式
```shell
"labels": {
  "app_name": "应用名称",
  "app_env": "所在环境，比如：dev",
  "addtition": "用于补充设置app_id的唯一性（可以利用namespace进行补充）",
  "log_type": "日志类型(访问日志、运行日志、错误日志等)，logstash需要根据此类型选择合适的解析形式，比如：access",
  "host": "主机名（如果在容器内就是容器名或者pod名）"
}
"message": ""
```

#### 2.filebeat的配置

注意：multiline要在这里处理

```yaml
filebeat.inputs:
#采集所有容器的日志
- type: container
  paths:
  - /var/log/containers/*.log
  exclude_files: ['^filebeat.*']
  fields:
    labels:
      app_env: test-sub
  fields_under_root: true

  processors:
  - add_kubernetes_metadata:
      matchers:
      - logs_path:
          logs_path: "/var/log/containers/"

  #给容器的日志加上标签
  - copy_fields:
      fields:
      - from: kubernetes.container.name
        to: labels.app_name
      - from: kubernetes.namespace
        to: labels.addtition
      - from: kubernetes.pod.name
        to: labels.host
      fail_on_error: false
      ignore_missing: true

  - add_labels:
      labels:
        log_type: iot_app
      when:
        or:
        - contains:
            kubernetes.pod.name: "iot-network-backend"
        - contains:
            kubernetes.pod.name: "iot-account-backend"

#添加宿主机上的某些日志
- type: log
  paths:
  - "/var/log/cogiot/iot-network-backend/*/*.log"
  fields:
    labels:
      app_name: iot-network-backend
      app_env: test-sub
      addition: ""
      log_type: access
      host: xx
  fields_under_root: true

#通过empty将需要采集的日志挂载出来，然后在宿主机就能通过指定路径读取改日志
filebeat.autodiscover:
  providers:
    - type: kubernetes
      templates:
      - condition:
          or:
          - contains:
              kubernetes.pod.name: "iot-network-backend"
          - contains:
              kubernetes.pod.name: "iot-account-backend"
        config:
        - type: log
          paths:
          - "/var/lib/kubelet/pods/*/volumes/kubernetes.io~empty-dir/volume-log/*/*.log"
          fields:
            labels:
              app_name: ${data.kubernetes.container.name}
              app_env: test-sub
              addtition: ${data.kubernetes.namespace}
              log_type: access
              host: ${data.kubernetes.pod.name}
          fields_under_root: true

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
  "log_type": "日志类型(访问日志、运行日志、错误日志等)，logstash需要根据此类型选择合适的解析形式，比如：access",
  "host": "主机名（如果在容器内就是容器名或者pod名）"
}

"level": "日志级别",

"request": {
    "remote_addr": "192.168.10.128",
    "request_method": "",
    "request_path": "",
    "request_time": "请求时间（毫秒）",
    "request_host": "访问地址",
    "http_version": "",
    "bytes_sent": "",
    "status": "",
    "user_agent": "",
    "params": "请求中的参数",
    "trace_id": "请求链的id"
}

"message": ""
```

***

### 相关grok

#### 1.access log
* 样例数据
```
192.168.41.9 - - [28/May/2020:11:34:37 +0800] "GET / HTTP/1.1" 200 623 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36" 1.000
```
* 解析规则
```python
if [fields][type] == "nginx_access" {

  grok{
    match => {
      "message" => "%{IP:request.remote_addr}.*?\[%{HTTPDATE:logtime}\]\s+\"%{WORD:request.request_method}\s+%{URIPATH:request.request_path}\s+HTTP/%{NUMBER:request.http_version}\"\s+%{INT:request.status}\s%{INT:request.bytes_sent}\s+\"(?<request.host>.*?)\"\s+\"(?<request.user_agent>.*?)\"(?:\s*(?<request.request_time>\S*))?"
    }
   }

   date {
     match => ["logtime", "dd/MMM/yyyy:HH:mm:ss Z"]
     target => "@timestamp"
   }

   mutate {
     add_field => {
      "level" => "info"
     }
     remove_field => ["logtime"]
     convert => {
      "[request][status]" => "integer"
      "[request][bytes_sent]" => "integer"
      "[request][request_time]" => "float"
     }
   }
}
```

#### 2.nginx error
* 样例数据
```
2020/05/28 15:30:50 [emerg] 2515#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
```
* 解析规则
```python
if [fields][type] == "nginx_error" {

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

  mutate {
    remove_field => ["logtime"]
  }
}
```

#### 3.cisco交换机
* 样例数据
```
*Aug  6 05:10:36.671: %LINK-3-UPDOWN: Interface GigabitEthernet0/1, changed state to down
```
* 解析规则
```python
if [fields][type] == "cisco_switch" {
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

  mutate {
    remove_field => ["logtime"]
  }
}
```

#### 4.H3c交换机
* 样例数据
  * filebeat采集时使用multiline合并为一行（将以冒号结尾的并入下一行
```
%Apr 26 12:01:52:527 2000 S5820X_24 OPTMOD/4/MODULE_IN:
 Ten-GigabitEthernet1/0/12: The transceiver is 10G_BASE_SR_SFP.
```

* 解析规则
```python
if [fields][type] == "h3c_switch" {
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
  mutate {
    remove_field => ["logtime"]
  }
}
```

#### 5.weblogic access

* 样例数据
```shell
192.168.33.41 - weblogic [20/Jul/2020:04:31:55 +0800] "GET /wls-exporter/metrics HTTP/1.1" 200 223109
```

* 解析规则
```python
if [fields][type] == "weblogic_access" {

  grok{
    match => {
      "message" => "%{IP:request.remote_addr}\s-(?:\s%{WORD:type})?\s\[%{HTTPDATE:logtime}\]\s\"%{WORD:request.request_method}\s%{URIPATH:request.request_path}\sHTTP/%{NUMBER:request.http_version}\"\s%{INT:request.status}\s%{INT:request.bytes_sent}"
    }
   }

   date {
     match => ["logtime", "dd/MMM/yyyy:HH:mm:ss Z"]
     target => "@timestamp"
   }

   mutate {
     add_field => {
      "level" => "info"
     }
     remove_field => ["logtime"]
     convert => {
      "[request][status]" => "integer"
      "[request][bytes_sent]" => "integer"
     }
   }
}
```
