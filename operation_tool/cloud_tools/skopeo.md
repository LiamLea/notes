# skopeo

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [skopeo](#skopeo)
    - [概述](#概述)
      - [1.用于操作镜像仓库](#1用于操作镜像仓库)
    - [使用](#使用)
      - [1.list某个镜像的tags](#1list某个镜像的tags)
      - [2.copy某个镜像](#2copy某个镜像)
      - [3.迁移某个镜像仓库](#3迁移某个镜像仓库)

<!-- /code_chunk_output -->

### 概述

#### 1.用于操作镜像仓库
* 能够inspect某个具体的镜像
* 能够list某个镜像的tags
* 能够copy某个镜像

***

### 使用

[参考](https://github.com/containers/skopeo)

#### 1.list某个镜像的tags
```shell
docker run --rm -v /tmp:/tmp -it quay.io/skopeo/stable:latest list-tags --tls-verify=false docker://10.10.10.250/k8s.gcr.io/kube-scheduler
```

#### 2.copy某个镜像
|支持导出的类型|说明|
|-|-|
|`docker://<docker-reference>`|copy到另一个镜像仓库|
|`docker-archive:<path>`|相当于docker save|
|`docker-daemon:<docker-reference>`|加载到某一个docker daemon|
|`dir:<path>`||
|`containers-storage:<docker-reference>`||
|`oci:<path>:<tag>`||

```shell
docker run --rm -v /tmp:/tmp -it quay.io/skopeo/stable:latest copy --src-tls-verify=false docker://10.10.10.250/k8s.gcr.io/kube-scheduler:v1.16.0 docker-archive:/tmp/a.tar.gz
```

#### 3.迁移某个镜像仓库

* 先列出所有的仓库
  ```shell
  curl -X GET -u admin:Harbor12345 10.10.10.250:80/v2/_catalog
  ```

* 导出某个仓库中的所有镜像
  ```shell
  #--scoped表示导出路径
  docker run --rm -v /tmp:/tmp -it quay.io/skopeo/stable:latest sync --src-tls-verify=false --scoped --src docker --dest dir 10.10.10.250/k8s.gcr.io/kube-scheduler /tmp/all_images
  ```
  * 导出来的目录如下所示
  ```shell
  /tmp/all_images
  └── 10.10.10.250
      └── k8s.gcr.io
          ├── kube-scheduler:v1.16.0
          │?? ├── 301ddc62b80b16315d3c2653cf3888370394277afb3187614cfa20edc352ca0a
          │?? ├── 39fafc05754f195f134ca11ecdb1c9a691ab0848c697fffeb5a85f900caaf6e1
          │?? ├── c589747bc37c8b82f8ab998942e97228f2506cc414a8ab718f1cd3d8bfc5d430
          │?? ├── manifest.json
          │?? └── version
          ├── kube-scheduler:v1.17.0
          │?? ├── 597de8ba0c30cdd0b372023aa2ea3ca9b3affbcba5ac8db922f57d6cb67db7c8
          │?? ├── 5b4df844502e73e509431df2b461a1342e0c01330298e0cd604011f477aaf464
          │?? ├── 78c190f736b115876724580513fdf37fa4c3984559dc9e90372b11c21b9cad28
          │?? ├── manifest.json
          │?? └── version
          ├── kube-scheduler:v1.18.0
          │?? ├── 597de8ba0c30cdd0b372023aa2ea3ca9b3affbcba5ac8db922f57d6cb67db7c8
          │?? ├── a31f78c7c8ce146a60cc178c528dd08ca89320f2883e7eb804d7f7b062ed6466
          │?? ├── db0bc0689c0979d093e1f6302a1bae7ad3794839b8b40b2e70c09309ad536c63
          │?? ├── manifest.json
          │?? └── version
          ├── kube-scheduler:v1.19.0
          │?? ├── 037f0ee5623061323ae87011cc46a14ec50c077b82240d5be026b8d219f232cd
          │?? ├── a84ff2cd01b7f36e94f385564d1f35b2e160c197fa58cfd20373accf17b34b5e
          │?? ├── b9cd0ea6c874f41c5c0ce7710de3f77e4c62988612c5e389b3b2b08ee356d8be
          │?? ├── cbdc8369d8b15fa8d42f90de7ba17a1f8ff84185de072017a9ededb15af6408b
          │?? ├── manifest.json
          │?? └── version
          ├── kube-scheduler:v1.20.0
          │?? ├── 2f71710e6dc291c6d9f68fabe36115abb54e8ee1112a31523904526e968159b8
          │?? ├── 3138b6e3d471224fd516f758f3b53309219bcb6824e07686b3cd60d78012c899
          │?? ├── cbcdf8ef32b41cd954f25c9d85dee61b05acc3b20ffa8620596ed66ee6f1ae1d
          │?? ├── f398b465657ed53ee83af22197ef61be9daec6af791c559ee5220dee5f3d94fe
          │?? ├── manifest.json
          │?? └── version
  ```

* 导入镜像到镜像仓库
  ```shell
  #--scoped表示导入路径，所以
  #harbor中需要创建好相应的project（此例中就是：k8s.gcr.io）
  docker run --rm -v /tmp:/tmp -it quay.io/skopeo/stable:latest sync --dest-tls-verify=false --scoped --dest-creds admin:Harbor12345 --src dir --dest docker /tmp/all_images/10.10.10.250 10.10.10.101
  ```
