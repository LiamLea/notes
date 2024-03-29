# ingress

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ingress](#ingress)
    - [概述](#概述)
      - [1.ingress controller](#1ingress-controller)
      - [2.ingress controller对外暴露的两个方式](#2ingress-controller对外暴露的两个方式)
      - [3.Ingress](#3ingress)
      - [4.Ingress如何指定代理的pod](#4ingress如何指定代理的pod)
      - [5.整个流程：](#5整个流程)
    - [安装](#安装)
      - [1.设置转发TCP](#1设置转发tcp)
        - [（1）方式一：](#1方式一)
        - [（2）方式二：](#2方式二)
        - [（3）方式三：](#3方式三)
    - [使用](#使用)
      - [1.清单文件](#1清单文件)
        - [（1）基本配置](#1基本配置)
        - [（2）修改转发到后端的url](#2修改转发到后端的url)
        - [（3）当后端是https协议时](#3当后端是https协议时)
        - [（4）存在解码问题的解决方案](#4存在解码问题的解决方案)
      - [2.查看是否注入](#2查看是否注入)
      - [3.排错](#3排错)

<!-- /code_chunk_output -->

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
##### （1）方式一：
```shell
$ vim nginx-ingress/values.yaml
```
```yaml
tcp:
  #将nginx controller上的端口转发到 某个命名空间 的 某个service上 的 某个端口
  <CONTROLLER_PORT>: "<NAMESPACE>/<SERVICE_NAME>:<SERVICE_PORT>"

service:
  type: NodePort
  nodePorts:
    http: 32080
    https: 32443
    tcp:
      #将nginx-controller的service上的某个端口转发到nginx-controller上的指定端口
      <SERVICE_PORT>: <CONTROLLER_PORT>

#用于返回404的页面
defaultBackend:
  enabled: true
```
##### （2）方式二：
* 修改启动参数
```shell
vim nginx-ingrss/values.yaml
```
```yaml
extraArgs:
  tcp-services-configmap: <NAMESPACE>/<CONFIGMAP_NAME>
  udp-services-configmap: <NAMESPACE>/<CONFIGMAP_NAME>

service:
  type: NodePort
  nodePorts:
    http: 32080
    https: 32443
    tcp:
      #将nginx-controller的service上的某个端口转发到nginx-controller上的指定端口
      <SERVICE_PORT>: <CONTROLLER_PORT>
```
* 通过configmap，设置具体转发哪里端口
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: <CONFIGMAP_NAME>
  namespace: <NAMESPACE>
data:
  #将 nginx-controller上的30080端口 转发到 <NAMESPACE>命名空间中的<SERVICE_NAME>的service上的80端口
  #具体转发TCP还是UDP，看上面配置的configmap名字
  30080: "<NAMESPACE>/<SERVICE_NAME>:80"
```

##### （3）方式三：
* 通过configmap设置转发规则
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: <CONFIGMAP_NAME>
  namespace: <NAMESPACE>
data:
  #将 nginx-controller上的30080端口 转发到 <NAMESPACE>命名空间中的<SERVICE_NAME>的service上的80端口
  #具体转发TCP还是UDP，看上面配置的configmap名字
  30080: "<NAMESPACE>/<SERVICE_NAME>:80"
```

* 修改nginx启动参数（通过修改pod的控制器）
```yaml
containers:
 - args:
   #加下面的参数
   - --tcp-services-configmap=<NAMESPACE>/<CONFIG_MAP_NAME>
```

* 修改nginx-controller的serivce
```yaml
spec:
  ports:
  - name: tcp
    nodePort: <宿主机_PORT>
    port: <SERVICE_PORT>
    protocol: TCP
    targetPort: <nginx-controller上_PORT>
```

***
### 使用
* 把配置注入到ingress controller中（当创建了Ingress资源，就会自动注入到相应类型的ingress controller中，不需要明确指定）
  * 一个ingress中的配置都会注入到相应主机中的 server或location block中
* 当后端pod的ip地址改变了，ingress就会相应修改ingress controller中的配置
* 当删除Ingress资源，注入到ingress controller中的配置也会被删除
* 每个ingress都可以设置tls（即每个server block中都可以有独立的tls配置）
  * tls是动态的，定义ingress时会被加载到共享内存中
  * 当nginx处理请求时，会自动加载证书

#### 1.清单文件

##### （1）基本配置

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: xx

  #跟后端的pod在同一个名称空间中，而不是ingress-nginx
  namespace: xx

  annotations:
    #使用clusterissuer
    cert-manager.io/cluster-issuer: xx

    #或者使用issuer
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

    #往location block中加配置
    #比如添加一个响应头 name: aa
    nginx.ingress.kubernetes.io/configuration-snippet: |
      add_header name aa;

spec:

  #指明使用哪个ingress controller
  ingressClassName: "nginx"

  rules:

  #匹配 HTTP请求头中 的 Host字段的域名部分 是否 匹配下面设置的域名
  #不设置这一项，匹配所有请求继续进行规则判断
  - host: xx				
    http:
      paths:

      #根据url，转发请求
      # pathType指定了匹配的策略：
      #   Exact  为精确匹配
      #   Prefix  为前缀匹配(e.g. /foo/bar matches /foo/bar/baz, but does not match /foo/barbaz)
      #   ImplementationSpecific  由ingress class自己决定（nginx是前缀匹配）
      # path注入到nginx配置文件中的顺序，按照path的长度，从上到下注入到nginx配置文件中的（而不是按照写在这里的顺序）
      - path: /
        pathType: Prefix
        backend:
          service:
            name: <service_name> #后端的pod是由该service代理的pod
            port:
              number: <port>    #指定service端口，其实就是确定后端的pod端口（实际不从service走，只是用于映射）

  tls:
  - hosts:

    #在证书中设置的主机名（这里必须要匹配，如果不写的话默认可能会用通配符）
    - xx

    #指定已存在的secret，该server block中tls配置需要的 相关证书都存放在secret中
    #如果上面设置了颁发机构，则这里会自动生成该secret，不需要提前生成
    secretName: xx
```

##### （2）修改转发到后端的url
* 需要添加`annotations`
```yaml
nginx.ingress.kubernetes.io/rewrite-target: <replcement>  #可以使用正则的组变量：$1，这个变量来自path中的正则匹配
```

* demo
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    ...
spec:
  ingressClassName: "nginx"
  rules:
  - host: aiops.dev.nari
    http:
      paths:
      - path: /(.*)
        pathType: Prefix
        backend:
          service:
            name: kangpaas-front
            port:
              number: 80

     - path: /gate/(.*)
       pathType: Prefix
       backend:
         service:
           name: kangpaas-gate
           port:
             number: 8093
     - path: /(ureport(/.*)?$)
       pathType: Prefix
       backend:
         service:
           name: blade-report
           port:
             number: 8108
  ...
```

##### （3）当后端是https协议时

* proxy_pass https
```yaml
#添加注解，就相当于
#proxy_pass https://
nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```

* ssl passthrough（不推荐，开销大，而且只能根据主机名路由）
  * 根据SNI（即主机名），选择后端，然后将tcp协议转发过去
  * 所以七层的配置都不会生效
  * 前提：nginx ingress controller需要`--enable-ssl-passthrough`
```yaml
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
```

##### （4）存在解码问题的解决方案

```yaml
...
metadata:
  annotations:
    #upstream_balancer是默认名称，后端的service是通过lua动态产生的
    nginx.ingress.kubernetes.io/configuration-snippet: |
      if ($request_uri ~ "^/argocd.*") {
        rewrite ^ $request_uri;
        rewrite "(?i)/(argocd.*)" /$1 break;
        proxy_pass http://upstream_balancer$uri;
        break;
      }
spec:
  ingressClassName: nginx
  rules:
    - host: k8s.my.local
      http:
        paths:
          - backend:
              service:
                name: argocd-server
                port:
                  number: 80
            path: /argocd
            pathType: Prefix
...
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
