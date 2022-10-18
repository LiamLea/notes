# alerting

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [alerting](#alerting)
    - [概述](#概述)
      - [1.告警架构](#1告警架构)
      - [2.相关特性](#2相关特性)
        - [（1）分组（group）](#1分组group)
        - [（2）抑制（inhibit）](#2抑制inhibit)
        - [（3）静默（silence）](#3静默silence)
        - [（4）路由（route）](#4路由route)
      - [3.告警规则的状态](#3告警规则的状态)

<!-- /code_chunk_output -->

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

##### （1）分组（group）
* 对告警进行分组（利用标签）
  * 在一定的时间间隔内，产生了多个属于同一组的告警，则只发送一次消息，然后消息里面包含这些告警的详细信息（避免发送多次）
  * 没有设置分组时，未分组的属于一组
* 当产生告警后，告警会加入相应的grouop中，然后告警的状态一直会存在该group中，当该group中所有告警的状态都变为reloved，才会清空该group中所有告警
  * 没有清空时，只要发送一次该group中告警的状态，就会包含reloved的状态的告警

##### （2）抑制（inhibit）
* 指当某一告警发出后，可以停止重复发送由此告警引发的其它告警的机制
* 在配置文件中配置抑制的规则

##### （3）静默（silence）
* 可以快速根据标签对告警进行静默处理
* 静默设置需要在Alertmanager的Werb页面上进行设置

##### （4）路由（route）
* 利用标签匹配告警，从而决定告警发往何处
  * 比如标签为`severity: 1`的，发往定义好的一个receiver
  * 比如标签为`severity: 2`的，发往定义的另一个receiver
* 在配置文件中配置route的规则

#### 3.告警规则的状态
* active
表示告警规则被触发的次数
* firing
表示告警规则被触发，并成功发送到alertmanager
* pending
表示告警规则被触发，未发送
