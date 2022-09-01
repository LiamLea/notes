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
