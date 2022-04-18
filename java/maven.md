# maven

[toc]

### 基本概念

#### 1.maven
* maven是一款服务于Java平台的自动化构建工具
* 构建是 以"java源文件","框架配置文件","jsp","html","图片"等资源为原材料，生成一个可以运行的项目的过程

#### 2.构建的步骤：
* clean（清理）
将以前编译得到的旧的class字节码文件删除，为下一次编译做准备
</br>
* compile（编译）
源文件(.java) -> 编译 -> 字节码文件(.class)
</br>
* test（测试）
使用合适的单元测试框架来测试编译好的源代码
</br>
* package（打包）
动态web工程打war包，java工程打jar包
</br>
* install（安装）
将打包后的文件存入本地仓库
</br>
* deploy（部署）
将打包后的文件存入远程仓库

#### 3.约定的目录结构
```shell
xx                           #根目录,即工程名
|---src                      #源码
|----|---main                #存放主程序
|----|----|---java           #存放java源码
|----|----|---resources      #存放框架或其他工具的配置文件
|----|---test                #存放测试程序
|----|----|---java              
|----|----|---resources
|---pom.xml                  #Maven工程的核心配置文件
```
#### 4.POM(project object model)
pom.xml的配置

#### 5.坐标
使用三个值在仓库中唯一定位一个maven工程
* groupid:公司或组织的域名倒序+项目名
  * `<groupid>com.atguigu.maven</groupid>`
* artifactid：模块名
  * `<artifactid>Hello</artifactid>`
* version：版本
  * `<version>1.0.0</version>`

#### 6.依赖
在pom.xml配置依赖的moven工程
会到本地仓库中寻找依赖的maven工程
依赖的范围：
  * compile        
  对 主程序和测试程序 都有效，参与打包，能够传递
  * test           
  对 测试程序 有效，不参与打包
  * provided       
  对 主程序和测试程序 都有效，不参与打包

#### 7.仓库的分类：
当执行mvn命令构建时，需要依赖的包，mvn会先到本地仓库中查找
找不到会去远程仓库下载
* 本地仓库
默认：`~/.m2/repository`
</br>
* 私有服务器(Nexus)
私服假设在局域网内
执行mvn构建时，如果mvn去nexus私库没有找到依赖，mvn会去指定的远程仓库下载，并且会存入nexus仓库
</br>
* 中央仓库镜像
用于加速，比如阿里云的镜像仓库
</br>
* 中央仓库
官网仓库，速度比较慢

仓库中保存的内容：Maven工程
* maven自身所需要的插件
* 第三方框架或工具的jar包
* 我们自己开发的maven工程  

#### 8.继承
由于非compile范围的依赖不能传递，所以很容易造成不同工程中的版本不一致

#### 9.聚合
一键处理多个maven工程
编写pom.xml:
```xml
<modules>
  <module>maven工程的路径</module>
  <module>maven工程的路径</module>
  ... ...
</modules>
```
在pom.xml的路径下执行mvn命令，即可处理多个maven工程

#### 10.artifact
* 在maven中，一个artifact就是被maven project生成的资源，一个artifact就是一个jar或war等
* 每个artificat都有一个`<artifactId>-<version>.pom`文件，用于描述该artifact是怎么build的和有哪些依赖依赖
* 每个artifact都有group ID (通常是反向域名，比如com.vmware)，artifact ID (artifact的名字), version（版本号），这些内容唯一标识一个artifact

***

### maven命令
```shell
mvn -f <POM_FILE> <phase(s)>
    -o      #offine mode，脱机模式（就是不联网，即不会从远程仓库下载）
```
#### 1.常用命令
```shell
mvn clean             #清除编译好的文件，删除target目录

mvn compile           #编译主程序,在target目录下生成主程序的编译文件

mvn test-compile      #编译测试程序,在target目录下生成测试程序的编译文件

mvn test              #执行测试

mvn package           #执a行打包,在target目录下生成jar包

mvn install           #在package基础上，同时把打好的可执行jar包（war包或其它形式的包）布署到本地maven仓库

mvn deploy            #在package基础上，同时把打好的可执行jar包（war包或其它形式的包）布署到本地maven仓库和远程maven私服仓库
```

#### 2.常用组合
```shell
mvn -f pom.xml clean deploy -D maven.test.skip=true
```

***

### 配置
配置文件：`<MAVEN_DIR>/conf/settings.xml`

#### 1.设置中央仓库镜像
```xml
<mirrors>
  <mirror>
     <id>随便填</id>
     <mirrorOf>central</mirrorOf>
     <name>随便填</name>
     <url>http://maven.aliyun.com/nexus/content/groups/public</url>
  </mirror>
</mirrors>
```

#### 2.设置使用的私库
私库的地址在pom.xml中设置
私库的账号密码在settings.xml中设置
```xml
<server>
  <id>服务器id</id>   
  <!-- 服务器的id跟pom.xml中设置的服务器的id对应，即访问那个仓库时，会使用这里设置的账号密码-->
  <username>nexus账号</username>
  <password>nexus</password>
</server>
```

#### 3.允许用http连接nexus仓库
* 需要将下面的内容注释掉
```xml
<!--将下面的内容注释掉-->
<mirror>
  <id>maven-default-http-blocker</id>
  <mirrorOf>external:http:*</mirrorOf>
  <name>Pseudo repository to mirror external repositories initially using HTTP.</name>
  <url>http://0.0.0.0/</url>
  <blocked>true</blocked>
</mirror
```

***

### FAQ
#### 1.本地有artifct，但是还是从远程下载
* 当artifact从仓库中下载下来，会在保存本地maven仓库中，会有一个`_maven.repositories`文件，用于记录该artifact从哪里解析来的
</br>
* 如果`_maven.repositories`中记录的仓库，**不在有效的仓库列表中**，则会重新去有效列表中去下载（有效列表：在maven中、在pom文件中等地方配置的）
* 使用offine mode，`_maven.repositories`文件会被忽略
