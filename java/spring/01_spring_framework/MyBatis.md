# MyBatis

[toc]

### 概述

#### 1.MyBatis

提供的持久层框架：SQL Map和Data Access Objects（DAO）

***

### 使用

#### 1.基本使用

[参考](https://mybatis.org/mybatis-3/getting-started.html)

##### （1）导入并配置mybatis
```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis</artifactId>
  <version>x.x.x</version>
</dependency>
```

* 创建全局配置: `resources/mybatis/mybatis-config.xml`
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <!--开启下划线命名转化成驼峰，因为实体类名需要于表中的字段名对应-->
  <settings>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
</configuration>
```

##### （2）创建实体类（用于对应表）

* 创建实体类:`entity/User.java`
```java
//表中有两个字段: int(id)、string(name)
@Data
public class User {
    private Integer id;
    private String name;
}
```

##### （3）创建mapper

* 定义mapper接口: `mapper/UserMapper.java`
```java
@Mapper
public interface UserMapper {
    public User getUser(Integer id);
}
```

* 在xml中定义接口的具体实现: `mapper/UserMapper.xml`
  * 注意这里需要修改pom.xml的配置，表示要读取相关的xml文件（否则不会读取java目录下的xml文件，只会读取resources目录下的）
  ```xml
  <build>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
        </resource>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
            </includes>
        </resource>
    </resources>
  </build>
  ```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--
  namespace为mapper接口的类路径
  id为mapper接口中的方法名
  resultType为实体类
  接口的具体实现为：<select>的内容（表示执行select语句）
-->
<mapper namespace="com.example.mapper.UserMapper">
    <select id="getUser" resultType="com.example.entity.User">
        select * from test_user where id = #{id}
    </select>
</mapper>
```

##### （4）使用mapper的接口
```java
@Data
@Controller
public class MyController {

    @Autowired
    UserMapper userMapper;

    @ResponseBody
    @GetMapping("/hello")
    public User getById(){
        User u = userMapper.getUser(1);
        System.out.println(u);
        return u;
    }
}
```
