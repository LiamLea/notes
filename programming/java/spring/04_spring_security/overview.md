# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [Overview](#overview-1)
      - [1.spring security](#1spring-security)
        - [（1）what](#1what)
      - [2.filter](#2filter)
        - [（1）filter chain](#1filter-chain)
        - [（2）认证过滤器：UsernamePasswordAuthenticationFilter](#2认证过滤器usernamepasswordauthenticationfilter)
        - [（3）鉴权过滤器：FilterSecurityInterceptor](#3鉴权过滤器filtersecurityinterceptor)
    - [Usage](#usage)
      - [1.引入依赖](#1引入依赖)
      - [2.基本使用](#2基本使用)
        - [（1）自定义用户认证并授权](#1自定义用户认证并授权)
        - [（2）创建配置类](#2创建配置类)
        - [（3）创建测试接口](#3创建测试接口)
      - [2.常用注解](#2常用注解)
        - [（1）通过注解的方式进行权限认证：`Secured`](#1通过注解的方式进行权限认证secured)
      - [3.其他基础使用](#3其他基础使用)
      - [4.结合oauth2.0使用](#4结合oauth20使用)

<!-- /code_chunk_output -->


### Overview

#### 1.spring security

##### （1）what
本质就是filters chain（过滤器链）

![](./imgs/overview_04.png)

#### 2.filter

##### （1）filter chain
![](./imgs/overview_05.png)

##### （2）认证过滤器：UsernamePasswordAuthenticationFilter
![](./imgs/overview_06.png)

##### （3）鉴权过滤器：FilterSecurityInterceptor
![](./imgs/overview_07.png)


***

### Usage

#### 1.引入依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### 2.基本使用

##### （1）自定义用户认证并授权
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

    //对用户进行 鉴权
    //这里使用的是filterchain方式，还可以使用注解的方式（参考下文）
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
