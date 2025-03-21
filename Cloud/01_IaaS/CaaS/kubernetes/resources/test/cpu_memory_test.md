
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [1.模拟高内存（触发OOM）](#1模拟高内存触发oom)
- [2.模拟持续高内存（OOM且系统卡死）](#2模拟持续高内存oom且系统卡死)
- [3.模拟大量进程](#3模拟大量进程)

<!-- /code_chunk_output -->

* 注意下面的镜像必须用：stress（而不是stress-ng）
因为设置了limits后，stress-ng使用不会超过limits设置的值，所以不会触发OOM

#### 1.模拟高内存（触发OOM）

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: stress

  template:
    metadata:
      labels:
        app: stress
    spec:
      containers:
      - name: stress
        image: polinux/stress
        command: ["stress"]
        args:
        - "--vm"
        - "1"
        - "--vm-bytes"
        - "1G"
        - "--vm-hang"
        - "1"
        resources:
          limits:
            memory: 500Mi
          requests:
            memory: 10Mi
      nodeName: master-3
      tolerations:
      - operator: "Exists"
```

#### 2.模拟持续高内存（OOM且系统卡死）
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stress
spec:
  replicas: 8
  selector:
    matchLabels:
      app: stress

  template:
    metadata:
      labels:
        app: stress
    spec:
      containers:
      - name: stress
        image: polinux/stress-ng
        args:
        - "--brk"
        - "4"
        - "--stack"
        - "4"
        - "--bigheap"
        - "4"
      nodeName: master-3
      tolerations:
      - operator: "Exists"
```

#### 3.模拟大量进程
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: stress

  template:
    metadata:
      labels:
        app: stress
    spec:
      containers:
      - name: stress
        image: polinux/stress-ng
        args:
        - "-c"
        - "1000"
        - "-l"
        - "0"
      nodeName: master-3
      tolerations:
      - operator: "Exists"
```
