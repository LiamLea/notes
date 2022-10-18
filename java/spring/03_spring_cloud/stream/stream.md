# stream

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [stream](#stream)
    - [概述](#概述)
      - [1.spring cloud stream](#1spring-cloud-stream)
        - [（1）what](#1what)
      - [2.基础概念](#2基础概念)
        - [（1）Binder](#1binder)
        - [（2）Channel](#2channel)
        - [（3）Source 和 Sink](#3source-和-sink)
    - [使用（以kafka为例）](#使用以kafka为例)
      - [1.引入依赖](#1引入依赖)
      - [2.生产者](#2生产者)
        - [（1）配置stream](#1配置stream)
        - [（2）创建service（用于发送消息）](#2创建service用于发送消息)
        - [（3）使用](#3使用)
      - [3.消费者](#3消费者)
        - [（1）配置stream](#1配置stream-1)
        - [（2）使用](#2使用)
        - [（3）效果](#3效果)

<!-- /code_chunk_output -->

### 概述

#### 1.spring cloud stream

##### （1）what

是一个构建消息驱动的微服务框架
* 屏蔽底层消息中间件的差异，提供统一的接口

#### 2.基础概念

##### （1）Binder
用于绑定底层的消息中间件，对上提供统一接口

##### （2）Channel
消息队列

##### （3）Source 和 Sink
Source就是生产者
Sink就是消费者

***

### 使用（以kafka为例）

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-stream-kafka</artifactId>
</dependency>
```

#### 2.生产者


##### （1）配置stream
```yml
spring:
  cloud:
    stream:
      kafka:
        binder:
          brokers: 10.10.10.163:19092
          auto-create-topics: true
      bindings:
        #output表示生产者的配置
        output:
          destination: stream-demo        #指定topic
          content-type: application/json  #格式
```

##### （2）创建service（用于发送消息）
* `service/MessageProvider.java`
```java
//Source定义这是一个生产者
@EnableBinding(Source.class)
public class MessageProvider {

    //定义channel并实现自动装配
    @Resource
    private MessageChannel output;

    public String send(){
        String msg="aaaaaa";
        output.send(MessageBuilder.withPayload(msg).build());
        return null;
    }
}
```

##### （3）使用
* `controller/ProviderController.java`
```java
@RestController
public class ProviderController {
    @Resource
    private MessageProvider messageProvider;

    @RequestMapping("/provider/send")
    public String send_msg(){
        return messageProvider.send();
    }
}
```

#### 3.消费者


##### （1）配置stream
```yml
spring:
  cloud:
    stream:
      kafka:
        binder:
          brokers: 10.10.10.163:19092
          auto-create-topics: true
      bindings:
        #input表示消费者的配置
        input:  
          destination: stream-demo        #指定topic
          content-type: application/json  #格式
          group: group1       #设置该消费者所在的组
```

##### （2）使用
* `controller/ConsumerController.java`
```java
@EnableBinding(Sink.class)
public class ConsumerController {

    @StreamListener(Sink.INPUT)
    public void receive(Message<String> msg){
        String result = msg.getPayload();
        System.out.println(result);
    }
}
```

##### （3）效果
调用生产者发送消息
在消费者控制台能看到消息输出
