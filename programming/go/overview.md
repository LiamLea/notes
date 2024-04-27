# go

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [go](#go)
    - [概述](#概述)
      - [1.环境变量](#1环境变量)
      - [2.两种包的管理模式](#2两种包的管理模式)
        - [（1）GOPATH模式（1.11版本之前）](#1gopath模式111版本之前)
        - [（2）module模式（1.11版本之后）](#2module模式111版本之后)
      - [3.`go.mod`文件格式](#3gomod文件格式)
      - [4.一个go项目中必须存在以下文件：](#4一个go项目中必须存在以下文件)
      - [5.go包管理结构](#5go包管理结构)
      - [6.编译（全部基于module模式）](#6编译全部基于module模式)
    - [使用（基于module模式）](#使用基于module模式)
      - [1.查看和修改环境变量](#1查看和修改环境变量)
      - [2.模块管理](#2模块管理)
      - [3.module使用](#3module使用)
    - [项目包结构](#项目包结构)

<!-- /code_chunk_output -->

### 概述

#### 1.环境变量
```shell
#sdk所在目录（即go程序所在的目录）
GOROOT=/usr/local/go

#工作目录
GOPATH=/root/go

#是否开启go的module功能（用于管理依赖的包和依赖的版本）
#一定要开启
GO111MODULE=on
#能够获取当期所在项目的go.mod文件的绝地路径
#如果不在任何项目的目录中，则显示为/dev/null，即未检测到
#比如：cd /tmp/sample-controller-master/，然后执行go env，就会看到
GOMOD=/tmp/sample-controller-master/go.mod

#指定下载go包的代理地址（默认地址需要翻墙，可以换成阿里云的）
#direct表示，如果再代理地址中没有找到包，则去原始路径寻找
#比如要下载github.com/kubernetes/sample-controller这个包，如果在代理地址没找到，会去github.com找
#GOPROXY=https://proxy.golang.org,direct
GOPROXY=https://goproxy.cn

#设置用于检测包的校验和的地址（当设置了代理，这里就会默认去代理地址校验）
GOSUMDB=sum.golang.org

#指定私有go的仓库
#比如下面表示下载*.example.com或go.local.com的包，不用去代理地址下载
#GONOPROXY和GONOSUMDB与下面的效果一样，只要设置其中一个即可
GOPRIVATE=*.example.com,go.local.com
```

#### 2.两种包的管理模式
`<module_name>`是一个模块的名称，也是一个相对路径，所以下载后存放的路径跟这里的名称有关

##### （1）GOPATH模式（1.11版本之前）
无法管理依赖的包的版本
通过`go get <module_name>`会下载该模块的最新源码到`$GOPATH/src/`目录下

##### （2）module模式（1.11版本之后）
需要开启go的module功能
通过`go.mod`这个文件管理依赖的包和依赖的版本
通过`go get <module_name>`会下载该模块的最新源码到`$GOPATH/pkg/mod/`目录下，并更新`go.mod`文件
如果`go.mod`文件已经都写好了，且不需要更新，则执行build等命令时，会自动下载依赖的包到`$GOPATH/pkg/mod/`目录下

#### 3.`go.mod`文件格式
```shell
#<module_name>实际上就是一个相对路径
#比如：github.com/my_mod
#则get该module后，会存放在 $GOPATH/pkg/mod/github.com/my_mod/ 目录下
module <module_name>

go <go_version>

#列出依赖的模块和指定的版本
require (
        k8s.io/api v0.0.0-20210917114730-87c4113e35a1
        k8s.io/apimachinery v0.0.0-20210917114041-87fb71e8a0dc
)

#替换 依赖的模块和依赖的 版本
#比如： k8s.io/api => k8s.io/api_test v0.0.1-20210917114730-87c4113e35a2
#替换后，表示不依赖k8s.io/api，而依赖k8s.io/api_test，具体版本为v0.0.1-20210917114730-87c4113e35a2
replace (
        k8s.io/api => k8s.io/api v0.0.0-20210917114730-87c4113e35a1
        k8s.io/apimachinery => k8s.io/apimachinery v0.0.0-20210917114041-87fb71e8a0dc
)

```

#### 4.一个go项目中必须存在以下文件：
* main包（即`package main`的go文件）
  * 且必须包含main函数
* `go.mod`
* `go.sum`

#### 5.go包管理结构
* `$GOPATH/src/`（GOPATH模式）
  * 用来存放源码包（没有版本控制）
* `$GOPATH/bin/`
用来存放编译后生成的可执行文件
* `$GOPATH/pkg/mod/`（module模式）
  * 用来存放源码包（有版本控制）

#### 6.编译（全部基于module模式）

```shell
cd <go_project>

#o:objective，生成可执行文件的名字
#<go_file>如果不指定，则会选择当前目录下的所有.go文件
go build -o <EXEC_FILE_NAME>  <go_file>   

#有两步，先执行go build，然后将可执行文件移动到`$GOPATH/bin/`目录下
go install

#像脚本一样执行代码
go run <main_package>
```

***

### 使用（基于module模式）

#### 1.查看和修改环境变量
```shell
go env

go env -w <VARIABLE>=<VALUE>
```

#### 2.模块管理
* 安装模块（最新版本）
```shell
#-u并且下载该module相关依赖
go get -u -v <module_name>
```

#### 3.module使用
```shell
#会在当前路径下，创建一个go.mod文件
go mod init <module_name>

#检查代码中的依赖 更新go.mod文件
go mod tidy

#下载所需要的module
go mod download -x

#列出依赖的module
go mod graph
```

***

### 项目包结构

[参考](https://github.com/golang-standards/project-layout)

```shell
<packeage_name>/
 +- cmd/                         #主程序
     |
     +- main.go                  #主程序入口
     |
     +- xx/                      #主程序代码

 +- pkg/                         #代码库
     +- controller/              #存放控制层代码
     |   +- xx_yy.go
     |
     +- service/                 #存放业务层代码
     |   +- xx_yy.go
     |
     +- dao/                     #存放数据库操作代码
     |   +- xx_yy.go
     |
     +- model/                   #存放实体类（java项目中一般用entity目录）

 +- api/                         #对外提供的API
 
 +- go.mod                       #依赖管理
```
