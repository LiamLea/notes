# eureka

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [eureka](#eureka)
    - [服务端](#服务端)
      - [1.单机版](#1单机版)
        - [（1）引入依赖: `pom.xml`](#1引入依赖-pomxml)
        - [（2）配置: `application.yml`](#2配置-applicationyml)
      - [（3）在主函数上启用eureka server](#3在主函数上启用eureka-server)
      - [2.集群版本](#2集群版本)
      - [3.自我保护模式](#3自我保护模式)
    - [客户端](#客户端)
      - [1.引入依赖](#1引入依赖)
      - [2.配置: `application.yml`](#2配置-applicationyml-1)
      - [4.在主函数上启用eureka client](#4在主函数上启用eureka-client)
      - [5.使用注册中心中注册的地址](#5使用注册中心中注册的地址)
      - [6.相关配置](#6相关配置)

<!-- /code_chunk_output -->

### 服务端

#### 1.单机版

##### （1）引入依赖: `pom.xml`
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

##### （2）配置: `application.yml`
```yaml
server:
  port: 7001
eureka:
  instance:
    #实例名称
    hostname: localhost
  client:
    #表示不向注册中心注册自己
    register-with-eureka: false
    #表示自己不从Eureka Server获取注册的服务信息
    fetch-registry: false
```

#### （3）在主函数上启用eureka server
```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaMain {
    public static void main(String[] args) {
        SpringApplication.run(EurekaMain.class, args);
    }
}
```

#### 2.集群版本
原理：启动多个eureka，互相注册，其他步骤基本相同，主要是每个eureka的配置文件

```yaml
eureka:
  instance:
    #实例名称
    hostname: localhost
  client:
    #表示不向注册中心注册自己
    register-with-eureka: false
    #表示自己不从Eureka Server获取注册的服务信息
    fetch-registry: false

    #设置其他eureka的地址（如果有多个用逗号隔开）
    service-url:
      defaultZone: http://localhost:7001/eureka
```

#### 3.自我保护模式
保护模式：即某个服务没有给eureka发送信息，eureka不会立即（默认90s）删除注册表中的注册信息（会额外等待一段时间）

***

### 客户端

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

#### 2.配置: `application.yml`
```yaml
spring:
  application:
    name: cloud-customer-service
eureka:
  client:
    #表示是否将自己注册eureka
    register-with-eureka: true
    #是否获取注册列表
    fetch-registry: true
    #设置eureka的地址（当eureka是集群中，用逗号隔开，写多个地址 ）
    service-url:
      defaultZone: http://localhost:7001/eureka

  instance:
    #实例名称
    instance-id: customer-service-01
    #是否显示ip，即把鼠标放在实例名称上，左下角会出现ip
    prefer-ip-address: true
```

#### 4.在主函数上启用eureka client
```java
@SpringBootApplication
@EnableEurekaClient
public class CustomerMain {
    public static void main(String[] args) {
        SpringApplication.run(CustomerMain.class, args);
    }
}
```

#### 5.使用注册中心中注册的地址
直接使用`application.name`的大写，会自动转换成地址+端口号，比如：
```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@RestController
public class CustomerController {


    @Autowired
    private RestTemplate restTemplate;

    @RequestMapping("/customer/payment/get")
    public String callPaymentService(){
        //使用eureka之前: http://127.0.0.1:8081/pay
        String msg = restTemplate.getForObject("http://CLOUD-PAYMENT-SERVICE/pay", String.class);
        System.out.println(user);
        return "call successfully: " + msg;
    }

}
```

* 调用组件需要加上LoadBalancer（否则当CLOUD-PAYMENT-SERVICE这个application有多个实例时，会报错）
```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    @LoadBalanced
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }
}
```


#### 6.相关配置
* 心跳配置
```yml
eureka:
  instance:
    #多久像eureka发送一次心跳（默认：30s）
    lease-renewal-interval-in-seconds: 30
    #收到最后一次心跳，隔多久踢出该instance（默认：90s）
    lease-expiration-duration-in-seconds: 90
```
