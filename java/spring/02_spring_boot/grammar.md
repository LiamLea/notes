# grammar

[toc]

### 基本使用

#### 1.主程序
```java
//SpringBootApplication标识这个是一个springboot类型的主程序
//写法固定
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
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

只有在容器内的组件，才能使用下面的非创建组件注解（即需要先把组件加到容器中，才能使用相关注解）

##### （1）相关注解

|注解|说明|
|-|-|
|`@Configuration`|创建配置类（相当于配置文件），结合`@Bean`可以给IoC容器中创建组件（即对象）|
|`@Component`|表示该类是一个组件（即对象）|
|`@Controller`|表示该类是一个控制器|
|`@Service`|表示该类是一个业务逻辑组件|
|`@Repository`|表示该类是一个数据库层组件|
|`@Import`|给容器中导入指定组件（即创建对象）|
|`@Conditional*`|满足指定条件，则注册组件|
|`@ConfigurationProperties`|配置自动绑定|
|`@EnableConfigurationProperties`（需要配合`@Configuration`）|配置自动绑定|

##### （2） 配置自动绑定例子
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
