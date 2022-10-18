# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署](#部署)
      - [1.修改密码](#1修改密码)
      - [2.启动参数](#2启动参数)
      - [2.Argo CD Image Updater](#2argo-cd-image-updater)

<!-- /code_chunk_output -->

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

#### 2.Argo CD Image Updater
