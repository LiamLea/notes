# OpenFeign

[toc]

### 概述

#### 1.OpenFeign

##### （1）what
是一个 声明式 的web服务 客户端

##### （2）why
因为被依赖服务的接口会被多处调用，所以要在每个服务中封装一些客户端类来包装它依赖的服务的调用
简化了对其他服务的调用

##### （3）集成了LoadBalancer
会自动使用LoadBalancer，不需要明确指定

***

### 使用

#### 1.基本使用

##### （1）引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-loadbalancer</artifactId>
</dependency>
```

##### （2）在主函数上启用feign
```java
@SpringBootApplication
@EnableEurekaClient
@EnableFeignClients
public class CustomerMain {
    public static void main(String[] args) {
        SpringApplication.run(CustomerMain.class, args);
    }
}
```

##### （3）创建feign接口

* cloud-payment-service服务中定义的接口

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@RestController
public class PaymentController {

    private Integer Id;
    @RequestMapping("/pay")
    public String Payment(){
        return "i'm payment service";
    }

}
```

* 创建feign接口: `com.example.feign.xxClient`

```java
@Component
@FeignClient(value = "CLOUD-PAYMENT-SERVICE")   //需要调用的服务名
public interface PaymentClient {
    //可以将相应服务的所有接口都封装进行，之后可以通过该client可以直接调用
    //下面只封装了一个/pay接口

    @RequestMapping("/pay")         //需要调用的服务url
    public String Payment();        //需要调用的服务方法
}
```

##### （4）使用feign接口

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@RestController
public class CustomerController {

    @Autowired
    private PaymentClient paymentClient;      //获取指定feignclient（即feign接口，对应一个指定服务），将API调用的细节给屏蔽了，只要关注对应服务的某些接口就行了

    @RequestMapping("/customer/payment/get")
    public String callPaymentService(){
        System.out.println(user);
        return "call successfully: " + paymentClient.Payment();   //通过client直接调用对应服务的某些接口
    }
}
```

#### 2、feign的超时时间设置（默认1s）
```yaml
feign:
  client:
    config:
      default:
        #超时时间默认为1s
        #建立连接所用的时间，适用于网络状况正常的情况下，两端连接所需要的时间
        ConnectTimeOut: 10000
        #指建立连接后从服务端读取到可用资源所用的时间
        ReadTimeOut: 10000
```
