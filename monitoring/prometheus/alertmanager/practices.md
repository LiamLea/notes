# 实践

[toc]

### 概述

#### 1.flapping alerts（拍打告警）
在恢复和告警两个状态之前频繁切换

#### 2.解决flapping alerts
* 使用for语句（当告警持续一段时间后，才会发送告警通知）
* 在alert rule中，更好的聚合数据

##### 3.对alerts进行分组的建议
* 应该将可能会有关联的alerts分成一组
  * 比如：按系统进行分组，同一个系统中比如某一个机器故障，可能会导致多个告警产生
  * 如果把没有关联的分成一组，也就失去了分组的意义

***

### 常用告警设置

[参考](https://awesome-prometheus-alerts.grep.to/rules.html)
