# CVSS

[toc]

### 概述

[参考](https://www.first.org/cvss/specification-document)

#### 1.CVSS（common vulnerability scoring system）
安全评价的一种标准，有三个版本（v1，v2，v3）

#### 2.安全评价三个group

##### （1）base metric group
基础的指标，分两类指标

* exploitability metrics
反应漏洞被利用的 技术手段 和 难易程度

|metric|description|metric value|
|-|-|-|
|Attack Vector (AV)|攻击的方式|Network（需要通过网络实施攻击，比如DDOS）</br>Adjacent（需要在指定的网络条件下实施攻击，比如在同一个网段）</br>Loacl（需要通过本地实施攻击，比如本地读写文件）</br>Physical（需要操作物理机才能实施攻击）|
|Attack Complexity (AC)|攻击的条件|Low（需要特殊的条件）</br>High（需要特殊的条件，比如需要获取机器的 更多信息|
|Privileges Required (PR)|需要的权限|None（不需要认证）</br>Low（需要较低权限）</br>High（需要较高权限）|
|User Interaction (UI)|是否需要用户相关操作才能完成攻击|None</br>Required|
|Scope (S，这个分数较高)|安全范围|Unchanged（不会影响其他安全范围）</br>Changed（会影响其他安全范围）</br>当一个应用连接某一个数据库，则该应用和数据库属于一个安全范围，两个相关没有交互的应用属于不同的安全范围|

* impact metrics
反应漏洞被成功利用的直接后果

|metric|description|metric value|
|-|-|-|
|Confidentiality (C)|信息泄露（比如数据库里存储的信息）|None（不会信息泄露）</br>Low（部分信息会泄露）</br>High（所有信息会泄露）|
|Integrity (I)|信息的可信性和真实性|None</br>Low（部分数据能被修改，或修改后造成的影响有限）</br>High（重要数据能被修改，影响较大）|
|Availability (A)|对组件可用性对的影响|None</br>Low（性能受到影响，可能有中断的情况）</br>High（服务不可用）|

##### （2）temporal metric group
反应漏洞会随时间而变化的特征

##### （3）environmental metric group
反应漏洞存在于某一特定用户环境的特征（比如：需要特定配置，才能完成攻击）
