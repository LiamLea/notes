### 部署

#### 1.修改密码
```shell
htpasswd -bnBC 10 "" <PASSWD> | tr -d ':\n' | base64 -w 0
kubectl edit secret argocd-secret -n argocd   #修改admin.password
```

#### 2.启动参数
```shell
argocd-server

  #关闭https
  --insecure

  #用于反向代理
  --basehref <PATH>   #返回资源的地址，比如：/argocd
  --rootpath <PATh>   #真正的资源的地址，比如：/argocd
```
