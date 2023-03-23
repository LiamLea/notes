# spring boot

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [spring boot](#spring-boot)
    - [概述](#概述)
      - [1.场景启动器: starter](#1场景启动器-starter)
        - [（1）作用：](#1作用)
        - [（2）原理](#2原理)
      - [2.spring boot启动过程](#2spring-boot启动过程)
        - [（1）创建SpringApplication](#1创建springapplication)
        - [（2）运行SpringApplication](#2运行springapplication)

<!-- /code_chunk_output -->

### 概述

#### 1.场景启动器: starter

* 官方starter命名: `spring-boot-starter-*`
* 第三方starter命令：`*-spring-boot-starter`

##### （1）作用：
* 做一些配置化操作，比如创建一些组件等

##### （2）原理

* 引入相应的starter
* 该starter会调用其定义的 自动配置功能
  * `META-INF/spring.factories`指定加载哪些自动配置类
* 自动配置功能依赖spring-boot-starter实现

#### 2.spring boot启动过程

```java
//相当于SpringBootConfiguration EnableAutoConfiguration + ComponentScan
//表示进行springboot的自动配置
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
        //运行spring应用
        //返回的是一个IoC容器
        SpringApplication.run(MainApplication.class, args);
    }
}
```

##### （1）创建SpringApplication

注意下面要寻找的内容都在：`META-INF/spring.factories`中
* 保存一些信息
* 判断当前应用类型（比如: servlet）
* 寻找 启动引导器（bootstrappers）
* 寻找 应用初始化器（ApplicationCOntextInitializers）
* 寻找 应用监听器（ApplicationListeners）
  * 应用监听器就是一种事件触发机制，当启动到某一个过程，会调用相应的监听器，从而触发相应的动作
  * 每个模块都可以自定义监听器，都会被spring找到，到时候会触发

##### （2）运行SpringApplication

* 创建引导上下文: createBootstrapContext
  * 让启动引导器依次执行
* 准备环境： prepareEnvironment
* 创建IoC容器: createApplicationContext
  * 根据当前应用类型（比如：servlet）
* 准备IoC容器的信息：prepareContext
  * 让应用初始化器依次执行
* 刷新IoC容器: refreshContext
  * 创建容器中的所有组件
* 调用所有runners: callRunners
  * 用于在springboot加载完毕后，执行一些代码
  * 有两类：ApplicationRunner和CommandlineRunner

* 返回IoC容器
