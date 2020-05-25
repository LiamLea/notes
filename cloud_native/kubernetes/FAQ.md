# FAQ
[toc]
### 当pod处于evictd状态，且原因为The node was low on resource: ephemeral-storage
可能原因时该node上磁盘空间不足
1. 查看该node节点的状态（主要关注taints）
```shell
kubectl describe nodes xx
#查看该nodes的taints
```
2. 去除相应taints
```shell
kubectl taint KEY:EFFECT-

#当这种方法无法去除时，使用下面方法
#kubectl edit nodes xx
```

### 一直处于pulling image的状态的可能原因
* 拉取的策略是拉取最新的，然而那台机器上已经有有该镜像运行的容器了，所以无法拉取到最新的镜像


### 当pod一直处于pending状态，且不报错，处理方式
* 可以先delte该pod
* 重启kubelet（pod不会受影响）
* 重启docker（容器都会重启）

### 当pod已经被调度后，出现问题的终极排错方法：
查看该pod所在节点的**kubelet的日志**
