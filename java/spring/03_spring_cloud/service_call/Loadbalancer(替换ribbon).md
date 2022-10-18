# LoadBalancer

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [LoadBalancer](#loadbalancer)
    - [概述](#概述)
      - [1.LoadBalancer（替换ribbon）](#1loadbalancer替换ribbon)
    - [使用](#使用)

<!-- /code_chunk_output -->

### 概述

#### 1.LoadBalancer（替换ribbon）
是一种进程内的负载均衡器，与客户端继承，可以与注册中心结合，获取服务地址，从而实现进程内的负载均衡

***

### 使用

* 调用组件需要加上LoadBalancer
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
         String msg = restTemplate.getForObject("http://CLOUD-PAYMENT-SERVICE/pay", String.class);
         System.out.println(user);
         return "call successfully: " + msg;
  }
}
```
