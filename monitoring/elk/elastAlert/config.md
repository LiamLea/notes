# config


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [config](#config)
    - [全局配置](#全局配置)
      - [1.配置文件: `config.yml`](#1配置文件-configyml)
        - [（1）buffer_time、run_every和timeframe区别](#1buffer_time-run_every和timeframe区别)
    - [rules配置: ``<rules_folder>/*.yaml``](#rules配置-rules_folderyaml)
      - [1.基础配置](#1基础配置)
      - [2.常用rule type](#2常用rule-type)
        - [（1）any](#1any)
        - [（2）blacklist](#2blacklist)
        - [（3）whitelist](#3whitelist)
        - [（4）change](#4change)
        - [（5）frequency](#5frequency)
        - [（6）spike](#6spike)
        - [（7）flatline](#7flatline)
        - [（8）new_term](#8new_term)
        - [（9）cardinality](#9cardinality)
      - [3.常用filter](#3常用filter)
        - [（1）query_string（通用，能够替代term、wildcard等）](#1query_string通用能够替代term-wildcard等)
        - [（2）term](#2term)
        - [（3）wildcard（通配符）](#3wildcard通配符)
        - [（4）range](#4range)
      - [4.常用告警方式](#4常用告警方式)
        - [（1）Command](#1command)
        - [（2）alertmanager](#2alertmanager)

<!-- /code_chunk_output -->

### 全局配置

#### 1.配置文件: `config.yml`

[参考](https://elastalert2.readthedocs.io/en/stable/elastalert.html#configuration)

```yaml
#连接es的配置
es_host: <host>
es_port: <port>
es_username: <user>
es_password: <password>
use_ssl: False
#指定index（用于保存elastalert的状态）
writeback_index: <index_name>

#rules配置
#指定存放rules的目录（会加载*.yaml）
rules_folder: <dir_path>
#多久去查询es一次（判断是否符合rule的条件）
run_every:
  minutes: <int>
#查询now-buffer_time -- now的日志，防止遗漏日志
# 这个参数的设置需要考虑日志 从采集到上报 所需的时间
buffer_time:
  minutes: 10

#告警相关
#报警时会添加元数据（包括该rule的category，description，owner，priority）
add_metadata_alert: True
owner: STRING         #标明告警的利益相关者
priority: INT         #标明告警的级别
category: STRING      #标明告警的类别
description: STRING   #对该告警的描述信息
```

##### （1）buffer_time、run_every和timeframe区别

* run_every
```
多长时间去query一次（这个时间依据的是当前的时间）
```
比如当运行elastAlert后，elastAlert会每隔run_every的时间去query一次

* buffer_time
```
设置每次query的窗口大小（窗口是一个时间段，该时间依据是document记录在es中的时间）
```
比如现在是12:00，窗口大小为10分钟，则查询日志的时间范围是11:50-12:00

为什么需要这样
如果不设置窗口大小，则每次查询的是一个点，则会遗漏到很多日志

* timeframe
```
某些rule类型进行判断时，用来进行统计的时间段
```
比如5分钟内，某个发生3次则报警，这个5分钟就是timeframe
会利用内存进行相关记录，比如发生了发生了一次，记录在内存中
这样就能判断是否在5分钟内是否发生了3次

***

### rules配置: ``<rules_folder>/*.yaml``

#### 1.基础配置

```yaml
#可以覆盖全局配置

#----------基本信息---------------
name: <rule_name>
is_enabled: true
# 指定index
index: <index>

#----------设置告警触发条件---------------
# 不通的rule type有不同的设置参数
type: <rule_type>

#定义filter（多个filter，即and）
# filter为空表示，匹配该index中所有document
filter: []

#导入文件（放在rules/目录下，不能以.yml或.yaml结尾）
#将通用配置放在里面
import:
- global.config
```

* `rules/global.config`
```yaml
#----------告警配置---------------
# 将多个match合并在一个alert中发过去
#   比如设置2h：在12:00产生了一个match，会在14:00的时候发送一个alert，不管这中间发生了多少match
# aggregation时，会打印如下日志（表示已经触发了告警，只是还没发送）:
#   INFO:elastalert:New aggregation for test_rule, aggregation_key: None. next alert at 2023-02-10 08:15:29.789938+00:00.
aggregation:
  minutes: 1

# 在一段时间内，忽略query_key都相同的match
# 忽略时会打印如下日志:
#   INFO:elastalert:Ignoring match for silenced rule test_rule.node-4, None, syslog.host.app-test
realert:
  minutes: 1
query_key:
- labels.host
- labels.pod
- labels.app_id

#----------设置告警内容: subject和text---------------
# 将多个matches合并为一个alert
# {0} 表示引用alert_subject_args[0]参数
alert_subject: "{0}"
#可以使用的参数: rule中字段 或者 elastic中的字段
alert_subject_args:
- "name"

alert_text_type: alert_text_jinja
alert_text: |
  Alert triggered! *({{num_hits}} Matches!)*
  {{origin_message}}

#会在alert_text最前面加上，一个表，表的列就是下面这些字段（用于分类统计）
summary_table_fields:
- labels.host
- labels.pod
- labels.app_id
summary_table_type: markdown

# 定义告警方式
alert:
#- debug    #可以用于告警调试
- alertmanager

#----------alertmanager配置---------------
```

#### 2.常用rule type

##### （1）any
只要有匹配就报警；

##### （2）blacklist
* compare_key字段的内容匹配上 blacklist数组里任意内容；  
```yaml
compare_key: "request"
blacklist:
  - /index.html        #request字段匹配有请求/index.html就报警
  - "!file /tmp/blacklist1.txt"
  - "!file /tmp/blacklist2.txt"
```

##### （3）whitelist
* compare_key字段的内容一个都没能匹配上whitelist数组里内容；  
```yaml
compare_key: "request"
ignore_null: "true"
whitelist:
  - /index.html        #request字段匹配过滤请求/index.html的请求
  - "!file /tmp/blacklist1.txt"
  - "!file /tmp/blacklist2.txt"
```

##### （4）change
* 在相同query_key条件下，compare_key字段的内容，在 timeframe范围内 发送变化
```yaml
#1分钟内，将 server字段值相同 的doc 进行对比，如果codec字段值变化，触发告警
name: change_rule
type: change
index: testalert

timeframe:
    minutes: 1

compare_key: codec

ignore_null: true

query_key: server
```

##### （5）frequency
* 在相同 query_key条件下，timeframe 范围内有num_events个被过滤出 来的异常
```yaml
type: frequency
index: n-nanjing-console
num_events: 5
timeframe:
    minutes: 1
filter:
- term:
   status: "404"
```

##### （6）spike
* 在相同query_key条件下，前后两个timeframe范围内数据量相差比例超过spike_height。其中可以通过spike_type设置具体涨跌方向是- up,down,both 。还可以通过threshold_ref设置要求上一个周期数据量的下限，threshold_cur设置要求当前周期数据量的下限，如果数据量不到下限，也不触发；
```yaml
#参考窗口数据量为3，当前窗口超过参考窗口数据量次数1次，触发告警。
name: spike_rule
type: spike
index: testalert

timeframe:
    minutes: 1

threshold_cur: 3

spike_height: 1

spike_type: "up"

filter:
- term:
    status: "spike"
```  

##### （7）flatline
* timeframe 范围内，数据量小于threshold 阈值；  
```yaml
#当1分钟内信息量低于3条时，触发告警
name: flatline_rule
type: flatline
index: testalert

timeframe:
    minutes: 1

threshold: 3
```

##### （8）new_term
* fields字段新出现之前terms_window_size(默认30天)范围内最多的terms_size (默认50)个结果以外的数据；  

##### （9）cardinality
* 在相同 query_key条件下，timeframe范围内cardinality_field的值超过 max_cardinality 或者低于min_cardinality  
```yaml
#1分钟内，level的数量超过2个(不包括2个)，触发告警
name: test_rule
index: testalert
type: cardinality

timeframe:
    minutes: 1

cardinality_field: level

max_cardinality: 2
```

#### 3.常用filter

[参考](https://elastalert2.readthedocs.io/en/stable/recipes/writing_filters.html)

**注意**: 需要判断搜索的字段类型
  * 如果是 **text类型** 的字段，则在index之前 会进行analyzed（所以空格匹配不到）
    * 比如message字段，就是text类型，因为日志的index template默认会将message这个字段设置text类型，便于检索
  * 如果是 **keyword类型** 的字段，不会进行analyzed（空格也能够被匹配）
  * 默认搜索使用的analyzer和index使用的analyzer是一样的

#####（1）query_string（通用，能够替代term、wildcard等）
[参考](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)

```yaml
filter:
#query模糊匹配
- query:
    query_string:
      query: "message: haha xixi" #匹配haha或者xixi

#通配符
- query:
    query_string:
      query: "message: hah*h" #使用通配符匹配，比如：hahaaah

#regex（需要完全匹配）
# 对于text类型的字段，regex只能匹配其中一个词
# 对于keyword字段，regex能匹配完整的内容
- query:
    query_string:
      query: "message: /hah.*h/" #使用正则匹配，比如：hahaaah

#对于text类型的字段匹配phrase
- query:
    query_string:
      query: "message: \"haha xixi\"" #匹配（包括空格）: haha xixi     

#使用OR连接
- query:
    query_string:
      query: "field: value OR otherfield: othervalue"

#使用AND连接
- query:
    query_string:
       query: "this: that AND these: those"
```

#####（2）term
* 会匹配是否包含某个词（不能有空格）
  * 因为elastic中的字段默认都进行了analyzed
```yaml
filter:
- term:
    name_field: "bob"     #name_filed==bob
- term:
    _type: "login_logs"
```
```yaml
filter:
- terms:
    field: ["value1", "value2"]   #field == value1或者value2
```

#####（3）wildcard（通配符）
* 不能匹配有空格的内容
  * 因为elastic中的字段默认都进行了analyzed
```yaml
filter:
- query:
    wildcard:
      field: "foo*bar"
```

#####（4）range
```yaml
filter:
- query:
    wildcard:
      field: "foo*bar"
```

#### 4.常用告警方式
[参考](https://elastalert2.readthedocs.io/en/stable/ruletypes.html#alerts)
##### （1）Command
```yaml
alert:
  - command
command: ["/bin/send_alert", "--username", "{field}"]
#传递参数：{字段[子字段]}
```

##### （2）alertmanager
```yaml
#----------alertmanager告警配置---------------
alertmanager_hosts:
- "http://10.10.10.163:50522/alertmanager"

#alertmanager_alertname: "<default=rule_name>"

# 将alert_subject用于annotation中的哪个字段（默认为summary字段）
# 所以这里不改变，alertmanager_annotations.summary不会生效
#alertmanager_alert_subject_labelname: "subject"
# 将alert_text用于annotation中的哪个字段（默认为description字段）
# 所以这里不改变，alertmanager_annotations.description不会生效
#alertmanager_alert_text_labelname: "text"

#设置告警的annotations
alertmanager_annotations: {}

#设置告警的labels
alertmanager_labels:
  severity: critical
  source: "elastalert"

# 通过 已存在的字段 设置lables
# 比如: msg: "message"，会设置msg这个label，值为message对应的字段的值
alertmanager_fields:
  #<label_name>: "<some_elastic_fieldname>"
  #加一个时间戳，因为alertmanager告警的fintprint是通过label产生的
  timestamp: "@timestamp"

```
