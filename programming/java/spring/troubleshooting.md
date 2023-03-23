# debug

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [debug](#debug)
      - [1.使用actuator](#1使用actuator)
        - [（1）引入依赖](#1引入依赖)
        - [（2） 配置（开启actuator所有的endpoints）: application.yml](#2-配置开启actuator所有的endpoints-applicationyml)
        - [（3）查看所有的endpoints（包括配置、路由等）](#3查看所有的endpoints包括配置-路由等)

<!-- /code_chunk_output -->

#### 1.使用actuator

##### （1）引入依赖
```shell
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

##### （2） 配置（开启actuator所有的endpoints）: application.yml
```yml
management:
  endpoints:
    enabled-by-default: true
    web:
      exposure:
        include: "*"
```

##### （3）查看所有的endpoints（包括配置、路由等）
```shell
curl <ip>:<port>/actuator
```

* 查看该应用的配置
```shell
curl <ip>:<port>/actuator/env
```

* 查看路由信息
```shell
curl <ip>:<port>/actuator/gateway/routedefinitions
```
