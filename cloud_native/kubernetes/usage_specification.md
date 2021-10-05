# usage specification

[toc]

### 1.应用的部署

#### （1）指定资源的需求和限制
* 明确指定 容器所需资源和使用上限
* 建议将requests和litmits值设为一样
```yaml
resources:
  requests:
    cpu: 1000m
    memory: 200Mi
  limits:
    cpu: 1000m
    memory: 200Mi
```

#### （2）进行存活和就绪探测
```yaml
#存活探测（如果未设置，则认为是存活的）
livenessProbe:
  httpGet:
    path: /healthy
    port: 9090
    scheme: HTTP
  initialDelaySeconds: 30   #启动后多久进行liveness探测
  periodSeconds: 15         #多久执行一次探测
  failureThreshold: 3       #连续失败3次，则认为探测失败
  successThreshold: 1       #连续成功1次，则认为探测成功
  timeoutSeconds: 30        #一次探测的超时时长

#就绪探测（如果未设置，则认为是就绪的）
readinessProbe:
  httpGet:
    path: /ready
    port: 9090
    scheme: HTTP
  initialDelaySeconds: 30   #启动后多久进行readiness探测
  periodSeconds: 5
  failureThreshold: 3
  successThreshold: 1
  timeoutSeconds: 4
```

#### （3）通过configmap注入配置
```yaml

spec:

  containers:
  - name: xx
    image: xx
    imagePullPolicy: xx

    #挂在逻辑卷
    volumeMounts:
    - name: xx
      mountPath: xx

  volumes:
  - name: xx
    configMap:
      name: xx
```

### 2.通信方式

#### （1）集群内部通信
在集群内部通信使用域名

* service的域名
```shell
<SERVICENAME>.<NAMESPACE>.svc.<CLUSTERNAME>
```

* statefulset管理的pod的域名
```shell
_<PORT_NAME>._<PORTP_ROTOCOL>.<SERVICENAME>.<NAMESPACE>.svc.<CLUSTERNAME>
```

#### （2）集群外部通信
通过service引入外部服务
```yaml
apiVersion: v1
kind: Service
metadata:
  name: vantiq
  namespace: aiops-nx
spec:
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: 80

---

apiVersion: v1
kind: Endpoints
metadata:
  name: vantiq
subsets:

- addresses:
  - ip: 192.168.1.1    #集群外部地址
  ports:
  - name: http
    port: 80
```

### 3.应用的访问
不建议使用NodePort

#### （1）通过ingress转发http请求
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: aiops-dev
  namespace: aiops-dev
spec:
  rules:
  - host: aiops.dev.zdgt
    http:
      paths:
      - backend:
          serviceName: kangpaas-front
          servicePort: 80
        path: /
  tls:
  - hosts:
    - aiops.dev.zdgt
    secretName: aiops.dev.zdgt-ingress
```
