# host management

[toc]

### 概述

#### 1.host的生命周期
![](./imgs/host_mgmt_01.png)

##### （1）oprational state（操作状态）

|oprational state|description|
|-|-|
|enabled|表示这个主机提供了期望的服务，即使可能有些故障|
|disabled|表示该主机没有提供期望的服务（unlock失败时可能出现这个状态）|

##### （2）administrative state（管理状态）

|administrative state|description|
|-|-|
|locked|表示该机器暂停提供使用|
|unlocked|与locked相反|

##### （3）availability states（可用状态）

|availability state|description|affecting|
|-|-|-|
|offline|无法连接该主机|
|online|能够连接该主机（但还没有unlock）|
|InTest|主机正在执行硬件和软件完整校验|
|available|主机完全正常，并提供服务|
|degraded|主机有些故障，但是仍能提供期望的服务|当从available切换到degraded，会转移activity（即active instances，如果是active controller，另一个controller会变为active）|
|failed|主机不能提供服务|

#### 2.available、degraded、failed之间的状态切换
会根据oprational state的状态变化和faults，进行切换
  * staringx维护系统，会监控所有的主机，通过心跳包检测网络接口、平台资源（cpu等）、平台关键服务、硬件服务等，从而能够及时发现故障

***

### 使用

####
