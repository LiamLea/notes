# hystrix

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [hystrix](#hystrix)
    - [使用](#使用)
      - [1.服务端使用服务降级](#1服务端使用服务降级)
        - [（1）引入依赖](#1引入依赖)
        - [（2）在主函数上启用](#2在主函数上启用)
        - [（3）创建相应的fallback方法（即兜底的方法）](#3创建相应的fallback方法即兜底的方法)
        - [（4）使用 设置了fallback方法的 方法](#4使用-设置了fallback方法的-方法)
      - [2.客户端使用服务降级（常用）](#2客户端使用服务降级常用)
        - [（1）引入依赖](#1引入依赖-1)
        - [（2）在主函数上启用](#2在主函数上启用-1)
        - [（3）配置feign](#3配置feign)
        - [（4）调用时使用hystrix](#4调用时使用hystrix)
      - [3.设置默认的服务降级（避免每个方法都要单独设置）](#3设置默认的服务降级避免每个方法都要单独设置)
      - [4.将服务降级和业务逻辑解耦（主要在调用方实现，即feign）](#4将服务降级和业务逻辑解耦主要在调用方实现即feign)
        - [（1）配置feign](#1配置feign)
        - [（2）创建一个类实现feign接口（类中的覆盖方法就是fallback方法）](#2创建一个类实现feign接口类中的覆盖方法就是fallback方法)
      - [5.设置断路器（本质就是服务降级）](#5设置断路器本质就是服务降级)

<!-- /code_chunk_output -->

### 使用

#### 1.服务端使用服务降级

##### （1）引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
    <version>2.2.10.RELEASE</version>
</dependency>
```

##### （2）在主函数上启用
```java
@SpringBootApplication
@EnableEurekaClient
@EnableCircuitBreaker
public class PaymentMain {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain.class, args);
    }
}
```

##### （3）创建相应的fallback方法（即兜底的方法）
当方法执行 超时 或 异常 会调用 fallback方法
* `service/PaymentService`
```java
@Service
public class PayService {

    //指定getPayInfo这个方法的fallback方法：getPayInfoHanlder
    //设置方法超时时间，即当方法执行超过这个时间或者异常，会调用fallback方法
    @HystrixCommand(fallbackMethod = "getPayInfoFallback", commandProperties ={
            @HystrixProperty(name="execution.isolation.thread.timeoutInMilliseconds", value = "3000")
    })
    public String getPayInfo(){
        //int age = 10/0;  //可以用这条语句产生异常
        int sleepTime = 5;
        try{ TimeUnit.SECONDS.sleep(sleepTime); } catch (InterruptedException e) {e.printStackTrace();}
        return "i'm payment service";
    }

    public String getPayInfoFallback() {
        return "Sorry ! payment service is busy, please try later";
    }
}
```

##### （4）使用 设置了fallback方法的 方法
* `controller/PaymentController`

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@RestController
public class PaymentController {

    @Autowired
    private PayService payService;

    @RequestMapping("/pay")
    public String Payment(){
        return payService.getPayInfo();
    }
}
```

#### 2.客户端使用服务降级（常用）
跟服务端基本一样，唯一区别是通过feign的hystrix功能和主函数启用的功能

##### （1）引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
    <version>2.2.10.RELEASE</version>
</dependency>
```

##### （2）在主函数上启用
```java
@SpringBootApplication
@EnableEurekaClient
@EnableFeignClients
@EnableHystrix
public class CustomerMain {
    public static void main(String[] args) {
        SpringApplication.run(CustomerMain.class, args);
    }
}
```

##### （3）配置feign
```yml
feign:
  hystrix:
    enabled: true
```

##### （4）调用时使用hystrix
```java
public class CustomerController {

  //获取feign的客户端
  @Autowired
  private PaymentClient paymentClient;

  @RequestMapping("/customer/payment/get")
  //指定fallback方法和设置超时
  @HystrixCommand(fallbackMethod = "callPaymentServiceFallback",commandProperties = {
          @HystrixProperty(name="execution.isolation.thread.timeoutInMilliseconds", value = "2000")
  })
  public String callPaymentService(){
      System.out.println(user);
      return "call successfully: " + paymentClient.Payment();
  }

  //fallback方法
  public String callPaymentServiceFallback(){
      return "Sorry! timeout for calling payment serice";
  }
}
```

#### 3.设置默认的服务降级（避免每个方法都要单独设置）
```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@RestController
@DefaultProperties(defaultFallback = "customerFallback")
public class CustomerController {

    @Autowired
    private PaymentClient paymentClient;

    @RequestMapping("/customer")
    @HystrixCommand
    public String customerService(){
        return "i'm customer service";
    }

    @RequestMapping("/customer/payment/get")
    @HystrixCommand
    public String callPaymentService(){
        return "call successfully: " + paymentClient.Payment();
    }

    public String customerFallback(){
        return "Sorry! failed";
    }

}
```

#### 4.将服务降级和业务逻辑解耦（主要在调用方实现，即feign）

##### （1）配置feign
```yml
feign:
  hystrix:
    enabled: true
```

##### （2）创建一个类实现feign接口（类中的覆盖方法就是fallback方法）
* `PaymentFallbackService.java`
```java
public class PaymentFallbackService implements PaymentClient{
    @Override
    public String Payment() {
        return "Sorry! failed";
    }
}
```

* `PaymentClient.java`
```java
@Component
@FeignClient(value = "CLOUD-PAYMENT-SERVICE", fallback = PaymentFallbackService.class)
public interface PaymentClient {
    @RequestMapping("/pay")
    public String Payment();
}
```

#### 5.设置断路器（本质就是服务降级）
```java
public class CustomerController {

  //获取feign的客户端
  @Autowired
  private PaymentClient paymentClient;

  @RequestMapping("/customer/payment/get")
  //指定fallback方法和设置超时
  @HystrixCommand(fallbackMethod = "callPaymentServiceFallback",commandProperties = {
          @HystrixProperty(
            circuitBreaker.enabled=true
            metrics.rollingStats.timeInMilliseconds=10000
            circuitBreaker.requestVolumeThreshold=20
            circuitBreaker.errorThresholdPercentage=50
            circuitBreaker.sleepWindowInMilliseconds=5000
          )
  })
  public String callPaymentService(){
      System.out.println(user);
      return "call successfully: " + paymentClient.Payment();
  }

  //fallback方法
  public String callPaymentServiceFallback(){
      return "Sorry! timeout for calling payment serice";
  }
}
```

* 上述断路器说明
  * 统计的时间窗口为10s，在10s时间内，
    * 如果请求数量达到20个，并且错误率达到50%，则开启断路器
  * 断路器开启后，经过5s，断路器进入半开模式
