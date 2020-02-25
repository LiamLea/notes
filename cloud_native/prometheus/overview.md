# 基础知识
### 1.prometheus特点
* 所有查询基于**数学公式**
* 采用HTTP协议 pull/push两种采集方式
### 2.架构图
![architecture](./imgs/overview_1.png)
### 3.组件
（1）exporter
>客户端程序，用于pull模式
>以http-server的方式运行在后台

（2）pushgateway
>客户端程序，用于push模式
>用于设置自定义监控项
>工作原理：
```mermaid
graph LR
A[自定义脚本]-->|push采集到的数据|B[pushgateway]
B-->|push|C[prometheus]
```
### 4.基本概念
（1）metric
>metric就是一个指标

（2）数据存储格式
> **METRIC{LABEL="VALUE",...}**
>比如：node_cpu_seconds_total{cpu="9",instance="3.1.4.232:9100",job="kubernetes-nodes",mode="idle"}
### 5.metrics的类型
（1）gauge
>瞬时状态，只有一个简单的返回值

（2）counter
>计数器

（3）histogram
>统计数据的分布情况
***
# 基本使用
### 1.配置文件
```yaml
global:
  scrap_internal: 15s           #采集间隔
  evaluation_internal: 15s      #监控规则评估的间隔，看是否达到告警要求

#配置告警发往哪里
alerting:
  alertmanagers:
   - static_configs:
      - targets: ["IP:PORT"]

#配置数据源（即从哪里pull数据）
scrap_config:
- job_name: xx                #数据源的名称
  staic_configs:
  - targets: ["IP:PORT"]      #exporter的地址，可以有多个
```
### 2.通过url获取exporter数据
http://IP:PORT/metrics

获取的数据如下：
```
# HELP node_sockstat_UDP_mem_bytes Number of UDP sockets in state mem_bytes.
# TYPE node_sockstat_UDP_mem_bytes gauge
node_sockstat_UDP_mem_bytes 12288
```

### 3.常用公式
* 过滤
> METRIC{KEY=VALUE}
>>比如：node_cpu_seconds_total{mode="idle"}
>>得到cpu处于idle的总时间
* increate(METRIC[TIME])
> last值-first值
>>比如：increase(node_cpu_seconds_total{mode="idle"}[1m])
>>得到每个cpu每1分钟，cpu处于idle增长的时间
* sum(METRIC)
>把输出的结果集进行加和（因为可能有多个instance的数据）
>>比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))
>>得到所有服务器的所有cpu每1分钟，cpu处于idle增长的时间
* 按标签分类
>by(LABEL)
比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))by(instance)
>>得到每台服务器的所有cpu每1分钟，cpu处于dle增长的时间
* rate(METRIC[TIME])
>(last值-first值)/时间差s
配合counter类型数据使用
* topk(N,METRIC)
>选出该指标项的前N个较大值
* count(EXPRESSION)
