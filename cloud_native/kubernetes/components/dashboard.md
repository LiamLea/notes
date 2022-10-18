# dashboard

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [dashboard](#dashboard)
    - [使用](#使用)
      - [安装](#安装)
        - [（1）下载yaml文件](#1下载yaml文件)
        - [（2）修改yaml](#2修改yaml)
        - [（3）安装](#3安装)
        - [（4）创建service account并赋予admin权限](#4创建service-account并赋予admin权限)

<!-- /code_chunk_output -->

### 使用

[参考](https://github.com/kubernetes/dashboard)

#### 安装

##### （1）下载yaml文件

```shell
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

##### （2）修改yaml
* 如需要的话将service设置为NodePort
* 修改镜像的地址

##### （3）安装
```shell
kubectl apply -f recommended.yaml
```

##### （4）创建service account并赋予admin权限

```shell
kubectl create sa dashboard-admin
```

* 绑定cluster-role角色
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dashboard-admin

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin

subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: default
```

* 获取token
```shell
#base64 -d
kubectl get secret dashboard-admin-token-xphf5 -o yaml
```
