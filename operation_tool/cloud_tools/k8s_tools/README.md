# k8s_tools

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [k8s_tools](#k8s_tools)
    - [quick start](#quick-start)
      - [1.导出所有资源](#1导出所有资源)
      - [2.恢复资源](#2恢复资源)
      - [3.列出所有镜像](#3列出所有镜像)

<!-- /code_chunk_output -->

### quick start

#### 1.导出所有资源
* 修改配置
```shell
$ vim k8s_tools.py

#导出的目录
dir = "/tmp/k8s"
#kubeconfig地址
kube_config = "/root/.kube/config"
```

* 导出资源
```shell
python3 k8s_tools.py get_all
```

#### 2.恢复资源
* 修改配置
```shell
$ vim k8s_tools.py

#资源所在的目录
dir = "/tmp/k8s"
#kubeconfig地址
kube_config = "/root/.kube/config"
```

* 导入全局资源
```shell
python3 k8s_tools.py restore_global
```

#### 3.列出所有镜像
* 修改配置
```shell
$ vim k8s_tools.py

#registry的地址
registry_url = "http://192.168.6.111:5000"
```

* 列出所有镜像
```shell
python3 k8s_tools.py list_images
```
