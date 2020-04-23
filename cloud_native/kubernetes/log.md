[toc]
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
##### （2）node层面
![](./imgs/log_01.png)
