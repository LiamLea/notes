# spring boot

[toc]

### 概述

#### 1.starter场景启动器
* 官方starter命名: `spring-boot-starter-*`
* 第三方starter命令：`*-spring-boot-starter`
* 主要引入某个starter，这个场景需要的所有常规依赖都会自动引入

#### 包结构

```shell
com
 +- example
     +- myapplication
         +- MyApplication.java       #主程序
         |
         +- customer                 #其他包必须跟主程序在同一级别，才能被扫描到
         |   +- Customer.java
         |   +- CustomerController.java
         |   +- CustomerService.java
         |   +- CustomerRepository.java
         |
         +- order
             +- Order.java
             +- OrderController.java
             +- OrderService.java
             +- OrderRepository.java
```

#### 3.打包


***

### 配置
`application.yml`
