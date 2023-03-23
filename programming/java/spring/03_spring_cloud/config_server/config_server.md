# config server

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [config server](#config-server)
    - [server端使用](#server端使用)
      - [1.引入依赖](#1引入依赖)
      - [2.创建配置文件: `config-repo/application.yml`](#2创建配置文件-config-repoapplicationyml)
      - [3.配置config server](#3配置config-server)
      - [4.主函数](#4主函数)
    - [client端使用](#client端使用)
      - [1.引入依赖](#1引入依赖-1)
      - [2.配置client: `bootstrap.yml`](#2配置client-bootstrapyml)
      - [3.验证](#3验证)

<!-- /code_chunk_output -->

### server端使用

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-server</artifactId>
</dependency>
```

#### 2.创建配置文件: `config-repo/application.yml`
```yml
info: "aaaaa"
```

#### 3.配置config server
```yml
server:
  port: 8888

spring:
  profiles:
    include: native
  cloud:
    config:
      server:
        native:
          search-locations: classpath:/config-repo
management:
  endpoints:
    enabled-by-default: true
    web:
      exposure:
        include: "*"
```

#### 4.主函数
```java
@SpringBootApplication
@EnableConfigServer
public class ConfigMain {
    public static void main(String[] args) {
        SpringApplication.run(ConfigMain.class, args);
    }
}
```

***

### client端使用

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-client</artifactId>
</dependency>
```

#### 2.配置client: `bootstrap.yml`
```yml
server:
  port: 8889
spring:
  application:
    name: config-client
  cloud:
    config:
      uri: http://localhost:8888
      fail-fast: true
  profiles:
    active: dev
```

#### 3.验证
* `controller/ConfigClientController`
```java
@RestController
public class ConfigClientController {
    @Value("${info}")
    private String configInfo;
    @RequestMapping("/hello")
    public String get_config(){
        return configInfo;
    }
}
```

* 启动后，访问：`127.0.0.1:8889/hello`验证
