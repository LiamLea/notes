[toc]
### VirtualService
用于设置路由规则，将匹配的流量路由到指定destination（在k8s中destination一般就是service）
#### 1.特点
* 首先匹配流量的来源
* 可以路由七层和四层的流量
* rule中可以设置匹配条件（如头部信息、url等）
* rule遵循匹配即停止的规则
* 在一个rule中可以设置多个destination，且可以设置权重

#### 2.清单文件格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: xx
spec:
  hosts:
  - xx              #匹配客户端ip地址（或是可以解析的域名）
                    # * 匹配所有客户端
  http: []          #配置规则，转发http流量
```
#### 3.规则配置
```yaml
#每条规则可以设置相关匹配条件（也可以不设置）
- match:
  - headers:
      end-user:
        exact: jason

  route:
#设置destination，指向一个地址
  - destination:
#这里可以填ip，或service的域名，或能够解析的域名
      host: reviews
      port:
        number: 8088
      subset: v2
```
设置多个destination
```yaml
- route:
  - destination:
      host: reviews
      subset: v1
    weight: 75
  - destination:
      host: reviews
      subset: v2
    weight: 25
```
***
### DestinationRule
用于设置当流量达到destination后，如何分发到后端pods
#### 1.特点
* 会依据指定标签对后端pod进行分类，一个subset就是一类
* 某个subset中可以覆盖全局的分发策略
* 在VirtualService中配置了，路由到哪个subset
#### 2.清单文件格式
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: xx
spec:

#指定应用于哪个destination（即service）
  host: xx     

#配置如何将流量分发到后端       
  trafficPolicy:
    loadBalancer:

#还有ROUND_ROBIN，LEAST_CONN和PASSTHROUGH
      simple: RANDOM  	

#用于对后端Pods进行分类，这里一共分了三类，利用version这个标签  
#第一类的名字是v1，有version=v1这个标签的pods属于这一类    
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
  - name: v3
    labels:
      version: v3
```
***
### VitualService和DestinationRule的结合
VirutualService用于设置如何将流量路由到给定的目的地
Destination用于设置路由到该目的地后发生什么

VirtualService会将请求路由到某一个service上
Destination会给该service后端的pods进行分类
