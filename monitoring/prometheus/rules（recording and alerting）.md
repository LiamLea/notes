# rules

[toc]

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
groups:
  - name: <group_name>
    rules:
    - <rule>
```

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

#评估等待时长，只有当触发条件持续一段时间后才发送告警
for: <duration | default = 0s>

#添加或覆盖之前的标签（标签很重要，用于对告警进行分类）
labels:
  <LABEL>: <VALUE>

#注释信息
annotations:
  <LABEL>: <VALUE>
```
