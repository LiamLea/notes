# blackbox_exporter
[toc]

### 概述

#### 1.支持的prober（即协议）
可以利用下面的协议，对endpoint进行探测
* http
* https
* dns
* tcp
* icmp

***

### 使用

#### 1.配置blackbox
配置module，可以配置其他参数，比如http使用的method、超时时间、响应码等等
[参考](https://github.com/prometheus/blackbox_exporter/blob/master/example.yml)

* 默认配置

```yaml
modules:
  http_2xx:
    prober: http
  http_post_2xx:
    prober: http
    http:
      method: POST
  tcp_connect:
    prober: tcp
  pop3s_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^+OK"
      tls: true
      tls_config:
        insecure_skip_verify: false
  ssh_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^SSH-2.0-"
      - send: "SSH-2.0-blackbox-ssh-check"
  irc_banner:
    prober: tcp
    tcp:
      query_response:
      - send: "NICK prober"
      - send: "USER prober prober prober :prober"
      - expect: "PING :([^ ]+)"
        send: "PONG ${1}"
      - expect: "^:[^ ]+ 001"
  icmp:
    prober: icmp
```

#### 2.通过url测试
```shell
http://<ip>:port/probe?target=<endpoint>&module=<module>
#更多参数
# debug=true    能够获取更详细的信息
```

#### 3.prometheus配置
```yaml
scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  #指定使用的模块，只能使用一个，指定多个，只有第一个生效
    static_configs:
      #设置要探测的endpoint
      - targets:
        - http://prometheus.io
        - https://prometheus.io
        - http://example.com:8080
    relabel_configs:
      - source_labels: [__address__]  #将__address__标签的内容赋值给__param_target标签，因为这里的__address__是需要探测的地址，不是blackbox的地址
        target_label: __param_target
      - source_labels: [__param_target] #将__param_target标签的内容赋值给instance标签，便于用户识别
        target_label: instance
      - target_label: __address__    #将blackbox地址赋值给__address__，这样才能访问blackbox获取相应的数据
        replacement: 127.0.0.1:9115  
```
