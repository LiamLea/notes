# alerting
[toc]
### 概述
#### 1.告警架构
分为两个部分：
* 告警规则在prometheus server中配置
* 触发的告警被发往alertmanager，alertmanager负责管理告警
  * 聚合（aggregation）
  * 抑制（inhibition）
  * 静默（silencing）
  * 通过邮件等发送告警

#### 2.相关概念
##### （1）聚合（aggregation）
当有多个类似的告警时，只发送一个告警通知

##### （2）抑制（inhibition）
比如：当集群无法访问了，这时就可以抑制与集群有关的告警

##### （3）静默（silencing）
如果告警符合相关要求，则不发送任何通知
