# linux基础
[toc]
### shell
**注意**：
* `ssh <USER>@<IP> <COMMAND>`
  * 执行这个command的是non-login shell，即使ssh需要输入账号密码
* `ssh <USER>@<IP>`
  * 这个登录后是login shell
#### 1.login shell 和 non-login shell 的区别
* login shell
```plantuml
card "login shell" as lsh
card "/etc/profile" as p1
card "~ /.bash_profile" as p2
card "/etc/bashrc" as b1
card "~ /.bashrc" as b2
lsh --> p1:调用
lsh -> p2:调用
p2 -> b2:调用
b2 -> b1:调用  
```
```shell
echo $0

#-bash
#如果“-”是第一个字符，所以这是一个登录shell
```
* non-login shell
```plantuml
card "non-login shell" as lsh
card "/etc/bashrc" as b1
card "~ /.bashrc" as b2
lsh -> b2:调用
b2 -> b1:调用
```
```shell
echo $0

#bash
#这是一个非登录shell
```

***

### 动态库

#### 1.动态库配置文件：/etc/ld.so.conf
`/etc/ld.so.conf`用于指定使用哪些路径下的 动态库
默认只会使用`lib`和`/usr/lib`两个目录下的库文件

#### 2.动态库的缓存文件：/etc/ld.so.cache
为什么了加速动态库的调用

#### 3.基本使用
* 查看程序所需要的动态库
```shell
ldd <FILE>
```

* 查看缓存了哪些动态库
```shell
ldconfig -p
```

* 更新动态库缓存和创建链接文件
```shell
ldconfig
```
