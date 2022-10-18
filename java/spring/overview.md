# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [常用注解](#常用注解)
      - [1.容器相关](#1容器相关)
        - [（1）`@Compnent`相关](#1compnent相关)
      - [（2）`@Configuration`相关](#2configuration相关)
    - [使用](#使用)
      - [1.包结构](#1包结构)
    - [配置](#配置)
      - [1.配置的优先级（由高到低）](#1配置的优先级由高到低)
      - [2.配置文件的查找顺序（后面的会覆盖前面的）](#2配置文件的查找顺序后面的会覆盖前面的)

<!-- /code_chunk_output -->

### 常用注解

#### 1.容器相关

##### （1）`@Compnent`相关

|注解|说明|
|-|-|
|`@Component`|注册一个普通组件（即对象）|
|`@Controller`|注册一个控制层组件（用于接收和响应请求，参考spring mvc）|
|`@RestController`|相当于`@Controller` + `@ResponseBody`|
|`@Service`|注册一个业务层组件|
|`@Repository`|注册一个数据库层组件|

* 注册相关

|注解|说明|
|-|-|
|`@Import`|给容器中注册指定组件（即创建对象）|
|`@Conditional*`|满足指定条件，则注册组件|
|`@Autowired`|自动装配（根据类型），自动装配的作用：用户可以使用容器内的组件|
|`@Resource`|自动装配（根据类型或名称）|


* 控制层相关注解

|控制器相关注解|说明|
|-|-|
|`@RequestMapping`|将请求和控制器建立联系，即用于匹配请求（通过路径、参数等），匹配后，该方法就会处理该请求|
|`@ResponseBody`|返回的内容为响应体，如果不加这个，则会寻找相应的文件|
|`@Request*`|将请求相关信息和形参进行绑定|

#### （2）`@Configuration`相关

|注解|说明|
|-|-|
|`@Configuration`|创建配置类（相当于配置文件），结合`@Bean`可以给IoC容器中注册组件（即对象）|
|`@Bean`|注册组件|
|`@ConfigurationProperties`|配置自动绑定|
|`@EnableConfigurationProperties`（需要配合`@ConfigurationProperties`）|自动绑定配置并注册组件|

***

### 使用

#### 1.包结构

```shell
main
+- java
    +- com
        +- example
            +- myapplication
                 +- MyApplication.java       #主程序
                 |
                 +- controller               #存放控制层代码
                 |   +- MyController.java
                 |
                 +- service                  #存放业务层代码
                 |   +- MyServie.java
                 |
                 +- entity                   #存放实体类

    +- resources
        +- application.yml                #配置文件
        |
        +- static                         #静态文件
        |
        +- template                       #模板文件
```

***

### 配置

#### 1.配置的优先级（由高到低）

* 命令行
* java系统属性（`System.getProperties()`）
* 系统环境变量（`System.getEnv()`）
* `bootstrap.yml`
* `<application_name>-<active>.yml`
* `application-<active>.yml`
* `<application_name>.yml`
* `application.yml`

#### 2.配置文件的查找顺序（后面的会覆盖前面的）
* classpath根路径
* classpath下的/config目录
* jar包当前目录
* jar包当前目录下的/config目录
* /config目录的直接子目录
