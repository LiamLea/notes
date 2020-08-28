# npm
[toc]

### 概述

#### 1.特点
* npm是随同node.js 一起安装的包管理工具
* 必须先安装node.js（`node -v`查看node.js的版本）

#### 2.包管理配置文件：`package.json`
* `package.json`这个文件在 项目目录 下
* `npm install`会根据这个文件下载相应的包到项目中的`node_modules`目录下

#### 3.npm缓存：`~/.npm`
* 安装的包都会在此目录下进行缓存

***

### 使用
#### 1.离线安装包
将 指定包 解压到 指定项目的 `node_modules`目录下
