# gateway

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [gateway](#gateway)
    - [概述](#概述)
      - [1.gateway](#1gateway)
        - [（1）特性](#1特性)
      - [2.工作原理](#2工作原理)
      - [3.路由](#3路由)
        - [（1）predicates（断言：用于匹配请求）](#1predicates断言用于匹配请求)
        - [（2）filters（过滤器：用于处理请求或响应）](#2filters过滤器用于处理请求或响应)
    - [使用](#使用)
      - [1.引入依赖](#1引入依赖)
      - [2.配置路由](#2配置路由)
        - [（1）静态路由](#1静态路由)
        - [（2）动态路由（需要注册中心）](#2动态路由需要注册中心)
      - [3.设置全局过滤器](#3设置全局过滤器)

<!-- /code_chunk_output -->

### 概述

#### 1.gateway

提供一种简单而有效的方式对API进行路由，以及提供一些强大的过滤器功能（比如：熔断、限流 、重试、安全、监控、鉴权等）

##### （1）特性
* 动态路由
* 对路由进行过滤
* 集成hystrix断路器功能
* 集成服务发现功能
* 限流功能
* 支持路径重写

#### 2.工作原理
![](./imgs/gateway_01.png)

#### 3.路由

##### （1）predicates（断言：用于匹配请求）
[参考](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#gateway-request-predicates-factories)

##### （2）filters（过滤器：用于处理请求或响应）
常用自定义全局filter:
* 全局日志记录
* 统一网关鉴权
* ...

***

### 使用

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
```

#### 2.配置路由

##### （1）静态路由
```yml
spring:
  application:
    name: cloud-gateway-service
  cloud:
    gateway:
      routes:
        - id: payment_route_1
          #静态路由，地址写死
          uri: http://localhost:8081
          #断言：用于设置匹配条件
          predicates:
            - Path=/payment/**
```

##### （2）动态路由（需要注册中心）
* 默认将服务名作为路由地址: `<gateway_ip>:<gateway_port>/<application_name>/<api>`
  * 比如：`127.0.0.1:9527/cloud-payment-service/payment/pay`
  * 这个请求会被路由到，注册名为`cloud-payment-service`的`/payment/pay`这个api
    * 如果没有设置`lowerCaseServiceId: true`，就需要这样访问：`127.0.0.1:9527/CLOUD-PAYMENT-SERVICE/payment/pay`
```yml
spring:
  application:
    name: cloud-gateway-service
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          lowerCaseServiceId: true
      #也可以明确指定路由规则
      # routes:
      #   - id: payment_route_1
      #     #lb代表使用负载均衡（即LoadBalancer）
      #     #cloud-payment-service在注册中心注册的应用名
      #     uri: lb://cloud-payment-service  
      #     #断言：用于设置匹配条件
      #     predicates:
      #       - Path=/payment/**
```

#### 3.设置全局过滤器
* `com/example/filter/AuthFilter.java`
```java
@Component
public class AuthFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String uname = exchange.getRequest().getQueryParams().getFirst("name");
        if(! Objects.equals(uname, "liyi")){
            exchange.getResponse().setStatusCode(HttpStatus.NOT_ACCEPTABLE);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }

    //设置该filter优先级，数字越小，优先级越高
    @Override
    public int getOrder() {
        return 0;
    }
}
```

* 测试
```shell
curl http://127.0.0.1:9527/payment/pay?name=liyi
curl http://127.0.0.1:9527/payment/pay?name=xx
```
