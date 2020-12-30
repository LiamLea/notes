# backup and restore

[toc]

### 备份

#### 1.备份etcd数据
```shell
etcdtl <connect_to_etcd> snapshot save <backup_file>

#查看备份文件的状态：etcdctl snapshot status <back_file>
```

#### 2.备份kubeadm-config配置文件
如果没有备份，可以通过先恢复etcd数据，然后获取kubeadm-config配置文件的内容
```shell
kubectl get cm -n kube-system kubeadm-config -o yaml > /tmp/kubeadm-config.yaml
```

***

### 恢复master

#### 1.重置master（不是必须，如果原先的master只是数据需要恢复，这步可以不执行）
```shell
kubeadm reset

#根据上面的kubeadm-config中的ClusterStatus，设置<FLAGS>
#删除Kubeadm-config中内容，只留下ClusterConfiguration的内容
kubeadm init <FLAGS> --config /tmp/kubeadm-config.yaml

scp /etc/kubernetes/admin.conf ~/.kube/config
#查看：kubectl get nodes
```

#### 2.恢复etcd数据（重要）
* 注意：如果有多个master，即有多个etcd
  * 只要恢复主etcd的数据，其他etcd会自动同步主etcd的内容
  * 主etcd是第一个master上的etcd

```shell
rm -rf /var/lib/etcd/
etcdctl snapshot restore <backup_file> --data-dir=/var/lib/etcd/

#验证：
#   kubectl get nodes
#刚开始node都是ready状态，因为etcd保存的状态都是ready，所以需要等一会，等node状态更新
```

#### 3.修改etcd中的旧数据
##### （1）cluster-info中的ca证书
```shell
cat /etc/kubernetes/pki/ca.crt | base64 -w 0

#将结果覆盖cluster-info中的 certificate-authority-data: 字段内容
kubectl edit cm cluster-info -n kube-public
```

***

### 恢复node

#### 1.在master上执行
```shell
kubeadm token create --print-join-command
#kubeadm join 3.1.5.15:6443 --token frukt8.gq7efeghzgdyvgel     --discovery-token-ca-cert-hash sha256:35dab95442124ab06306becb0531907b37267a6029441c3fe0b59a485155c963
```

#### 2.恢复node
##### （1）方式一：不重置node，即正在运行的pod不会受到影响
```shell
rm -rf /etc/kubernetes/pki /var/lib/kubelet/pki
kubeadm join phase kubelet-start ...
```

##### （2）方式二：重置node节点
```shell
kubeadm reset

#join时kubeadm的配置是从kubeadm-config这个configmap中获取的
kubeadm join ...
```
