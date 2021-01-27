### 概述

#### 1.环境变量
* 工作目录：`$GOPATH`

#### 2.目录结构
* `$GOPATH/src`
  * 用来存放源码文件
  * src下面可以创建多层子目录
* `$GOPATH/bin`
用来存放编译后生成的可执行文件
* `$GOPATH/pkg`
用来存放编译后生成的归档

##### 3.编译
```shell
go build <PROJECT_PATH>
#不是绝对路径，这里写相对路径，即在src目录下的路径
-o <EXEC_FILE_NAME>   #o:objective，生成可执行文件的名字
```

* `go install`
有两步，先执行go build，然后将可执行文件移动到`$GOPATH/bin/`目录下

* `go run`
像脚本一样执行代码

***

### 使用
#### 1.查看环境变量
```shell
go env
```
#### 2.包管理
* 安装包
```shell
go get <URL>
```
或者将包移入`$GOPATH/src`目录下
