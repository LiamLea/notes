# backup and restore

[toc]

### etcdctl命令格式

**下面用到etcdtl都简写了**

```shell
docker run --rm -it \
  --network host -v /etc/kubernetes:/etc/kubernetes -v /var/lib:/var/lib -e ETCDCTL_API=3  \
  <image> \
  etcdctl --endpoints="127.0.0.1:2379"  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt  --key=/etc/kubernetes/pki/etcd/peer.key \
  <command>
```

***

### 备份数据

#### 1.备份etcd数据
```shell
etcdctl snapshot save /var/lib/etcd.bak

#查看备份文件的状态：etcdctl snapshot status <back_file>
```

#### 2.备份kubeadm-config配置文件（如果从0恢复最好备份）
如果没有备份，可以通过先恢复etcd数据，然后获取kubeadm-config配置文件的内容
```shell
kubectl get cm -n kube-system kubeadm-config -o yaml > /tmp/kubeadm-config.yaml
```

***

### 在现有集群上进行恢复

* master需要**按照一定的顺序恢复**

|顺序|如何判断|
|-|-|
|第一个master|查看etcd的manifests文件，没有`--initial-cluster-state=existing`这个参数|
|第二个master|查看etcd的manifests文件，`--initial-cluster=master-1=https://3.1.4.121:2380,master-3=https://3.1.4.123:2380`，包含第一个master|
|第三个master|查看etcd的manifests文件，`--initial-cluster=master-1=https://3.1.4.121:2380,master-2=https://3.1.4.122:2380,master-3=https://3.1.4.123:2380`，包含第一个和第二个master|
|第n个master|依次类推|

* 注意下面是https协议，不是http协议

#### 1.其他master需要停止
* 在其他master上执行（除了第一个master）
```shell
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/etcd
```

#### 2.恢复第一个master
init节点（指定的是初始化节点，即etcd的manifests中没有`--initial-cluster-state=existing`这个参数）

##### （1）恢复etcd数据

```shell
#暂停etcd并删除数据
systemctl stop kubelet
docker stop <etcd_container>
rm -rf /var/lib/etcd

#恢复数据
etcdctl snapshot restore /var/lib/etcd.bak --data-dir=/var/lib/etcd/

#重启etcd
systemctl restart kubelet

#修改etcd的member（因为恢复后，member信息会发生变化，需要修改）
etcdctl member list
#输出：8e9e05c52164694d, started, master-3, http://localhost:2380, https://3.1.4.123:2379
etcdctl member update 8e9e05c52164694d --peer-urls=https://3.1.4.123:2380
```

##### （2）验证
```shell
etcdctl member list
kubectl get nodes
```

#### 3.恢复第二个master

##### （1）需要在etcd中添加member
```shell
etcdctl member add master-1 --peer-urls=https://3.1.4.121:2380
```
* 注意：执行这条命令后，etcd可能会报错，导致apiserver不可用，不用管，等启动第二个etcd就好了

##### （2）重启服务
```shell
rm -rf /var/lib/etcd
systemctl restart docker
systemctl restart kubelet
```

#### 4.按顺序恢复其他master
参照恢复第二个master的步骤

#### 5.node节点不需要做任何操作

#### 6.更简单的恢复方法
* 上面的恢复方法步骤比较通用，当恢复etcd v2 data后，能利用上述方法恢复k8s集群
* 下面这种方法只试用etcd v3 data
[参考](https://www.mirantis.com/blog/everything-you-ever-wanted-to-know-about-using-etcd-with-kubernetes-v1-6-but-were-afraid-to-ask/)
```shell
#其中的参数能够通过etcd manifests查到
ETCDCTL_API=3 etcdctl snapshot restore BACKUP_FILE \
--name $ETCD_NAME--initial-cluster "$ETCD_INITIAL_CLUSTER" \
--initial-cluster-token “$ETCD_INITIAL_CLUSTER_TOKEN” \
--initial-advertise-peer-urls $ETCD_INITIAL_ADVERTISE_PEER_URLS \
--data-dir $ETCD_DATA_DIR
```

***

### 从0恢复

#### 1.初始换第一个master

##### （1）选择其中一个master，进行初始化
```shell
kubeadm init --config kubeadm.conf
#kubeadm.conf这个文件是 kubeadm-config这个configmap中的ClusterConfiguration内容
#如果没有备份kubeadm-config，可以先随便kubeadm init，然后恢复etcd的数据，然后获取其配置
```

##### （2）恢复etcd数据

```shell
#暂停etcd并删除数据
systemctl stop kubelet
docker stop <etcd_container>
rm -rf /var/lib/etcd

#恢复数据
etcdctl snapshot restore /var/lib/etcd.bak --data-dir=/var/lib/etcd/

#重启etcd
systemctl restart kubelet

#修改etcd的member（因为恢复后，member信息会发生变化，需要修改）
etcdctl member list
#输出：8e9e05c52164694d, started, master-1, http://localhost:2380, https://3.1.4.121:2379
etcdctl member update 8e9e05c52164694d --peer-urls=https://3.1.4.121:2380
```

##### （3）验证
```shell
etcdctl member list
kubectl get nodes
```

#### 2.修改旧数据

##### （1）cluster-info中的ca证书
```shell
cat /etc/kubernetes/pki/ca.crt | base64 -w 0

#将结果覆盖cluster-info中的 certificate-authority-data: 字段内容
kubectl edit cm cluster-info -n kube-public
```

##### （2）kubeadm-coonfig中的ClusterStatus
```shell
kubectl edit cm -n kube-system kubeadm-config
#修改ClusterStatus中的内容，将其他master信息删除，只保留初始化的这个master信息
```

#### 3.添加其他master节点

##### （1）获取加入命令
```shell
kubeadm token create --print-join-command
kubeadm init phase upload-certs --upload-certs
```

##### （2）加入该集群
```shell
kubeadm join xx --token xx --discovery-token-ca-cert-hash xx \
                --control-plane --certificate-key xx \
                --apiserver-advertise-address=<IP> \
                --apiserver-bind-port=<PORT> -v=5

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

#### 4.加入node

##### （1）获取token用于加入该集群（在初始化节点上执行）
```shell
kubeadm token create --print-join-command
```

##### （2）加入该集群
```shell
#这个命令来自上面的结果
kubeadm join ...			
```
