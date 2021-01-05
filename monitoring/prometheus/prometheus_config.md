[toc]

### 概述

#### 1.有四个部分

##### （1）全局配置：`global`

##### （2） 加载rule文件：`rule_files`
* 配置recording规则
* 配置alerting规则（告警规则）

##### （3）采集配置：`scrape_configs`

##### （4）告警发往何处的配置：`alerting`
* 当达到alerting规则，会触发告警
* 然后会将告警发往 告警指定url（可以是alertmanager，也可以是其他任何地址）

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

  metrics_path: <URL_PATH>   #本质生成__metrics_path__元标签
                             #在这里配置优先级最低
                             #如果没有__metrics_path__元标签，默认为 /metrics

  #用于解决server端的label和exporter端用户自定义label冲突的问题
  #默认为false，保留用户自定义的label
  honor_labels: <BOOLEAN>

  #时间序列中的时间 是否使用采集到的数据中的时间
  #默认为true，即使用采集到的数据中的时间
  honor_timestamps: <BOOLEAN>

  #设置用于请求的协议，只有两种：http 和 https
  schema: <PROTOCOL>

  #配置k8s服务发现，动态发现targets
  kubernetes_sd_configs:
  - <config>

  #配置静态targets
  static_configs:
  - targets:
    - <IP>:<PORT>                   #本质生成__address__元标签
    labels:
      <labelname1>:<label1value>
      <labelname2>:<label2value>

  #配置relabel
  <relabel_config>:
  - <config>
```

#### 2.k8s服务发现

##### （1）概述
* 从k8s的apiserver中发现targets
</br>
* 注意：在自动发现中，根据label、annotation等生成的target的标签，特殊符号都会用`_`替换，
  * 比如：
    * 发现的一个service含有标签`prometheus.io/name: "nginx.local"`，
    * 则生成的target的标签为`__meta_kubernetes_service_label_prometheus_io_name: "nginx.local"`
</br>
* 能够发现5种role的targets
  * node
  * service
  * pod
  * endpoints
  * ingress

#####  （2）通过Node发现targets

* 发现原理
  * 每个node都会发现一个target
  * `target地址：该node第一个存在的地址（按照地址类型依次发现，一般都是NodeInternalIP）`
  * `target端口：该node上的kubelet的http端口`
</br>
* 元标签（meta labels）
```yaml
__meta_kubernetes_node_name: "node的名称"
__meta_kubernetes_node_label_<labelname>: "标签的值"
__meta_kubernetes_node_labelpresent_<labelname>: "true" #这个node对象上存在的标签都为true，有些标签可能是采集时添加的，不存在node对象上
__meta_kubernetes_node_annotation_<annotationname>: "注释的值"
__meta_kubernetes_node_annotationpresent_<annotationname>: "true"
__meta_kubernetes_node_address_<address_type>: "地址" #address_type为：NodeInternalIP, NodeExternalIP, NodeLegacyHostIP, and NodeHostName
```

##### （3）通过Service发现targets

* 发现原理
  * 每个service的每个pod发现一个target
  * `target地址：service的DNS名称`
  * `target端口：service的端口`
</br>
* 元标签（meta label）
```yaml
__meta_kubernetes_namespace: "service所在命名空间"
__meta_kubernetes_service_label_<labelname>: "标签的值"
__meta_kubernetes_service_labelpresent_<labelname>: "true" #这个service对象上存在的标签都为true，有些标签可能是采集时添加的，不存在service对象上
__meta_kubernetes_service_annotation_<annotationname>: "注释的值"
__meta_kubernetes_service_annotationpresent_<annotationname>: "true"

__meta_kubernetes_service_name: "service name"
__meta_kubernetes_service_type: "service的类型"
__meta_kubernetes_service_cluster_ip: "cluster ip"
__meta_kubernetes_service_port_name: "port name"
__meta_kubernetes_service_port_protocol: "protocol"
```

##### （4）通过Pod发现targets

* 发现原理
  * 每个pod 中的 每个容器 声明的 每个端口，发现一个target
  * `target地址：pod的ip地址`
  * `target端口：容器声明的端口`
</br>
* 元标签（meta label）
```yaml
__meta_kubernetes_namespace: "pod所在命名空间"
__meta_kubernetes_pod_label_<labelname>: "标签的值"
__meta_kubernetes_pod_labelpresent_<labelname>: "true" #这个pod对象上存在的标签都为true，有些标签可能是采集时添加的，不存在pod对象上
__meta_kubernetes_pod_annotation_<annotationname>: "注释的值"
__meta_kubernetes_pod_annotationpresent_<annotationname>: "true"

__meta_kubernetes_pod_name: "pod name"
__meta_kubernetes_pod_ip: "pod ip"

__meta_kubernetes_pod_container_init: "true" #如果该容器是init容器
__meta_kubernetes_pod_container_name: "容器名"
__meta_kubernetes_pod_container_port_name: "容器端口名"
__meta_kubernetes_pod_container_port_number: "容器端口号"
__meta_kubernetes_pod_container_port_protocol: "容器端口协议"

__meta_kubernetes_pod_ready: "true or false"
__meta_kubernetes_pod_phase: "pod处于的阶段：Pending、Running、Succeeded 、Failed、Unkown"

__meta_kubernetes_pod_node_name: "pod所在节点名称"
__meta_kubernetes_pod_host_ip: "pod所在节点ip"
__meta_kubernetes_pod_uid: "pod uid"
__meta_kubernetes_pod_controller_kind: "控制器类型"
__meta_kubernetes_pod_controller_name: "控制器名称"
```

##### （5）通过Endpoints发现targets

* 发现原理
  * 每个endpoint，发现一个target
  * `target地址: endpoint地址`
  * `target端口：endpoint端口`
</br>
* 元标签（meta label）
```yaml
__meta_kubernetes_namespace: "endpoints对象所在命名空间"
__meta_kubernetes_endpoints_name: "endpoints对象的名称"

__meta_kubernetes_endpoint_port_name: "endpoint的端口名"
__meta_kubernetes_endpoint_port_protocol: "endpoint的端口协议"

#以下标签不一定存在
__meta_kubernetes_endpoint_hostname: "endpoint的主机名"
__meta_kubernetes_endpoint_node_name: "托管这个endpoint的node的名称"
__meta_kubernetes_endpoint_ready: "true or false"
__meta_kubernetes_endpoint_address_target_kind: "目标地址的类型，可能是pod、service，如果endpoint指向一个外部地址，就无法识别出target的类型了"
__meta_kubernetes_endpoint_address_target_name: "目标地址的名称，如果指向的是一个pod，则这里就是pod的名称"

#如果endpoint属于某一个service，则会包含service的所有元标签

#如果endpoint指向一个pod，则会包含该pod的所有元标签
```

##### （6）通过Ingress发现targets

* 发现原理
  * 每个path，发现一个target
  * `target地址：ingress中配置的service名称`
  * `target端口：ingress中配置的service端口`
</br>
* 元标签（meta label）
```yaml
__meta_kubernetes_namespace: "ingress对象所在命名空间"
__meta_kubernetes_ingress_label_<labelname>: "标签的值"
__meta_kubernetes_ingress_labelpresent_<labelname>: "true" #这个ingress对象上存在的标签都为true，有些标签可能是采集时添加的，不存在ingress对象上
__meta_kubernetes_ingress_annotation_<annotationname>: "注释的值"
__meta_kubernetes_ingress_annotationpresent_<annotationname>: "true"

__meta_kubernetes_ingress_name: "ingress name"
__meta_kubernetes_ingress_scheme: "http or https"
__meta_kubernetes_ingress_path: "设置的path"
```

##### （7）基本配置
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

  #对 发现的范围 进行限制（不常用，用relabel就行）
  #通过label selector和filed selector进行过滤，从而限制范围
  #endpoints支持的role：pod,service,endpoints
  #其他role支持其本身
  selector:
    - role: <ROLE>
      <LABLE_OR_FIELD>: <VALUE>
```

#### 3.relabel（重新标记，prometheus非常重要的功能）

##### （1）主要功能
在数据被采集之前，**动态**实现以下功能：
* **过滤**target（只选择一些target采集）
* **重写**target的标签
* **配置**target（比如配置target的metrics path）

##### （2）元标签对配置的影响（很重要）
* 配置**target的endpoint**（并且生成`instance`标签）
  * 通过`__address__`元标签的内容配置target的endpoint
  * 如果在重新标记期间未设置instance标签，由`__address__`元标签的内容填充
</br>
* 配置**schema**（这里不是标签，而是target的配置，下面的同理）
  * 通过`__schema__`元标签
</br>
* 配置**metrics path**
  * 通过`__metrics_path__`元标签
</br>
* 配置访问target url时 传递的参数
  * `__param_<name>`，访问第一个url时，就会传递参数`<name>`，参数值为`__param_<name>`标签的内容
</br>
* 重新标记后，会清除`__`开头的所有标签


##### （3）5种action
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

##### （4）基本格式
```yaml
relabel_configs:

  #如果source_labels未设置，而action是replace，则表达添加一个新标签
- source_labels: [<LABEL_NAME>, <LABEL_NAME>,...]

  #设置分隔符
  #当source_labels有多个label时，用该分隔符将label的值进行拼接
  #默认为分号：';'
  separator: <STRING | default = ;>

  #如果进行replcace，则新的标签名为这里设置的
  target_label: <NEW_LABEL_NAME>

  #用正则表达式匹配标签的值
  #默认为：（.*）
  regex: <regex | default = (.*) >

  #如果进行replace，则新的标签的值为下面内容
  #默认为 $1，即正则中第一个括号匹配到的内容
  replacement: <STRING | default = $1>

  action: <ACTION | default = replace>
```

***

### 告警配置

#### 1.概述
```yaml
alerting:
  alert_relabel_configs:
  - <relabel_config>

  #指定将告警发往哪个url，可以是alertmanager，也可以是任何地址
  alertmanagers:
  - <alertmanager_config>   
```

#### 2.配置告警发往的地址

##### （1）基本配置
一般不用设置，用默认的就行
```yaml
timeout: <duration | default=10s>
api_version: <string | default=v1>
path_prefix: <PATH | default=/>
scheme: <scheme | default=http>
#更多配置参考文档
```

##### （2）静态地址
```yaml
static_configs:
  - targets:
    - <IP>:<PORT>           #本质生成__alerts_path__元标签
    labels:
      <labelname1>: <label1value>
      <lablename2>: <label2value>
```

##### （3）动态地址（自动发现）
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

relabel_configs: <relabel_configs>
```
