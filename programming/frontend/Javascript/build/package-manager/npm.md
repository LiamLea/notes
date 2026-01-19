# npm


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [npm](#npm)
    - [概述](#概述)
      - [1.nodejs](#1nodejs)
      - [2.npm和yarn](#2npm和yarn)
      - [3.包管理配置文件：`package.json`](#3包管理配置文件packagejson)
      - [4.npm缓存：`~/.npm`](#4npm缓存npm)
    - [安装](#安装)
      - [1.安装nodejs](#1安装nodejs)
        - [2.nvm能够管理不同版本的nodejs](#2nvm能够管理不同版本的nodejs)
    - [配置文件](#配置文件)
      - [1.generate `package.json`](#1generate-packagejson)
        - [(1) init](#1-init)
        - [(2) add dev dependencies](#2-add-dev-dependencies)
      - [2.`package.json`](#2packagejson)
    - [npm和yarn使用](#npm和yarn使用)
      - [1.yarn和npm区别](#1yarn和npm区别)
      - [2.安装yarn](#2安装yarn)
      - [3.npm命令（优先使用yarn）](#3npm命令优先使用yarn)
        - [(1) `npm run build`](#1-npm-run-build)
        - [(2) `npm install`](#2-npm-install)
        - [(3) `npm start`](#3-npm-start)
        - [(4) 一般用法](#4-一般用法)
        - [(5) `yarn <script> [<args>]`](#5-yarn-script-args)
    - [node使用](#node使用)
      - [1.运行javascript](#1运行javascript)

<!-- /code_chunk_output -->


### 概述

#### 1.nodejs
cross-platform JavaScript runtime environment（类似于JVM）

#### 2.npm和yarn
* npm是nodejs的包管理工具，用于管理javascript模块
* yarn比npm更强大

#### 3.包管理配置文件：`package.json`
* `package.json`这个文件在 项目目录 下
* `npm install`会根据这个文件下载相应的包到项目中的`node_modules`目录下

#### 4.npm缓存：`~/.npm`
* 安装的包都会在此目录下进行缓存

***

### 安装

#### 1.安装nodejs
[参考](https://nodejs.org/en/download/package-manager)

```shell
# 用户需要有~/.profile等文件

# 根据操作系统，选择指定的nvm安装脚本
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

#重新打开shell

# 安装指定版本的nodejs
nvm install <version>

# 验证
node -v
npm -v
```

##### 2.nvm能够管理不同版本的nodejs
```shell
#列出所有版本nodejs
nvm ls

#安装指定版本
nvm install <version>

#切换
nvm use <version>
```

***

### 配置文件

#### 1.generate `package.json`

##### (1) init
```shell
yarn init -y
```

##### (2) add dev dependencies
* what you need to build the application to the point where then it can run
```shell
yarn add -D <packge_name>
```
* example:
  * add typescript
  ```shell
  yarn add -D typescript
  ```
  * use typescript compiler
  ```shell
  yarn tsc --help
  ```


#### 2.`package.json`
```json
{
  //定义command，当执行 npm run command1 时，就会执行 ls /tmp/命令
  "scripts": {
    "command1": "ls /tmp",
    "command2": "ls /"
  }
}
```

***

### npm和yarn使用

#### 1.yarn和npm区别

* Yarn uses a lockfile (`yarn.lock`) to lock down the versions of a project’s dependencies
* NPM also uses a lockfile, but it’s not as strict as Yarn’s

#### 2.安装yarn
```shell
npm i -g yarn
```

#### 3.npm命令（优先使用yarn）
npm可能会导致依赖有问题，从而build不成功，所以使用yarn

##### (1) `npm run build`
* 会根据`package.json`中的build参数，执行build的内容
* 如果缺少依赖会失败

##### (2) `npm install`
* 根据`package.json`的配置，将依赖下载到`./node_modules/`目录下
```shell
# 设置proxy
#   不同的modules的方式可能不同，需要根据失败信息，查看相关module的资料（比如electron: ELECTRON_GET_USE_PROXY="http://127.0.0.1:1095"）
npm install
```

* 将指定包下载到`./node_modules/`目录
```shell
npm install <package>
```

* 将包下载到全局
```shell
npm install -g <package>
```

##### (3) `npm start`
可以运行程序，不需要构建，修改代码代码也不需要重启，会自动加载（利用nodemon的能力）

##### (4) 一般用法

```shell
#安装依赖
yarn install

#构建（package.json中需要有build）
yarn build

#打包（package.json中需要有<package_command>）
yarn <package_command>
```

##### (5) `yarn <script> [<args>]`

* first search `<script>` in User-defined script in `package.json`
* if not find, then use Locally installed CLIs `<script>`
  * it can be installed through `devDependencies` in `package.json`

***

### node使用

#### 1.运行javascript
```shell
node  <javescript>
```
