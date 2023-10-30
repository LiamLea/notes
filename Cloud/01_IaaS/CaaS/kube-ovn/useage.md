# useage


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [useage](#useage)
    - [subnet](#subnet)
      - [1.内置subnet](#1内置subnet)
        - [(1) default subnet (安装就存在)](#1-default-subnet-安装就存在)
        - [(2) join subnet](#2-join-subnet)
      - [2.自定义subnet](#2自定义subnet)

<!-- /code_chunk_output -->


### subnet

#### 1.内置subnet

##### (1) default subnet (安装就存在)

* 如果一个namesapce不指定subnet
    * 则默认使用default subnet，即使用default subnet给pod分配地址
    * 比如: pod-cidr为`10.244.0.0/16`，则default subnet就为`10.244.0.0/16`
```shell
 kubectl get subnet ovn-default -o yaml
```

##### (2) join subnet
* 在node上创建一个虚拟网卡`ovn0`，使得node能够与pod通信
    * 类似于vxlan的隧道

```shell
$ kubectl get subnet join -o yaml

#比如pod-cidr(default subnet): 10.244.0.0/16
#join subnet: 100.64.0.0/16
$ ip r

10.244.0.0/16 via 100.64.0.1 dev ovn0 
100.64.0.0/16 dev ovn0 proto kernel scope link src 100.64.0.3
```

#### 2.自定义subnet

* 同一个VPC下的subnet不能有重叠

```yaml
kind: Subnet
apiVersion: kubeovn.io/v1
metadata:
  name: subnet1
spec:
  vpc: ovn-cluster 
  namespaces:
  - test
  cidrBlock: 10.66.0.0/16
  gateway: 10.66.0.1
  gatewayType: distributed
  natOutgoing: true
```

* 等一会创建（立即创建上面配置可能还没生效）
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  namespace: test
spec:
  containers:
    - image: docker.io/kubeovn/kube-ovn:v1.8.0
      command:
        - "sleep"
        - "604800"
      imagePullPolicy: IfNotPresent
      name: ubuntu
  restartPolicy: Always
```