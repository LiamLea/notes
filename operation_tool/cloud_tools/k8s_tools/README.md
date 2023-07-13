# k8s_tools

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [k8s_tools](#k8s_tools)
    - [quick start](#quick-start)
      - [1.配置脚本](#1配置脚本)
      - [2.执行脚本](#2执行脚本)

<!-- /code_chunk_output -->

### quick start

#### 1.配置脚本
* 修改配置
```shell
$ vim k8s_tools.py
```

```python
operations = {
    #kubeconfig地址
    "kube_config": "/root/.kube/config",

    #配置脚本需要执行的操作
    "operations":{
        "label": {
            #是否开启 label操作
            "enabled": False,
            "tasks": [
                  {
                    "namespaces": ["aaa"],
                    "controllers": [],
                    "labels": ["aa=11"],
                    "annotations": [],
                    "restart": True
                  }
            ]
        },
        "get_all": {
            #是否开启 导出资源操作
            "enabled": False,
            #导出资源的目录
            "export_dir": "/tmp/k8s"
        },
        "restore_global": {
            #是否开启 导入资源操作
            "enabled": False,
            #待导入资源存放的目录
            "import_dir": "/tmp/k8s"
        },
        "list_images": {
            #是否开启 列出仓库中所有镜像的操作
            "enabled": False,
            #仓库信息
            "registry_url": "http://192.168.6.111:5000",
            "username": "admin",
            "password": "Harbor12345"
        }
    }
}
```

#### 2.执行脚本
```shell
python3 k8s_tools.py
```
