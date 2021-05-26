[toc]

#### 1.当pod处于evictd状态，且原因为The node was low on resource: ephemeral-storage

##### （1）原因分析
可能原因时该node上磁盘空间不足

##### （2）解决

* 查看该node节点的状态（主要关注taints）
```shell
kubectl describe nodes xx
#查看该nodes的taints
```

* 去除相应taints
```shell
kubectl taint KEY:EFFECT-

#当这种方法无法去除时，使用下面方法
#kubectl edit nodes xx
```

#### 2.一直处于pulling image的状态的可能原因

##### （1）原因分析
拉取的策略是拉取最新的，然而那台机器上已经有有该镜像运行的容器了，所以无法拉取到最新的镜像


#### 3.当pod一直处于pending状态，且不报错，处理方式

##### （1）原因分析

##### （2）解决
* 可以先delte该pod
* 重启kubelet（pod不会受影响）
* 重启docker（容器都会重启）

#### 4.当pod已经被调度后，出现问题的终极排错方法：

查看该pod所在节点的**kubelet的日志**

#### 5.删除namespace一直处于Terminating状态

##### （1）解决
* 获取该namespace的清单文件
```shell
kubectl get ns <NAMESPACE> -o json > /tmp/temp.json
```
* 将kubernetes从finalizers中删除
```
"spec": {
    "finalizers": [
        "kubernetes"
    ]
```

```
"spec": {
    "finalizers": [
    ]
```

* 应用
```shell
kubectl replace --raw "/api/v1/namespaces/<NAMESPACE>/finalize" -f /tmp/temp.json
```

#### 6.更换网络插件后一定要重启所有机器
具体原因看deploy.md文件


#### 7.`Error response from daemon: Conflict.`
容器冲突了，由于系统时间修改，导致有两个相同的容器，但是创建时间不同
解决：
删除冲突容器，如果不行，把这个pod先停掉，然后再删除相应的容器，再重新启动pod
