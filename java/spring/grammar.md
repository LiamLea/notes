# grammar

[toc]

### 基本使用

#### 1.主程序

```java
//相当于SpringBootConfiguration EnableAutoConfiguration + ComponentScan
//表示进行springboot的自动配置
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
        //运行spring应用
        //返回的是一个IoC容器
        SpringApplication.run(MainApplication.class, args);
    }
}
```

* 查看IoC容器里所有的beans（即对象）
```java
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext run = SpringApplication.run(MainApplication.class, args);
        String[] names = run.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
    }
}
```

#### 2.容器功能

##### （1） 配置自动绑定例子
* application.yml
```yaml
mycar:
  info:
    brand: byd
    price: 1000
```

* 利用`@ConfigurationProperties`
```java
@Component
@ConfigurationProperties(prefix="mycar.info")
@Data
public class Car {
  private String band;
  private Integer price;
}
```

* 利用`@EnableConfigurationProperties`

```java
@ConfigurationProperties(prefix="mycar.info")
@Data
public class Car {
  private String band;
  private Integer price;
}

@EnableConfigurationProperties(Car.class) //并且会将Car这个组件自动注册到容器中
@Configuration
public class Myconfig {}
```

#### 3.调用接口: RestTemplate
* 注册RestTemplate组件: `config/ApplicationContextConfig.java`
```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }
}
```
* 使用
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
        String msg = restTemplate.getForObject("http://127.0.0.1:8081/pay", String.class);
        return "call successfully: " + msg;
    }
}
```
