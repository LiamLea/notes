# performance

[toc]

### 概述

#### 1.两个因素
* latency
  * 由于需要一致性，所以影响提交的性能因素：
    * network IO latency
    * disk IO latency
* throughput

#### 2.参数

|参数|说明|合理的值|
|-|-|-|
|network_peer_round_trip_time_seconds|网络IO延迟，因为使用raft协议，需要写入前需要互相确认|100ms左右|
|disk_wal_fsync_duration_seconds|在执行wal之前，需要先将wal从内存flush到磁盘|p99 < 10ms|
|disk_backend_commit_duration_seconds|将增量快照提交到磁盘|p99 < 25ms|

#### 3.调优

##### （1）调整`heartbeat-interval`和`election-timeout`
能够避免etcd的**leader频繁切换**，频繁的切换会导致etcd client会读写超时
* heartbeat interval（默认：`100ms`）
  * leader向follower发送心跳包的时间间隔
    * leader在发送心跳包之前需要persist the metadata to disk
  * 如果leader连续两个周期未发送heartbeat，则会发出警告: it failed to send a heartbeat on time
* election timeout
  * 当在这么长时间内没有收到心跳包，则开始选举leader
  * 合理的值：`10 * heartbeat_interval`
