# migration

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [migration](#migration)
    - [概述](#概述)
      - [1.基本思路](#1基本思路)
    - [具体步骤](#具体步骤)
      - [1.导出资源](#1导出资源)
      - [2.恢复资源](#2恢复资源)
        - [（1）安装好基础组件](#1安装好基础组件)
        - [（2）恢复全局资源](#2恢复全局资源)
        - [（3）恢复storageclass和pv](#3恢复storageclass和pv)
        - [（4）恢复某个namespace](#4恢复某个namespace)

<!-- /code_chunk_output -->

### 概述

#### 1.基本思路

* 先导出资源
* 恢复资源
  * pv需要先删除claim信息再恢复
  * 动态pvc需要删除annotations信息

***

### 具体步骤

#### 1.导出资源

* 修改脚本的配置
```shell
vim /tmp/k8s_tools.py
```
```shell
dir = "/tmp/k8s"
kube_config = "/root/.kube/config"
```

* 执行脚本

```shell
docker run --rm -v /root/.kube/config:/root/.kube/config -v /tmp/:/tmp/ -v /usr/bin/kubectl:/usr/bin/kubectl python:3.7-alpine python3 /tmp/k8s_tools.py get_all
```

#### 2.恢复资源

##### （1）安装好基础组件
* 比如storageclass等

##### （2）恢复全局资源

* 修改脚本
```shell
vim /tmp/k8s_tools.py
```
```shell
dir = "/tmp/k8s"
kube_config = "/root/.kube/config"
```

* 恢复
会恢复：namespace、clusterrole、cluserrolebinding
```shell
docker run --rm -v /root/.kube/config:/root/.kube/config -v /tmp/:/tmp/ -v /usr/bin/kubectl:/usr/bin/kubectl python:3.7-alpine python3 /tmp/k8s_tools.py restore_global
```

##### （3）恢复storageclass和pv

##### （4）恢复某个namespace
* 恢复基础资源

```shell
kubectl apply -f k8s/<ns>/poddisruptionbudgets/
kubectl apply -f k8s/<ns>/roles/
kubectl apply -f k8s/<ns>/rolebindings/
kubectl apply -f k8s/<ns>/secrets/
kubectl apply -f k8s/<ns>/serviceaccounts/
kubectl apply -f k8s/<ns>/configmaps/
```

* 恢复pvc
  * 动态pvc需要删除annotations信息
```shell
kubectl apply -f k8s/<ns>/persistentvolumeclaims/
```

* 恢复计算资源
  * 如果有依赖，需要先恢复被依赖的部分
```shell
kubectl apply -f k8s/<ns>/daemonsets/
kubectl apply -f k8s/<ns>/statefulsets/
kubectl apply -f k8s/<ns>/deployments/
```
