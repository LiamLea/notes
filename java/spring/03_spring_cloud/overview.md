#  overview

[toc]

### 概述

#### 1.结构

```shell
<project>
  +- xx-common          #用于存放通用的内容（比如：实体类）
  |
  +- <submodule_1>
  |
  +- <submodule_2>
  |
  +- pom.xml
```

* 父工程需要执行mvn install或deploy，安装到本地或远程仓库
* common模块也需要执行mvn install或deploy
  * common模块的pom.xml需要加上下面的配置
  ```xml
  <build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <skip>true</skip>
                <finalName>${project.name}</finalName>
            </configuration>
        </plugin>
    </plugins>
  </build>
  ```
* 其他模块的依赖需要引入common这个包
```xml
<dependencies>
    <dependency>
        <groupId>...</groupId>
        <artifactId>xx-common</artifactId>
        <version>${project.version}</version>
    </dependency>
</dependencies>
```

#### 2.服务集群化
启动多个实例，像注册中心注册，但是`spring.application.name`必须相同
