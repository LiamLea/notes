# scheduler
[toc]
### 基础概念
#### 1.调度分为三个过程
* predict（预选）
  排除不满足的节点
</br>
* priority（优选）
</br>
* select（选定）

```plantuml
card "predict（预选）" as a
card "priority（优选）" as b
card "select（选定）" as c
a->b
b->c
```

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
* 污点（taints）是node资源的属性，
* 一个node可以又多个taints，
* 每个taint都有一个key来命名该污点，都有一个value值来说明该污点，而且还需要定义排斥效果（effect)，
* node会判断pod能不能忍受它身上的所有污点，如果不能忍受某个污点，会则执行该污点的排斥效果（effect）
* pod通过tolerations来定义能够忍受的污点

**三种排斥效果（effect）**：
* NoSchedule			
仅影响调度过程，对现存pod不产生影响
</br>
* NoExecute				
既影响调度过程，又影响现存pod，不能容忍的pod将被驱逐
</br>
* PreferNoSchedule		
仅影响调度过程，不能容忍的pod实在找不到node，该node可以接收它

#### 4.影响调度的方式

##### （1）节点选择器
```yaml
spec.nodeName               #直接指定node的名字
spec.nodeSelector           #根据node的标签
spec.affinity.nodeAffinity  #根据node的标签，分为硬亲和（requested）和软亲和（preferred）
```
##### （2）pod的亲和性
```yaml
spec.affinity.podAffinity
spec.affinity.podAntiAffinity
```

##### （3）污点调度（taints）
```yaml
spec.tolerations
```

***

### 基本使用

#### 1.给node打标签和打污点
```shell
  kubectl label nodes NODENAME KEY1=VALUE1
  kubectl taint nodes NODENAME KEY1=vAVLUE1:EFFECT
```

#### 2.删除标签和污点
```
  kubectl label nodes NODENAME 标签名-
  kubectl taint nodes NODENAME 污点名-
```
