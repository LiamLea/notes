# overview

[toc]

### 概述

#### 1.spring security

##### （1）what
本质就是filters chain（过滤器链）

#### 2.相关概念

##### （1）会话超时

##### （2）自动登录

##### （3）单点登录: SSO（single sign on）
只要在一个地方登录，其他服务都可以进行访问

#### 2.自动登录实现原理
![](./imgs/overview_01.png)

#### 3.认证授权实现的两种方式

##### （1）基于session（cookie）
* 不适合分布式应用
  * 这种就需要集中式session（比如通过redis实现）
  * 当应用越来越多时，这种方式就会存在性能瓶颈

##### （2）基于token

##### （3）对比

||session-based|token-based|
|-|-|-|
|状态|有状态（用户数据存在server端的session中）|无状态（用户数据存在token中，token存在client的cookie中）|
|验证方式|根据sessionid，server端需要进行查询验证|根据token的签名进行验证|
|应用场景|单体应用|分布式应用|

#### 4.JWT（json web token）
* 本质就是 encode的字符串，本身携带了相关信息，无需再去查询
* 原始格式 就是json
* token格式（即对原数据进行了签名）: `<header>.<payload>.<signature>`
* 存储在客户端，一般在请求头中使用：`Authorization: Bearer <token>`


***

### 使用

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### 2.基本使用

##### （1）自定义用户认证
* `service/UserDetailsService.java`
```java
@Service
public class MyUserDetailsService implements UserDetailsService {
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        /**
         * 这里可以根据用户输入的用户，然后查询数据库，获取其他信息（比如：密码、角色等）
         * 进行后续的认证
        **/

        //设置权限（一个是直接赋权，一个是赋予角色）
        //如果是角色的话，必须遵循下面的格式：ROLE_xx
        //下面说明：赋予了admin权限，并且赋予了test这个角色
        List<GrantedAuthority> auths = AuthorityUtils.commaSeparatedStringToAuthorityList("admin", "ROLE_test");

        //User包含：用户名、密码、角色 三个信息
        //这里 返回的信息 会和 用户输入的信息 进行对比，从而确定该用户的权限
        return new User("liyi", new BCryptPasswordEncoder().encode("123456"), auths);
    }
}
```

##### （2）创建配置类

* `config/SecurityConfig.java`

```java
@Configuration      
@EnableWebSecurity  //开启web安全
public class SecurityConfig {

    @Resource
    private MyUserDetailsService myUserDetailsService;

    //设置对 用户输入的明文密码 的加密方式（必须要加密）
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests((authorize) -> authorize
                        .mvcMatchers("/hello").hasAuthority("admin")    //表示用户只有具备admin权限，才能访问/hello
                        .mvcMatchers("/test").hasRole("test")           //表示只有test角色的用户才能访问/test
                        .anyRequest().authenticated()     //表示所有的请求都需要进行认证
        );
        http.formLogin();
        return http.build();
    }
}
```

##### （3）创建测试接口
* `controller/HelloController.java`
```java
@RestController
public class HelloController {

    @RequestMapping("/hello")
    public String hello(){
        System.out.println("aaaaaaaaaaaa");
        return "hello";
    }
}
```

#### 2.常用注解

|注解|说明|
|-|-|
|`@Secured`和`@PreAuthorize`|在访问方法之前进行鉴权|
|`@PostAuthorize`|在方法执行之后进行鉴权|
|`@PreFilter`|对传入的数据做过滤|
|`@PostFilter`|对返回的数据做过滤|

##### （1）通过注解的方式进行权限认证：`Secured`
* 就不需要使用filterChain那种方式了（其他都跟上面保持一致）
* 主函数
```java
@SpringBootApplication
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SecurityMain {
    public static void main(String[] args) {
        SpringApplication.run(SecurityMain.class, args);
    }
}
```

* 使用: `controller/HelloController.java`
```java
@RestController
public class HelloController {

    @RequestMapping("/hello")
    @Secured("ROLE_admin")   //表示只有admin这个角色，能访问这个方法
    public String hello(){
        return "hello";
    }
}
```

#### 3.其他基础使用

下面只是粗略说明（具体参考相关文档）

* 用户注销
```java
http.logout()
```

#### 4.结合oauth2.0使用

* 引入依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>ru.mynewtons</groupId>
    <artifactId>spring-boot-starter-oauth2</artifactId>
</dependency>
```
