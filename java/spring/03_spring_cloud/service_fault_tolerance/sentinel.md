# sentinel

[toc]

### 使用

#### 1.部署sentinel dashboard

```shell
docker run --name sentinel  -d -p 8858:8858 -d  bladex/sentinel-dashboard
```

* 注意：
  * dashboard所在机器必须和服务所在机器 时钟同步

#### 1.基本使用

##### （1）引入依赖
```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>


<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

#### （2）配置
```yaml
spring:
  cloud:
    sentinel:
      transport:
        #指定sentinel dashboard地址
        dashboard: 192.168.6.111:8858

        #设置sentinel服务监听的地址（要保证dashboard能够连接到这个地址）
        port: 8719
        client-ip: 192.168.6.1

      #默认为false，即懒加载，即服务被访问，才会有相关信息
      eager: true
```

##### （3）测试
```java
@RestController
public class SentinelController {

    @RequestMapping("/sentinel/testA")
    public String testA(){
        return "AAAAAAAAA";
    }

    @RequestMapping("/sentinel/testB")
    public String testB(){
        return "BBBBBBBB";
    }
}
```

* 访问这两个测试接口
* 访问dashboard就能查看到实施监控

#### 3.设置流控规则
通过dashboard进行配置，参考其他文档
* 当违反设置的规则，会触发BlockException处理函数（注意和fallback函数区分）
  * fallback函数是当程序执行错误、超时等才会触发

#### 4.设置通用 BlockException处理函数 和 fallback函数

#####（1）设置BlockException处理函数
* `handler/MyExceptionHandler.java`
```java
public class MyExceptionHandler {

    //必须为static方法
    public static String handleBlockException_1(BlockException ex){
        return "sorry! BlockException";
    }
}
```

##### （2）设置 fallback函数
* `fallback/MyFallback.java`
```java
public class MyFallback {

    //必须为static方法
    public static String fallback_1(){
        return "sorry! fallback";
    }
}
```

##### （3）使用

* 当违反设置的规则，会触发BlockException处理函数
* 当程序执行错误、超时等，会触发fallback函数
  * 即使触发fallback，也会进行流控统计，不影响触发BlockException处理函数

```java
@RestController
public class SentinelController {

    @RequestMapping("/sentinel/testA")
    @SentinelResource(value = "testA",
            blockHandlerClass = MyExceptionHandler.class ,blockHandler = "handleBlockException_1",
            fallbackClass = MyFallback.class, fallback = "fallback_1"
    )
    public String testA(){
        int a = 10/0;
        return "AAAAAAAAA";
    }
}
```

#### 5.将服务降级和业务逻辑解耦（主要在调用方实现，即feign）

##### （1）配置feign
```yml
feign:
  sentinel:
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


#### 6.规则持久化（nacos）

* 添加依赖
```xml
<dependency>
    <groupId>com.alibaba.csp</groupId>
    <artifactId>sentinel-datasource-nacos</artifactId>
</dependency>
```

* 配置
```yml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: 192.168.6.111:8848
    sentinel:
      transport:
        dashboard: 192.168.6.111:8858
        port: 8719
        client-ip: 192.168.6.1
      eager: true
      datasource:
        ds1:  #数据源名称（随便写）
          nacos:  
            server-addr: 192.168.6.111:8848
            dataId: ${spring.application.name}  #在nacos中的文件名
            groupId: DEFAULT_GROUP
            data-type: json   #存储的格式
            rule-type: flow   #指定规则的类型（这里是流控规则）
```

* 在nacos上创建规则（dataId要对应）
```json
[
  {
    // 资源名
    "resource": "/test",
    // 针对来源，若为 default 则不区分调用来源
    "limitApp": "default",
    // 限流阈值类型(1:QPS;0:并发线程数）
    "grade": 1,
    // 阈值
    "count": 1,
    // 是否是集群模式
    "clusterMode": false,
    // 流控效果(0:快速失败;1:Warm Up(预热模式);2:排队等待)
    "controlBehavior": 0,
    // 流控模式(0:直接；1:关联;2:链路)
    "strategy": 0,
    // 预热时间（秒，预热模式需要此参数）
    "warmUpPeriodSec": 10,
    // 超时时间（排队等待模式需要此参数）
    "maxQueueingTimeMs": 500,
    // 关联资源、入口资源(关联、链路模式)
    "refResource": "rrr"
  }
]
```
