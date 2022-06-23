# k8s_tools

[toc]

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
