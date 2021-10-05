# ResourceQuota

[toc]

### 概述

#### 1.ResourceQuota资源
用于对指定命名空间的资源使用量进行配额

***

### 使用

#### 1.简单使用
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: <name>
  namespace: <namespace>    #对该namespace进行配额
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```
