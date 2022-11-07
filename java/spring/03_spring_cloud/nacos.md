# nacos

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [nacos](#nacos)
    - [概述](#概述)
      - [1.nacos](#1nacos)
        - [（1）what](#1what)
      - [2.端口（2.0有变化）](#2端口20有变化)
    - [部署](#部署)
      - [1.安装](#1安装)
        - [（1）单机模式](#1单机模式)
        - [（2）使用mysql（以单机模式为例）](#2使用mysql以单机模式为例)
        - [（3）集群模式（至少三个节点）](#3集群模式至少三个节点)
    - [客户端使用](#客户端使用)
      - [1.注册中心](#1注册中心)
        - [（1）引入依赖](#1引入依赖)
        - [（2）修改配置](#2修改配置)
        - [（3）主函数](#3主函数)
      - [（4）调用：相应服务名（区分大小写）](#4调用相应服务名区分大小写)
      - [2.配置中心](#2配置中心)
        - [（1）引入依赖](#1引入依赖-1)
        - [（2）配置: `bootstrap.yml`](#2配置-bootstrapyml)
        - [（3）nacos中配置文件命名规则（优先级由高到低）](#3nacos中配置文件命名规则优先级由高到低)
        - [（4）主函数](#4主函数)
        - [（5）配置更新](#5配置更新)

<!-- /code_chunk_output -->

### 概述

#### 1.nacos

##### （1）what
nacos = eureka + config + bus

* 注册中心（自带负载均衡）
* 配置中心
* 消息总线

#### 2.端口（2.0有变化）

|端口|说明|
|-|-|
|8848|1.0：客户端注册到服务端的这个端口|
|9848|2.0：客户端注册到服务端的这个端口（grpc）|
|9849|2.0：服务端互相通信的端，即集群（grpc）

* 注意客户端使用时，不能直接指定grpc的端口，grpc的端口在server-addr端口上默认加1000
  * 比如：grpc端口为19848
  ```shell
  #只能指定server-addr，然后加1000
  --spring.cloud.nacos.discovery.server-addr=10.10.10.250:18848
  ```

***

### 部署

#### 1.安装

##### （1）单机模式

```shell
docker run --name nacos-quick \
  -e MODE=standalone \
  -p 8848:8848 -p 9848:9848 -p 9849:9849 \
  -d nacos/nacos-server:2.0.2
```

#####（2）使用mysql（以单机模式为例）
```shell
docker run --name nacos-quick \
  -e MODE=standalone \
  -p 8848:8848 -p 9848:9848 -p 9849:9849 \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e MYSQL_SERVICE_HOST=10.10.10.163 -e MYSQL_SERVICE_PORT=32809 \
  -e MYSQL_SERVICE_DB_NAME=nacos -e MYSQL_SERVICE_USER=root \
  -e MYSQL_SERVICE_PASSWORD=cangoal \
  -d nacos/nacos-server:2.0.2
```

##### （3）集群模式（至少三个节点）
存在bug: 如果一个节点，即使注册上了服务列表也为空
```shell
docker run --name nacos-quick \
  -e MODE=cluster -e NACOS_SERVERS="10.10.10.250:8848 10.10.10.251:8848 10.10.10.252:8848" \
  -p 8848:8848 -p 9848:9848 -p 9849:9849 \
  -d nacos/nacos-server:2.0.2
```

***

### 客户端使用

#### 1.注册中心

##### （1）引入依赖
```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

##### （2）修改配置
```yml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848
```

##### （3）主函数
```java
@SpringBootApplication
@EnableDiscoveryClient
public class PaymentMain {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain.class, args);
    }
}
```

#### （4）调用：相应服务名（区分大小写）

#### 2.配置中心

##### （1）引入依赖
```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

##### （2）配置: `bootstrap.yml`
```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848
      config:
        prefix: cloud   #如果不加，默认为application name
        server-addr: 127.0.0.1:8848
        file-extension: yaml
```

##### （3）nacos中配置文件命名规则（优先级由高到低）
* `<prefix>-<active>.<file-extension>`
* `<prefix>.<file-extension>`

##### （4）主函数
```java
@SpringBootApplication
@EnableDiscoveryClient
public class ConfigClientMain {
    public static void main(String[] args) {
        SpringApplication.run(ConfigClientMain.class, args);

    }
}
```

##### （5）配置更新

* 使用`@RefreshScope`注解
```java
@RestController
@RefreshScope
public class ConfigClientController {

    @Value("${info}")
    private String configInfo;

    @RequestMapping("/hello")
    public String get_config(){
        return configInfo;
    }
}
```

* 修改nacos中的配置文件，会立即生效
