# hystrix

[toc]

### 概述

#### 1.hystix

##### （1）what
是一个用于处理分布式系统的 延迟 和 容错 的开源库
能够保障一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性

* 服务降级（fallback）
* 服务熔断（circuit break）
* 服务限流（flowlimit）

##### （2）why

* 场景一：
  用户同时调用 A、B、C、D这几个服务，其中C服务响应非常慢，会导致整个系统的性能下降，从而导致其他服务的性能下降
* 场景二：
  用户调用A，A->B->C->D，其中C服务响应非常慢，当有更多用户请求过来时，会将A和B的资源占满，导致系统崩溃

#### 2.原则：设置在消费侧（即调用方）

#### 3.服务降级（fallback）

##### （1）发生的条件
* 运行异常
* 超时
* 服务熔断触发服务降级
* 线程池/信号量打满触发服务降级

#### 4.服务熔断（circuit breaker）
当链路的某个微服务出错或或者响应时间过长，会进行服务的降级，进而熔断该节点微服务的调用，快速返回错误的响应信息
当检测到该服务调用响应正常后，恢复调用链路

##### （1）断路器状态

|断路器状态|说明|
|-|-|
|closed|断路器关闭，允许所有请求通过|
|open|断路器打开，直接执行fallback方法，不去调用服务端|
|half-open|经过一段时间，让一个请求通过，如果成功，则切换为closed状态，如果失败，则切换为open状态|

##### （2）断路器相关参数
* 快照时间窗
  * 统计在这个时间窗内的请求和错误数据，从而决定断路器的状态
  * 默认10s: default_metricsRollingStatisticalWindow = 10000
* 请求总数阈值
  * 在快照时间窗内，必须满足请求总数阈值才有资格熔断
  * 默认为20: default_circuitBreakerRequestVolumeThreshold = 20
* 错误百分比阈值
  * 错误率达到这个阈值，才会打开断路器
  * 默认为50%: default_circuitBreakerErrorThresholdPercentage = 50
* 睡眠时间
  * open状态，经过这么长时间，会进入half-open状态，允许一个请求通过
  * 默认5s: default_circuitBreakerSleepWindowInMilliseconds = 5000

##### （3）断路器工作原理
![](./imgs/hystrix_01.jpg)

* 断路器初始为closed状态
* closed状态下
  * 失败的情况 超过 设置的阈值 则将断路器切换为open状态
  * 否则一直处于closed状态
* open状态下
  * 经过一段时间切换为half-open状态
* half-open状态下
  * 会允许一个请求通过
  * 如果该请求成功，则切换为closed状态
  * 如果该请求失败，则切换为open状态

***

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
