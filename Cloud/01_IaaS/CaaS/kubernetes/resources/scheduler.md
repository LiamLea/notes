# scheduler

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [scheduler](#scheduler)
    - [基础概念](#基础概念)
      - [1.调度有三个过程](#1调度有三个过程)
        - [（1）Filtering（筛选）](#1filtering筛选)
        - [（2）Scoring（计分）](#2scoring计分)
        - [（3）Assign（分配）](#3assign分配)
      - [2.调度需要考虑的几个方面](#2调度需要考虑的几个方面)
        - [（1）资源需求](#1资源需求)
        - [（2）根据标签或名称选择节点](#2根据标签或名称选择节点)
        - [（3）亲和性](#3亲和性)
        - [（4）污点（taints）](#4污点taints)
        - [（5）其他约束](#5其他约束)
      - [2.亲和性（反亲和性）](#2亲和性反亲和性)
        - [（1）与node的亲和性](#1与node的亲和性)
        - [（2）与pod的亲和性](#2与pod的亲和性)
        - [（3）硬亲和（requested）](#3硬亲和requested)
        - [（4）软亲和（preferred）](#4软亲和preferred)
      - [3.污点（taints）](#3污点taints)
        - [（1）说明](#1说明)
        - [（2）三种排斥效果（effect）](#2三种排斥效果effect)
    - [基本使用](#基本使用)
      - [1.给node打标签和打污点（永久）](#1给node打标签和打污点永久)
      - [2.删除标签和污点](#2删除标签和污点)
      - [3.pod设置能够忍受的污点](#3pod设置能够忍受的污点)

<!-- /code_chunk_output -->

### 基础概念

#### 1.调度有三个过程

##### （1）Filtering（筛选）
找出所有feasible nodes（可行性节点），即满足条件的节点

##### （2）Scoring（计分）
根据得分，选出最合适的节点

##### （3）Assign（分配）
将pod分配到选出的节点上

#### 2.调度需要考虑的几个方面

具体的策略看文档：https://kubernetes.io/docs/reference/scheduling/policies/

##### （1）资源需求
```yaml
sepc.containers.resources.requests
```

##### （2）根据标签或名称选择节点
```yaml
spec.nodeName               #直接指定node的名字

spec.nodeSelector           #根据node的标签
```

##### （3）亲和性

* 与节点亲和
```yaml
spec.affinity.nodeAffinity  #根据node的标签，分为硬亲和（requested）和软亲和（preferred）
```

* 与pod亲和（affinity）
```yaml
spec.affinity.podAffinity
spec.affinity.podAntiAffinity
```

##### （4）污点（taints）
```yaml
spec.tolerations
```

##### （5）其他约束
* local pv
* 等等

#### 2.亲和性（反亲和性）

亲和性调度是基于标签的
```  
比如：
  pod A与有disk=ssd标签的node亲和
  意思就是选择node时，选择的node需要有disk=ssd这个标签

比如：
  pod A与有app=nginx标签的pod亲和，
  亲和条件（topologyKey）为hostname，
  意思就是选择node时，node上的hostname标签要与 有app=nginx标签的pod所在node上的hostname标签 相同
```
##### （1）与node的亲和性
  某个pod需要运行在某一类型的node上，比如需要运行在含有ssd硬盘的node上

##### （2）与pod的亲和性
  应用A与应用B两个应用频繁交互，
  所以有必要让尽可能的靠近（可以在同一个机架上，甚至在一个node上）
```
#反亲和性：当应用的采用多副本部署时，
  有必要采用反亲和性让各个应用实例打散分布在各个node上，以提高HA。
```
##### （3）硬亲和（requested）
  必须满足亲和性的要求

##### （4）软亲和（preferred）
  尽量满足亲和性额要求

#### 3.污点（taints）

##### （1）说明
* 污点（taints）是node资源的属性，
* 一个node可以又多个taints，
* 每个taint都有一个key来命名该污点，都有一个value值来说明该污点，而且还需要定义排斥效果（effect)，
* node会判断pod能不能忍受它身上的所有污点，如果不能忍受某个污点，会则执行该污点的排斥效果（effect）
* pod通过tolerations来定义能够忍受的污点

##### （2）三种排斥效果（effect）
* NoSchedule			
仅影响调度过程，对现存pod不产生影响
</br>
* NoExecute				
既影响调度过程，又影响现存pod，不能容忍的pod将被驱逐
</br>
* PreferNoSchedule		
仅影响调度过程，不能容忍的pod实在找不到node，该node可以接收它

***

### 基本使用

#### 1.给node打标签和打污点（永久）
```shell
kubectl label nodes <NODENAME> <KEY1>=<VALUE1>
kubectl taint nodes <NODENAME> <KEY1>=<vAVLUE1>:<EFFECT>
```

#### 2.删除标签和污点
```shell
kubectl label nodes <NODENAME> <标签名>-
kubectl taint nodes <NODENAME> <污点名>-
```

#### 3.pod设置能够忍受的污点
```yaml
spec:
  tolerations:
  - key: "<KEY>"    #匹配指定key
    operator: "<OPERATOR | default=Equal>"    #Exists 或者 Equal
    #当key为空,operator必须为Exists，表示匹配所有taints
    vlaue: <value>      #当为Equal时，才需要value字段，用于判断是否匹配
    effect: <EFFECT>    #当effect为空，表示匹配所有effect
```
* 匹配所有tains（kube-proxy就设置了这个）
```yaml
spec:
  tolerations:
  - operator: "Exists"
```
