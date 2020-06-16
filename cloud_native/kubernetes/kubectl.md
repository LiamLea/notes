[toc]
# kubectl
apiserver的客户端程序，是k8s集群的管理入口

### 创建资源
#### 1.创建service
```shell
kubectl expose TYPE NAME \        #TYPE：控制器的类型，NAME：控制器名字必须是已存在的
          --name=服务名字 \
          --port=xx \             #service的端口号
          --target-port=xx        #target-port为容器的端口号
```
***
### 删除资源
#### 1.删除所有evicted状态的pods
```shell
kubectl get pods --all-namespaces --field-selector 'status.phase==Failed' -o json | kubectl delete -f -
```
#### 2.强制删除
```shell
kubectl delete ...  --force --grace-period=0
```
***
### 查询资源
#### 1.列出所有apiVersion
```shell
kubectl api-versions
```
（1）apiVersion的结构
```shell
group/verison

#特例是核心群组中的：v1
```
（2）url中的路径
```shell
apis/GROUP/VERSION/RESOURCE

#比如：apis/apps/v1/namespaces/default/deployment
#列出default命名空间中的所有deployment控制器

#特例：核心群组
#比如：api/v1/namespaces
#列出所有的命令空间
```
#### 2.列出所有apiReousrces
```shell
kubectl api-resources

#NAME             资源的名称                              
#SHORTNAMES       缩写
#APIGROUP         api所在group             
#NAMESPACED       是否是命名空间内的资源
#KIND             资源类型
```

#### 3.访问api
```shell
kubectl get --raw "<url>"

#比如查看所有namespace
kubectl get --raw "/api/v1/namespaces"
```

#### 3.查看已创建的资源实例
```shell
kubectl get all         #不能获取指定命名空间下的全部资源

kubectl api-resources \
         --verbs=list \	      #过滤出支持list这个动作的资源
         --namespaced \	      #过滤出属于名称空间范围的资源
         -o name \            #过滤出资源的名字
         --show-labels         #查看资源的所有标签

#可以将过滤出的资源放入一个文件中
#然后遍历每一个资源，进行kubectl get，从而获取该名称空间下的已创建的全部资源
```
#### 4.查看已创建的某种资源实例
```shell
kubectl get xx
    -A               #获取所有命名空间下的
    -n xx            #-n指明名称空间，不加-n，默认是default名称空间
    -o wide          #-o指明输出格式，wide输出扩展信息
    -l xx=yy         #过滤含有xx这个标签且标签值为yy的资源
                     #也可以-l xx直接过滤含有xx标签的pods  
    --filed-selector xx=yy    #过滤xx字段为yy的资源
                              #字段即kubectl describe xx能够查看到的字段
                              #比如：--filed-selector metadata.namespace=default,statu.phase!=Running

#标签有两种关系判断：
#  等值关系：=    !=
#  集合关系：KEY in (VALUE1,VALUE2,...)   
#           KEY not in (VALUE1,...)
#           !KEY  
```      
#### 5.查看某个实例的详细信息
```shell
kubectl describe TYPE NAME      #TYPE：资源类型，NAME：资源名称，查看某个资源的详细信息

kubectl get TYPE NAME

    -o yaml

    -o jsonpath='{@}'
# {@}表示输出整个jsonpath
# {.xx[0].xx}利用这种形式获取某个键的值
```
#### 6.查询node节点的状态
```shell
kubectl describe nodes xx
```
|Type|说明|Status</br>（True、False或Unkown）|lastProbeTime</br>（上次探测pod状态的时间戳）|lastTransitionTime</br>（从一个状态转换为另一种状态的时间戳）|reason</br>（状态切换的原因）|message</br>（对该状态切换的详细说明）|
|-|-|-|-|-|-|-|
|NetworkUnavailable|是否网络不可达||||||
|MemoryPressure|是否有内存压力||||||
|DiskPressure|是否有磁盘压力||||||
|PIDPressure |是否有pid压力||||||
|Ready|是否准备就绪|
***
### 管理pods
#### 1.创建pods
```shell
kubectl run NAME \          #NAME为pod控制器的名字
      --image=xx \                
      --replicas=xx         #replicas指明副本数，至少为1，即只有1个容器
```

#### 2.动态扩容和缩容pods
```shell
kubectl scale --relicas=xx 控制器名
```

#### 3.升级镜像
```shell
kubectl set image deployment 控制器名 容器名=新的镜像名
```       

#### 4.在容器内执行指令
```shell
kubectl exec NAME [-c xx] [-it] -- 命令
```

#### 5.查看日志
```shell
kubectl logs POD_NAME
            -c xx         #指定要查看的容器
            --since=5s    #显示最近5s的日志，当日志特别的的时候，这个选项很实用（可以将结合-f使用）
            -f            #follow
            -p            #previous，查看该容器的上一个实例（常用于查询终止的容器的日志）
                          #当容器重新启动，kubelet会保留该容器上一个终止的实例
```
***
### 管理标签和污点
#### 1.给资源打标签
```shell
kubectl label TYPE NAME xx1=xx ... xxn=xx       
```
#### 2.删除资源的某个标签
```shell
kubectl label TYPE NAME 标签名-
```
#### 3.给node打上污点
```shell
kubectl taint nodes NODENAME KEY1=VAVLUE1:EFFECT
#EFFECT的取值：
#   NoSchedule          仅影响调度过程，对现存pod不产生影响
#   NoExecute           既影响调度过程，又影响现存pod，不能容忍的pod将被驱逐
#   PreferNoSchedule    仅影响调度过程，不能容忍的pod实在找不到node，该node可以接收它

```
#### 4.删除某个污点
```shell
kubectl taint nodes NODENAME 污点名-

#当使用这种方法无法删除时，使用下面命令删除
#kubectl edit nodes NODENAME
```
***
### 其他操作
#### 1.在某台master上开启代理
```shell
kubectl proxy --address="0.0.0.0" --port=8080 --accept-hosts='^.*' --accept-paths='^.*'

#之后就可以利用url获得相关资源
#比如：
#  curl 127.0.0.1:8080/api/v1/namespaces

#可以直接使用下面的命令，无需开启代理
# kubectl get --raw "/api/v1/namespaces"
```
#### 2.查询发生的事件（用于排错）
```shell
kubectl get events --sort-by=.metadata.creationTimestamp -n xx
```
