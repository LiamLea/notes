# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署步骤](#部署步骤)
      - [1.安装](#1安装)
        - [（1）下载chart](#1下载chart)
        - [（2）配置](#2配置)

<!-- /code_chunk_output -->

### 部署步骤

#### 1.安装

##### （1）下载chart
[参考](https://github.com/apache/skywalking-kubernetes)
```shell
helm repo add skywalking https://apache.jfrog.io/artifactory/skywalking-helm
helm fetch skywalking/skywalking
```

##### （2）配置
```shell
vim skywalking/values.yaml
```

```yaml
#observability analysis platform
oap:
  storageType: elasticsearch7

elasticsearch:
  enabled: false    #使用已存在的es
  config:           #已存在的es的信息
    port:
      http: 9200
    host: elasticsearch-client.tot  #es地址
    user: "elastic"         # [optional]
    password: "Cogiot@2021"
```
