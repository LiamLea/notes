# cert-manager
[toc]
### 概述
### 部署
[参考官网](https://cert-manager.io/docs/installation/kubernetes/)
```shell
kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.0 \
  --set installCRDs=true
```
### 使用
#### 1.创建证书签发机构
##### （1）方式一：Issuer（指定命名空间中的证书签发机构）
Issuer只能在Issuer所在命名空间中签发证书

```shell
#ca.crt和ca.key需要提前生成
kubectl create secret tls ca-key-pair \
   --cert=ca.crt \    
   --key=ca.key \
   --namespace=default
```
```yaml
#issuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: ca-issuer
  namespace: default
spec:
  ca:
    secretName: ca-key-pair
```

##### （2）方式二：ClusterIssuer（全局证书签发机构）
注意：
如果利用这种方式，生成证书，证书可能一直处于waiting状态（即没有申请到）
可能的原因是当前所在的域达到了申请次数
```yaml
#issuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: xx
spec:
  acme:
    #是 acme 协议的服务端，我们这里用 Let's Encrypt，这个地址就写死成这样就行
    server: https://acme-v02.api.letsencrypt.org/directory

    #如果证书过期了会发邮件（过期会自动重新生成）
    email: xx@qq.com

    privateKeySecretRef:
      #指示此签发机构的私钥将要存储到哪个 Secret 对象中
      name: xx    

    solvers:
    - http01:
        ingress:
          class: nginx
```

注意：
* letsencrypt通过acme协议自动申请证书，其中包含两个sloving Challenge: http01,dns01,主要用来证明域名是属于你所有。
  * http01的校验原理是给你域名指向的 HTTP 服务增加一个临时 location ，`Let’s Encrypt` 会发送 http 请求到 `http:///.well-known/acme-challenge/`，`YOUR_DOMAIN` 就是被校验的域名，`TOKEN`是 ACME 协议的客户端负责放置的文件，在这里 ACME 客户端就是 cert-manager，它通过修改 Ingress 规则来增加这个临时校验路径并指向提供 `TOKEN` 的服务。此方法仅适用于给使用 Ingress 暴露流量的服务颁发证书，并且不支持泛域名证书。
  * dns01 的校验原理是利用 DNS 提供商的 API Key 拿到你的 DNS 控制权限， 在 Let’s Encrypt 为 ACME 客户端提供令牌后，ACME 客户端 (cert-manager) 将创建从该令牌和您的帐户密钥派生的 TXT 记录，并将该记录放在 `_acme-challenge.`。 然后 Let’s Encrypt 将向 DNS 系统查询该记录，如果找到匹配项，就可以颁发证书。此方法不需要你的服务使用 Ingress，并且支持泛域名证书。

#### 2.生成证书(Certificate)
本质就是**Secret**资源
##### （1）方式一：手动生成
```yaml
#cert.yaml
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: xx
  namespace: xx
spec:
  secretName: xx      #将生成的证书保存在xx这个secret中
  issuerRef:
    name: xx          #证书签发机构（issuer）的名字
    kind: Issuer      #还可以设为ClusterIssuer
  commonName: <FQDN>  #域名
  organization:
  - CA
  dnsNames:
  - <FQDN>            #还可以用于哪些域名
  - <FQDN>
```

#### （2）方式二：创建Ingress时，自动生成
```yaml
metadata:
  annotations:
    #指明是否使用tls认证
    kubernetes.io/tls-acme: "true"
    #指明证书颁发机构，会自动生成tls相关证书
    cert-manager.io/issuer: xx
spec:
  rules: ...
  tls:
  - hosts:
    #在证书中设置的主机名
    - xx

    #相关证书都存放在secret中，指定secret
    #如果上面设置了颁发机构，则这里会自动生成该secret，不需要提前生成
    secretName: xx
```
