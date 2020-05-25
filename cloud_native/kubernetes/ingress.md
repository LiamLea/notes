# ingress
[toc]

### 概述
#### 1.ingress controller
ingreess controller 是一个pod，用作七层代理
也可以用于内部的代理转发，但通常不这样用

#### 2.ingress controller对外暴露的两个方式
* 常用的解决方法是，利用service代理到ingress controller（即下面的整个流程），不直接共享宿主机的网络名称空间
</br>
* 可以共享宿主机的网路命名空间，则可以直接访问该pod（不需要经过service了），然后该pod直接进行调度
共享宿主机的网络名称空间就意味着，该pod只能通过该宿主机访问到，解决方法是利用daemonset在指定的某些宿主机上运行该pod，就可以实现高可用性

#### 3.Ingress
* ingress是一种资源，用于注入配置到ingress controller中
* 可以创建多个ingress


#### 4.Ingress如何指定代理的pod
* 后端pod，由service进行分类（一个service对应一类pod）
* ingress会关联相应的service，从而能够知道 有哪些pod和 pod与service绑定的端口，从而能够将一类请求调度到这一类pod上


#### 5.整个流程：
```plantuml
card "外部（或内部）流量" as a
card "service" as b
card "ingress controller" as c
card "后端pod（这里pod由service分类）" as d
a -> b
b -> c
c -> d
```

### 使用
* 把配置注入到ingress controller中（当创建了Ingress资源，就会自动注入到相应类型的ingress controller中，不需要明确指定）
* 当后端pod的ip地址改变了，ingress就会相应修改ingress controller中的配置
* 当删除Ingress资源，注入到ingress controller中的配置也会被删除
```yaml
apiversion: extensions/v1beta1
kind: Ingress
metadata:
  name: xx

  #跟后端的pod在同一个名称空间中，而不是ingress-nginx
  namespace: xx

  annotations:
    #不能省略，指明使用nginx实现的ingress
    kubernetes.io/ingress.class: "nginx"

    #指明是否使用tls认证
    kubernetes.io/tls-acme: "true"
    #指明证书颁发机构，会自动生成tls相关证书
    cert-manager.io/issuer: xx
spec:
  rules:

  #匹配虚拟主机（即访问的目标主机），不设置这一项，匹配所有请求继续进行规则判断
  #比如：curl test.example.com，如果host设为test.example.com，该访问就能匹配该规则
  - host: xx				
    http:
      paths:

      #根据url，转发请求
      - path: /		
        backend:
          serviceName: xx   #后端的pod是由该service代理的pod
          servicePort: xx   #指定service端口，其实就是确定后端的pod端口（实际不从service走，只是用于映射）

  tls:
  - hosts:

    #在证书中设置的主机名
    - xx

    #相关证书都存放在secret中，指定secret
    #如果上面设置了颁发机构，则这里会自动生成该secret，不需要提前生成
    secretName: xx
```
