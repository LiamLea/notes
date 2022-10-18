# helm repo

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [helm repo](#helm-repo)
    - [概述](#概述)
      - [1.helm repo结构](#1helm-repo结构)
      - [2.`index.yaml`格式](#2indexyaml格式)
    - [自定义helm repo（以github.io为例子）](#自定义helm-repo以githubio为例子)
      - [1.前提：http服务](#1前提http服务)
      - [2.准备好charts](#2准备好charts)
      - [3.生成`index.yaml`索引文件](#3生成indexyaml索引文件)

<!-- /code_chunk_output -->

### 概述

#### 1.helm repo结构

```shell
charts/
  |
  |- index.yaml             #最重要的文件，用于索引chart（即指定了chart的下载地址）
  |
  |- alpine-0.1.2.tgz       #某一个chart（用tar -zcf进行了打包）
  |
  |- alpine-0.1.2.tgz.prov   #设置chart的签名（可以省略）
```

#### 2.`index.yaml`格式
```yaml
apiVersion: v1
entries:

  #最关键的三个信息： name、version 和 urls
  alpine:
    - name: alpine
      urls:
      - https://technosophos.github.io/tscharts/alpine-0.2.0.tgz
      version: 0.2.0
      #...

    - name: alpine
      urls:
      - https://technosophos.github.io/tscharts/alpine-0.1.0.tgz
      version: 0.1.0
      #...

  nginx:
    - name: nginx
      urls:
      - https://technosophos.github.io/tscharts/nginx-1.1.0.tgz
      version: 1.1.0
      #...

generated: 2016-10-06T16:23:20.499029981-06:00
```

***

### 自定义helm repo（以github.io为例子）

#### 1.前提：http服务
```shell
git clone git@github.com:LiamLea/liamlea.github.io.git
cd liamlea.github.io
```

#### 2.准备好charts
```shell
mkdir charts
mv xx.tgz ./charts/
```

#### 3.生成`index.yaml`索引文件
```shell
#会在charts目录下生成index.yaml文件
#指定了charts所在的url
helm repo index charts --url https://liamlea.github.io/charts
```
