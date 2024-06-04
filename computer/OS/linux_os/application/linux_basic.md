# linux基础

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [linux基础](#linux基础)
    - [shell](#shell)
      - [1.login shell 和 non-login shell 的区别](#1login-shell-和-non-login-shell-的区别)
      - [2.linux shell支持的匹配模式：glob pattern](#2linux-shell支持的匹配模式glob-pattern)

<!-- /code_chunk_output -->

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

#### 2.linux shell支持的匹配模式：glob pattern
```shell
*       #匹配多个任意字符
**      #递归目录
?       #匹配一个字符
[]      #同正则
{aa,bb}   #匹配aa或bb，相当于正则中的(aa|bb)
```
