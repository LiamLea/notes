#overview
[toc]
### 基础知识
#### 1.prometheus特点
* 所有查询基于**数学公式**
* 采用HTTP协议 pull/push两种采集方式
#### 2.架构图
![architecture](./imgs/overview_1.png)
#### 3.组件
* exporter
  * 客户端程序，用于pull模式
  * 以http-server的方式运行在后台
</br>
* pushgateway
  * 客户端程序，用于push模式
  * 用于设置自定义监控项
  * 工作原理：
  ```mermaid
  graph LR
  A[自定义脚本]-->|push采集到的数据|B[pushgateway]
  B-->|push|C[prometheus]
  ```
#### 4.相关名词
##### （1）metric
* 一个metric是一个**特征**（比如：1分钟负载、内存使用量等等）

##### （2）label
* 标识不同**维度**的metric
* 比如：
  * 一分钟负载，可以利用label标识这个metric来自哪个实例

##### （3）时间序列（相当于监控项）
* 由metric和label组成（具有**唯一**性）：`METRIC{<LABEL>="<VALUE>",...}`
* 比如：
  * `node_cpu_seconds_total{cpu="9",instance="3.1.4.232:9100",job="kubernetes-nodes",mode="idle"}`

##### （4）instance
* 能够抓取数据的endpoint
##### （5）job
* 具有相同目的的insance的集合
* 举例：
  * job: api-server
    * instance 1: 1.2.3.4:5670
    * instance 2: 1.2.3.4:5671
    * instance 3: 5.6.7.8:5670
    * instance 4: 5.6.7.8:5671
##### （6）target（重要）
* targets指采集目标，一个target就相当于一个endpoint

#### 5.标签（label）
##### （1）内部标签
* 以`__`开头的label供内部使用，不会出现在最终的时间序列中
  * 以`__meta`开头的是元标签（meta label）

##### （2）抓取时自动生成的标签
* job
target所属的job（即在配置文件中配置的`job_name`）
</br>
* instance
target的`<ip>:<port>`


#### 6.metrics的主要类型
* gauge
瞬时状态，只有一个简单的返回值

* counter
计数器

* histogram
统计数据的分布情况

#### 7.两类rule
* recording rule
  * 允许预先计算经常需要或计算上昂贵的表达式，并将其结果保存为一组新的时间序列
  * 因此，查询预先计算的结果通常比每次需要时执行原始表达式快得多
* alert rule
  * 告警规则
***
### 基本使用
#### 1.通过url获取exporter数据
http://IP:PORT/metrics

获取的数据如下：
```
# HELP node_sockstat_UDP_mem_bytes Number of UDP sockets in state mem_bytes.
# TYPE node_sockstat_UDP_mem_bytes gauge
node_sockstat_UDP_mem_bytes 12288
```

#### 2.常用公式
* 过滤
```shell
METRIC{KEY=VALUE}
#比如：node_cpu_seconds_total{mode="idle"}
#得到cpu处于idle的总时间
```
* `increate(METRIC[TIME])`
```shell
last值-first值
#比如：increase(node_cpu_seconds_total{mode="idle"}[1m])
#得到每个cpu每1分钟，cpu处于idle增长的时间
```
* `sum(METRIC)`
```shell
#把输出的结果集进行加和（因为可能有多个instance的数据）
#比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))
#得到所有服务器的所有cpu每1分钟，cpu处于idle增长的时间
```
* 按标签分类
```shell
by(LABEL)
#比如：sum(increase(node_cpu_seconds_total{mode="idle"}[1m]))by(instance)
#得到每台服务器的所有cpu每1分钟，cpu处于dle增长的时间
```
* `rate(METRIC[TIME])`
```shell
(last值-first值)/时间差s
#配合counter类型数据使用
```
* `topk(N,METRIC)`
选出该指标项的前N个较大值
</br>
* `count(EXPRESSION)`
