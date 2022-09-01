

#### `pom.xml`格式

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!--
  所有项目的内容写在project下
-->
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <!--
    这个项目的基础信息：所在的组、id和版本
  -->
  <groupId>com.atguigu.springcloud</groupId>
  <artifactId>cloud2020</artifactId>
  <version>1.0-SNAPSHOT</version>
  <!--
    指定打包成什么形式：jar、war、pom
    当时父工程时，这里需要填pom
  -->
  <packaging>jar</packaging>

  <!-- 用于父工程：
      指定该工程的子模块
  -->
  <modules>
    <module>xx</module>
  </modules>

  <!--
    指定父项目: 会继承该父项目的依赖的各种包的版本信息
  -->
  <parent>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-parent</artifactId>
      <version>2.7.3</version>
  </parent>

  <!--
    统一管理相关信息（能够覆盖继承过来的信息）
    比如明确指定版本信息
  -->
  <properties>
      <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
      <java.version>1.8</java.version>
      <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
      <spring.boot.version>2.7.1</spring.boot.version>
      <spring.cloud.version>2021.0.3</spring.cloud.version>
      <alibaba.cloud.version>2021.0.1.0</alibaba.cloud.version>
  </properties>

  <!-- 用于父工程：
    锁定版本，即子模块继承之后，不用写version
  -->
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring.boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>${spring.cloud.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-alibaba-dependencies</artifactId>
        <version>${alibaba.cloud.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <!--
    指定依赖的包，版本信息会在parent中的依赖信息中找到，也可以直接在这里指定
    如果所依赖的包信息不在parent中，需要在这里明确指定版本信息
  -->
  <dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
  </dependencies>

  <!--
    描述了如何来编译及打包项目
    父工程的build内容会被子工程继承
  -->
  <build>

      <!--
        读取java目录下的xml文件，否则只会读取java目录下的java文件
      -->
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


      <plugins>
          <!-- 需要这个插件，否则构建的spring的jar无法运行 -->
          <plugin>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-maven-plugin</artifactId>
              <version>${spring.boot.version}</version>
          </plugin>
      </plugins>

  </build>

</project>

```
