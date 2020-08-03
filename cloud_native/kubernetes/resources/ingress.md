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
***
### 安装
利用helm
* nginx-ingress默认不转发TCP和UDP，需要设置一下
#### 1.设置转发TCP
（1）方式一：
```shell
$ vim nginx-ingress/values.yaml
```
```yaml
tcp:
  #将nginx controller上的端口转发到某个命名空间的某个service上的某个端口
  <CONTROLLER_PORT>: "<NAMESPACE>/<SERVICE_NAME>:<SERVICE_PORT>"
service:
  type: NodePort
  nodePorts:
    http: 32080
    https: 32443
    tcp:
      #将nginx-controller-service上的某个端口转发到nginx-controller上的指定端口
      <SERVICE_PORT>: <CONTROLLER_PORT>

#用于返回404的页面
defaultBackend:
  enabled: true
```
（2）方式二：
* 修改启动参数
```shell
vim nginx-ingrss/values.yaml
```
```yaml
extraArgs:
  tcp-services-configmap: <NAMESPACE>/<CONFIGMAP_NAME>
  udp-services-configmap: <NAMESPACE>/<CONFIGMAP_NAME>
```
* 设置具体转发哪里端口
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: <CONFIGMAP_NAME>
  namespace: <NAMESPACE>
data:
  #将30080端口转发到<NAMESPACE>命名空间中的<SERVICE_NAME>service上的80端口
  #具体转发TCP还是UDP，看上面配置的configmap名字
  30080: "<NAMESPACE>/<SERVICE_NAME>:80"
```

***
### 使用
* 把配置注入到ingress controller中（当创建了Ingress资源，就会自动注入到相应类型的ingress controller中，不需要明确指定）
* 当后端pod的ip地址改变了，ingress就会相应修改ingress controller中的配置
* 当删除Ingress资源，注入到ingress controller中的配置也会被删除

#### 1.清单文件
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: xx

  #跟后端的pod在同一个名称空间中，而不是ingress-nginx
  namespace: xx

  annotations:
    #不能省略，指明使用nginx实现的ingress
    kubernetes.io/ingress.class: "nginx"

    #使用clusterissuer
    kubernetes.io/tls-acme: "true"
    #指明证书颁发机构，会自动生成tls相关证书
    cert-manager.io/issuer: xx

    #默认开启tls后，所有http请求都会被重定向到https
    #可以关闭重定向
    nginx.ingress.kubernetes.io/ssl-redirect: "false"

    #设置能够上传的文件大小
    #设为0，表示不限制大小
    nginx.ingress.kubernetes.io/proxy-body-size: "0"

    #建立连接时的超时时间
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"

    #设置读写超时时间，当后端是websocket时，需要设置这一项，默认是60s，nginx会关闭和websocket的连接
    #read-timeout的意思是，如果在这个时间内，没有进行read操作，则断开连接，同理write-timeout
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"

spec:
  rules:

  #匹配 HTTP请求头中 的 Host字段的域名部分 是否 匹配下面设置的域名
  #不设置这一项，匹配所有请求继续进行规则判断
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

#### 2.查看是否注入
```shell
#进入重启内部
kubectl exec ...    

#查看配置文件，查看是否有响应的转发内容
vi /etc/nginx/nginx.conf
```

#### 3.排错
```shell
kubectl logs -f ...
#然后，访问一下，看日志输出的什么
```
