[toc]
### 概述
#### 1.有四个部分
* 全局配置：`global`
* 加载rule文件：`rule_files`
* 采集配置：`scrape_configs`
* 告警配置：`alerting`
#### 2.基本格式
```yaml
global:
  scrape_internal: 15s           #采集间隔
  evaluation_internal: 15s      #监控规则评估的间隔，看是否达到告警要求

#配置告警发往哪里
alerting:
  alertmanagers:
   - static_configs:
      - targets: ["IP:PORT"]

#配置数据源（即从哪里pull数据）
scrape_config:
- job_name: xx                #数据源的名称
  staic_configs:
  - targets: ["IP:PORT"]      #exporter的地址，可以有多个
```
#### 3.重新加载配置
发送SIGHUP到prometheus进程
***
### 全局配置
```yaml
global:

  #设置抓取的频率
  scrape_interval: <TIME>
  #设置抓取请求的超时时间
  scrape_timeout: <TIME>

  #设置执行rule的频率
  evaluation_interval: <TIME>

  #当与外部系统通信时，给时间序列设置的标签
  external_labels:
    <LABEL_KEY>: <LABEL_VALUE>

  #设置 存储query语句的 日志
  query_log_file: <FILE_PATH>
```

***

### 加载rule文件
```yaml
rule_files:
- <PATH>    #可以使用通配符(*)
```

***

### 采集配置
#### 1.概述
```yaml
scape_configs:
- job_name: <NAME>

  scrape_internal: <TIME>
  scrape_timeout: <TIME>

  metrics_path: <URL_PATH>   #默认为 /metrics

  #用于解决server端的label和exporter端用户自定义label冲突的问题
  #默认为false，保留用户自定义的label
  honor_labels: <BOOLEAN>

  #时间序列中的时间 是否使用采集到的数据中的时间
  #默认为true，即使用采集到的数据中的时间
  honor_timestamps: <BOOLEAN>

  #设置用于请求的协议，只有两种：http 和 https
  schema: <PROTOCOL>

  #配置k8s服务发现
  kubernetes_sd_configs:
  - <config>

  #配置relabel
  <relabel_config>:
  - <config>
```

#### 2.k8s服务发现
从k8s的apiserver中发现targets

##### （1）能够发现5种类型的targets
* node
* service
* pod
* endpoints
* ingress

##### （2）基本配置
```yaml
kubernetes_sd_configs:
- role: <ROLE>

  #不设置的话，默认prometheus是跑在k8s中，会自动发现apiserver
  api_server: <HOST>

  #认证（指定token，下面两种方式是互斥的）
  bearer_token_file: <FILE_PATH>
  bearer_token: <TOKEN>

  #tls配置
  tls_config: <TLS_CONFIG>

  #指定命名空间（即在指定的命名空间中进行服务发现），默认是全部命名空间
  namespaces:
    names:
    - <NAMESPACE>

  #对 发现的范围 进行限制
  #通过label selector和filed selector进行过滤，从而限制范围
  #endpoints支持的role：pod,service,endpoints
  #其他role支持其本身
  selector:
    - role: <ROLE>
      <LABLE_OR_FIELD>: <VALUE>

```

#### 3.relabel
在采集之前，动态重写target的标签

##### （1）5种action
* replace
  * 用`regex`匹配`source_labels`用`separator`连接起来的标签值
    * 如果没有匹配到，不会发生替换
    * 如果匹配到，添加`target_label`这个标签，且值为`replacement`
* keep
  * 用`regex`匹配`source_labels`用`separator`连
    * 如果匹配到了，则保留该target
    * 没有匹配到的都丢弃
* drop
  * 用`regex`匹配`source_labels`用`separator`连
    * 如果匹配到了，则丢弃该target
    * 没有匹配到的都保留
* labelmap
  * `regex`去匹配Target实例所有标签的名称
    * 将捕获到的内容作为为新的标签名称
    * 匹配到标签的的值作为新标签的值
    比如：
    ```yaml
    - action: labelmap
      regex: __meta_kubernetes_node_label_(.+)
    #原标签为： __meta_kubernetes_node_label_test=tttt
    #则目标标签为： test=tttt
    ```
* labeldrop
  * 如果匹配到了，则丢弃相应的`source_labels`
* labelkeep
  * 如果匹配到了，则保留相应的`source_labels`

##### （2）基本格式
```yaml
relabel_configs:

  #如果source_labels未设置，而action是replace，则表达添加一个新标签
- source_labels: [<LABEL_NAME>, <LABEL_NAME>,...]

  #设置分隔符
  #当source_labels有多个label时，用该分隔符将label的值进行拼接
  #默认为分号：';'
  separator: <STRING>

  #如果进行replcace，则新的标签名为这里设置的
  target_label: <NEW_LABEL_NAME>

  #用正则表达式匹配标签的值
  #默认为：（.*）
  regex: <regex>

  #如果进行replace，则新的标签的值为下面内容
  #默认为 $1，即正则中第一个括号匹配到的内容
  replacement: <STRING>

  action: <ACTION>
```

***

### 告警配置
```yaml
alerting:
  alert_relabel_configs:
  - <relabel_config>
  alertmanagers:
  - <alertmanager_config>
```
