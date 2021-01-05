# alerting
[toc]
### 概述
#### 1.告警架构
![](./imgs/alertmanager_overview_01.png)
分为两个部分：
* 告警规则在prometheus server中配置
* 触发的告警被发往alertmanager，alertmanager负责管理告警
  * 分组（grouping）
  * 抑制（inhibition）
  * 静默（silencing）
  * 通过邮件等发送告警

Prometheus会周期性的对告警规则进行计算，如果满足告警触发条件就会向Alertmanager发送告警信息。

#### 2.相关特性
![](./imgs/alertmanager_overview_02.png)

##### （1）分组（grouping）
将有相似性质的告警，分成一组，只发送单个通知

##### （2）抑制（inhibition）
指当某一告警发出后，可以停止重复发送由此告警引发的其它告警的机制

##### （3）静默（silencing）
* 可以快速根据标签对告警进行静默处理
* 静默设置需要在Alertmanager的Werb页面上进行设置

##### （4）路由（Route）

#### 3.告警规则的状态
* active
表示告警规则被触发的次数
* firing
表示告警规则被触发，并成功发送到alertmanager
* pending
表示告警规则被触发，但是正处于评估等待时长
