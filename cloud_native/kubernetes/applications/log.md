# log

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [log](#log)
    - [概述](#概述)
      - [1.容器日志的存放位置](#1容器日志的存放位置)
      - [2.k8s三种日志架构方式](#2k8s三种日志架构方式)
        - [（1）基本方式](#1基本方式)
        - [（2）node-level](#2node-level)
        - [（3）cluster-level](#3cluster-level)

<!-- /code_chunk_output -->

**kubernetes中的应用的日志 都是 docker 管理的**
### 概述
#### 1.容器日志的存放位置
* 在docker中存放的位置
存放**实际的日志文件**
```shell
/var/lib/docker/containers/<container_id>/
```

* 在k8s中存放的位置
该目录下存放的是**链接文件**，**指向实际的日志文件**
```shell
/var/log/pods/<namespace>_<pod_name>_<pod_id>/<container_name>/
```

* k8s提供获取日志的方便方式
该目录下存放的是**链接文件**，**指向上面所说的链接文件**
```shell
/var/log/containers/<pod_name>_<namespace>_<container_name>_<container_id>.log
```
**注意：如果某个pod没有运行在该机器上，则相应目录下没有日志**
#### 2.k8s三种日志架构方式
##### （1）基本方式
```shell
kubectl logs ...
```
##### （2）node-level
![](./imgs/log_01.png)
* logrotate由容器的log-driver来做，k8s不进行logrotate
* `kubectl logs`只查看一个文件的日志，不会查看其他切割的文件

##### （3）cluster-level
k8s没有原生的集群层面的日志的解决方法
可以利用以下方式实现集群层面的日志

* node logging agent
  ![](./imgs/log_02.png)
  * 日志代理需要运行在每个node上，所以可以设成DaemonSet类型
  * 比如：EFK解决方案
</br>
* Sidecar container with a logging agent
![](./imgs/log_03.png)
  * 不建议使用
</br>
* Exposing logs directly from the application
![](./imgs/log_04.png)
