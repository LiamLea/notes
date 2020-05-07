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
