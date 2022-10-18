# helm

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [helm](#helm)
    - [基础概念](#基础概念)
      - [1.chart](#1chart)
      - [2.repository](#2repository)
      - [3.release](#3release)
      - [4.程序架构](#4程序架构)
      - [5.chart目录结构](#5chart目录结构)
      - [6.heml安装资源的顺序](#6heml安装资源的顺序)
      - [7.手动设置安装资源的顺序](#7手动设置安装资源的顺序)
    - [使用](#使用)
      - [1.初始化helm（即生成tiller服务端，新版已经弃用）](#1初始化helm即生成tiller服务端新版已经弃用)
      - [2.检测是否可用](#2检测是否可用)
      - [3.chart仓库管理](#3chart仓库管理)
      - [4.chart管理](#4chart管理)
      - [5.release管理](#5release管理)
      - [6.查看历史release](#6查看历史release)
    - [helm模板语法](#helm模板语法)
      - [1.基本语法](#1基本语法)
      - [2.helm内置对象和内置变量](#2helm内置对象和内置变量)
      - [3.判断语句](#3判断语句)
      - [4.with语句（修改作用域）](#4with语句修改作用域)
      - [5.range语句（遍历）](#5range语句遍历)
      - [6.常见例子](#6常见例子)
    - [自定义chart](#自定义chart)

<!-- /code_chunk_output -->

### 基础概念
#### 1.chart
一个helm程序包，包含定义资源的清单文件

#### 2.repository
charts仓库

#### 3.release
chart部署于目标集群上的一个实例

#### 4.程序架构
* helm
客户端，管理本地的chart仓库，管理chart
  与tiller服务器交互，发送chart，实例安装、查询、卸载等

* tiller
服务端，接收helm发来的charts和config，合并生成release

#### 5.chart目录结构
```shell
  Chart.yaml            #该chart的描述文件,包括ico地址,版本信息等
  templates/            #存放k8s模板文件目录
  values.yaml           #给模板文件使用的变量
  requirements.yaml     #指明该chart依赖哪些chart
  charts/               #存放依赖的chart的目录
```
#### 6.heml安装资源的顺序
helm会收集给定chart中的所有资源，然后安装顺序安装
```
Namespace
ResourceQuota
LimitRange
PodSecurityPolicy
Secret
ConfigMap
StorageClass
PersistentVolume
PersistentVolumeClaim
ServiceAccount
CustomResourceDefinition
ClusterRole
ClusterRoleBinding
Role
RoleBinding
Service
DaemonSet
Pod
ReplicationController
ReplicaSet
Deployment
StatefulSet
Job
CronJob
Ingress
APIService
```
#### 7.手动设置安装资源的顺序
在资源中加上以下注释（annotations）
```yaml
annotations:
  "helm.sh/hook": pre-install
  "helm.sh/hook-weight": "5"      #权重越高，越先安装
```
***
### 使用

#### 1.初始化helm（即生成tiller服务端，新版已经弃用）
```shell
helm init --service-account tiller
```

#### 2.检测是否可用
```shell
helm version      #会列出client端和server端的版本信息
```

#### 3.chart仓库管理
helm repo add的本质就是添加`index.yaml`文件到本地，
由于index的文件过大，且helmhub对各个仓库的index文件大小有限制，所以无法查找到比较旧的chart，
所以需要使用全量的index文件，以bitnami为例（[相关issue](https://github.com/bitnami/charts/issues/10539))：
* 在helmhub上的提供的`index.yaml`: `https://charts.bitnami.com/bitnami`
* 全量的`index.yaml`: `https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami`
  * 通过页面访问的地址：`https://github.com/bitnami/charts/tree/archive-full-index/bitnami`
```shell
helm repo list
helm search repo -l <chart>
```

#### 4.chart管理
```shell
helm create xx            #在本地创建一个chart
helm fetch xx             #将chart下载到本地，并解压
helm inspect xx           #查看一个chart的详细信息
hel package chart路径     #打包本地的chart文件
```

#### 5.release管理
```shell
helm install --name xx xx1	 #xx1为chart名或者本地chart的路径
helm status xx              #查看已安装的release的信息（包括service信息等）
helm list                   #列出已安装的release
helm delete xx --purge
helm upgrade xx xx1         #xx1为chart名或者本地chart的路径

#获取release的manifests
helm get manifest <release>
```

#### 6.查看历史release
```shell
#查看revision
helm history <releae_name>

#查看values文件
helm get values <releae_name> --revision <revision>

#查看全部文件
helm get all <releae_name> --revision <revision>
```

***

### helm模板语法

#### 1.基本语法
```yaml

#通过双括号注入,小数点开头表示从最顶层命名空间引用.
  {{ .OBJECT.Name }}		  

#使用容器内的环境变量，在chart中如何使用的，需要看具体使用的地方
#如果在pod.spec.containers.env.value，语法：
  $(<VAIRABLE_NAME>)
#如果在shell中，语法：
  ${<VAIRABLE_NAME>}
```
#### 2.helm内置对象和内置变量
```shell
  Release           #release相关属性
  Chart             #Chart.yaml文件中定义的内容
  Values            #values.yaml文件中定义的内容
```
[内置变量](https://helm.sh/docs/chart_template_guide/builtin_objects/)

#### 3.判断语句
```yaml
#if语句
  {{ if .OBJECT.Name }}   
    # Do something
  {{ else if .OBJECT.Name }}
    # Do something else
  {{ else }}
    # Default case
  {{ end }}
```
#### 4.with语句（修改作用域）
```yaml
{{ with .OBJECT.Name }}
  # restricted scope
{{ end }}
```
demo
>values.yml
```yaml
favorite:
  drink: coffee
  food: pizza
```
>templates/xx.yml
```yaml
{{- with .Values.favorite }}    #则根域（.）就表示.Values.favorite
drink: {{ .drink }}
food: {{ .food }}
{{- end }}

#结果：
#drink: coffee
#food: pizza
```

#### 5.range语句（遍历）
```yaml
{{- range .OBJECT.Name }}
  # restricted scope
{{- end }}

{{- range $key,$val := .OBJECT.Name }}    #不包括.OBJECT.Name
{{key}}: {{val}}                        
{{- end}}
```
demo
>values.yml
```yaml
name:
- liyi
- lier
- lisan
```
>templates/xx.yml
```yaml
{{ range .Values.name }}
- {{ . }}
{{ end }}

#结果：
#- liyi
#- lier
#- lisan
```
#### 6.常见例子
（1）demo1
>values.yml
```yaml
env:
- name: n1
  value: v1
- name: n2
  value: v2
```
>templates/xx.yml
```yaml
{{ range .Values.env }}
  {{ with . }}
  name: {{ .name }}
  value: {{ .value }}
  {{ end }}
{{ end }}

#结果：
#name: n1
#value: v1
#name: n2
#value: v2
```
（2）demo2
>values.yml
```yaml
config:
  test: |
    a: 1
    b: 2
```
>templates/xx.yml
```yaml
{{ range $key,$val := .Values.config }}
{{ $key }}: |
{{ $val | indent 2 }}         #indent 2表示缩进两个空格
{{ end }}

#结果：
#test: |
#  a: 1
#  b: 2
```
***

### 自定义chart

1.创建chart
```shell
helm create xx
```
