# fault management

[toc]

### 概述

#### 1.告警的影响范围
```shell
$ fm alarm-list --mgmt_affecting --degrade_affecting

+-------+--------------------------------------------------------------------+--------------------------------------+----------+----------------------+-------------------+-------------------+
| Alarm | Reason Text                                                        | Entity ID                            | Severity | Management Affecting | Degrade Affecting | Time Stamp        |
| ID    |                                                                    |                                      |          |                      |                   |                   |
+-------+--------------------------------------------------------------------+--------------------------------------+----------+----------------------+-------------------+-------------------+
| 400.  | Service group controller-services failure; drbd-cephmon(disabled,  | service_domain=controller.           | critical | True                 | True              | 2021-11-03T09:46: |
| 001   | failed), drbd-etcd(enabled-go-standby, degraded, data-             | service_group=controller-services.   |          |                      |                   | 12.217386         |
|       | inconsistent), drbd-dc-vault(disabled, failed)                     | host=controller-1                    |          |                      |                   |                   |
|       |                                                                    |                                      |          |                      |                   |                   |
| 400.  | Service group storage-services loss of redundancy; expected 2      | service_domain=controller.           | major    | True                 | False             | 2021-11-03T09:42: |
| 002   | active members but only 1 active member available                  | service_group=storage-services       |          |                      |                   | 55.605646         |

```

##### （1）Management Affecting
当告警的Management Affecting为True时，表示该告警会影响管理（即patch和升级操作）

##### （2）Degrade Affecting
当告警的Degrade Affecting为True时，表示该告警会影响降级
当此类告警的级别达到**critical**时，主机会立即被**降级（degraded）**
主机被降级后，**activity会转移**
当另一台主机有相同的告警，则activity不会转移到该主机
注意：主机可能已经被降级了，但`system host-list`查看状态不是degraded

***

### 使用

#### 1.查看

* 查看故障告警
```shell
fm alarm-list --mgmt_affecting --degrade_affecting --uuid
fm alarm-show <uuid>
```

* 查看历史故障告警和历史历史

```shell
#或者直接查看：/var/log/fm-event.log
fm event-list --alarm
fm event-list --log
```

***

### 常见错误

#### 1.为什么drbd同步失败，activity会不断转移

因为当controller-0为active controller时，进行drbd同步，结果同步失败，产生告警，则controller-0被降级
则activity切换到controller-1，然后在controller-1上进行drbd同步，结果同步失败，产生告警，则controller-1被降级，但是由于controller-0上同样的告警还存在，所以activity还未切换，
controller-0变为standby，则相关服务就会disabeld或者变为standby，则controller-0上的告警就会消失，
此时activity就会切换到controller-0
