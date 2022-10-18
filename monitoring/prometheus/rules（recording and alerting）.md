# rules

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [rules](#rules)
    - [概述](#概述)
      - [1.两类rules](#1两类rules)
        - [（1）recording rules](#1recording-rules)
        - [（2）alerting rules](#2alerting-rules)
      - [2.基本格式](#2基本格式)
      - [2.rules评估的时间间隔](#2rules评估的时间间隔)
    - [recoding rule](#recoding-rule)
      - [1.recording rule的格式](#1recording-rule的格式)
    - [alerting rule（告警规则）](#alerting-rule告警规则)
      - [1.alerting rule的格式](#1alerting-rule的格式)

<!-- /code_chunk_output -->

### 概述

#### 1.两类rules

##### （1）recording rules
* 预先计算经常需要或计算量大的表达式，并将其结果保存为一组新的时间序列
* 查询预先计算的结果通常比每次需要原始表达式都要快得多，对dashboard很有用

##### （2）alerting rules
* 告警规则

#### 2.基本格式
```yaml
#规则按组进行管理
#同一个group中的规则顺序处理，不同group并行处理
groups:
  - name: <group_name>
    rules:
    - <rule>
```

#### 2.rules评估的时间间隔
在prometheus_config的全局配置中设置

***

### recoding rule

#### 1.recording rule的格式
```yaml
#新的时间序列的名称
record: <NAME>

#PromQL语句，用于生成新的时间序列
expr: <PromQL>

#添加或覆盖之前的标签
labels:
  <LABEL>: <VALUE>
```

***

### alerting rule（告警规则）

#### 1.alerting rule的格式
```yaml
#该告警规则的名称
alert: <NAME>

#触发告警的表达式
expr: <PromQL>

#等待时长
#在等待时间内，则alert处于active状态，
#在等待时间内，如果这个告警恢复了，则alert处于pending状态（即未发送状态）
for: <duration | default = 0s>


#label和annotations可以使用的变量：
#   {{ $labels.<labelname> }}
#   {{ $value }}      表达式计算出来的值

#添加或覆盖之前的标签（标签很重要，用于对告警进行分类）
labels:
  <LABEL>: <VALUE>

#注释信息
annotations:
  <LABEL>: <VALUE>
#常用annotations:
#   description: "描述信息"
#   summary: "概述信息"
#   value: '{{ $value }}'
```
