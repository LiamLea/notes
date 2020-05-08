# pod
[toc]
### 基础概念
#### 1.pod phase（生命周期）
pod的生命周期只有以下几种情况
|阶段|说明|
|-|-|
|Pending|一个或多个容器未被创建（比如：未拉取完镜像、pod未调度完成|
|Running|所有容器都被创建，至少有一个容器正在运行|
|Succeed|所有容器都正常终止了，并且不会再启动|
|Failed|所有容器都终止了，至少有一个是失败的终止（即退出码不为0）|
|UnKown|当无法与该Pod通信时|

#### 2.pod conditions（pod的状态）





1.pod的生命周期
（1）状态：
  Pendind                //调度上未完成
  Running
  Failed
  Succeed
  Unkown               //kubelet出故障可能导致这个问题
（2）创建自主式pod
  请求 -> apiserver（将请求的目标状态保存在etcd） -> scheduler（将调度结果更新到在etcd中） -> apiserver -> 指定node的kubelet（获取任务清单）-> 创建资源 -> apiserver（成功后）-> etcd更新信息
（3）Pod生命周期中的重要行为
  初始化容器
  postStart（容器启动后立即执行的操作，注意：操作是在容器的启动命令后进行的）
  容器探测：
    liveness         //用于探测容器是否存活，当发现不存活，会根据restartPolicy判断是否重启该pod
    readiness      	//用于探测容器能否提供相应服务
  preStop（容器接收到terminated信号后，立即执行的操作，这个期间有个缓冲的时间，不是立即结束的）

2.livenessProbe和readinessProbe有三种探针
  exec
  httpGet
  tcpSocket

3.lifecycle.postStart和lifecycle.preStop，有三种操作
  exec
  httpGet                  //用于请求某种资源
  tcpSocket               //发起一些tcp请求
