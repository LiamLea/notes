# troubleshoot

[toc]

#### 1.leader经常切换，导致相关服务连接etcd超时

##### （1）分析
* 心跳包发送超时，报错信息如下
  * wal同步超时，一般都是磁盘的问题（读写太慢）
```shell
wal: sync duration of 1.363283431s, expected less than 1s
etcdserver: failed to send out heartbeat on time (exceeded the 100ms timeout for 1.220602923s, to d35e062b0036cc3a)
etcdserver: server is likely overloaded
```

##### （2）解决
调整`heartbeat-interval`和`election-timeout`（具体查看`performance.md`）

#### 2.`etcd took too long to execute`

##### （1）分析
* wal sync和backend commit时间太长，这是个警告不是报错
  * 磁盘延迟太高
