# memberof

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [memberof](#memberof)
    - [概述](#概述)
      - [posixGroup vs groupOfNames](#posixgroup-vs-groupofnames)
    - [配置memberof功能](#配置memberof功能)
      - [1.启动memeberof](#1启动memeberof)
        - [（1）加载模块](#1加载模块)
        - [（2）配置数据库](#2配置数据库)
      - [2.启动参照完整性](#2启动参照完整性)
        - [（1)加载模块](#1加载模块-1)
        - [（2）配置数据库](#2配置数据库-1)

<!-- /code_chunk_output -->

### 概述
#### posixGroup vs groupOfNames
* posixGroup
组中能够添加多个成员，但是成员无法知道自己属于哪些组
</br>
* groupOfNames
组中能够添加多个成员，成员也能通过`memberof`属性知道自己属于哪些组
能够通过给某个条目添加memberof属性，从而把该条目加入某个组中

***

### 配置memberof功能
#### 1.启动memeberof
##### （1）加载模块      
```shell
$ vim load-memberof-module.ldif        
#开启memberof支持
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
olcModuleload: memberof.la
olcModulePath: /usr/lib64/openldap
```
```shell
$ ldapadd -H ldap://3.1.11.27 -x -D cn=admin,dc=cangoal,dc=com -w cangoal -f  load-memberof-module.ldif
```  

##### （2）配置数据库
配置数据库支持这种功能
```shell
$ vim add-memberof-overlay.ldif

#填写实际使用的数据库，可以先通过cn=config查看一下
dn: olcOverlay=memberof,olcDatabase={2}bdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof
olcMemberOfDangling: ignore
olcMemberOfRefInt: TRUE
olcMemberOfGroupOC: groupOfNames    #设置能够使用memberof的group的objectClass
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf
```
```shell
$ ldapadd -H ldap://3.1.11.27 -x -D cn=admin,dc=cangoal,dc=com -w cangoal add-memberof-overlay.ldif
```  

#### 2.启动参照完整性
如果一个member的属性调整了，该member所在的所有group都相应的更新

##### （1)加载模块
```shell
$ vim add-refint.ldif

#首先要查找到memberof是哪个模块
#ldapsearch ... -b cn=config "(cn=module*)"
#然后这里替换为相应的模块就行
dn: cn=module{1},cn=config
changetype: modify
add: olcmoduleload
olcmoduleload: refint.la
```
```sh
ldapadd -H ldap://3.1.11.27 -x -D cn=admin,dc=cangoal,dc=com -w cangoal -f add-refint.ldif
```

##### （2）配置数据库

```shell
$ vim add-refint-overlay.ldif

#根据实际情况填写数据库名称
dn: olcOverlay=refint,olcDatabase={2}bdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: refint
olcRefintAttribute: memberof member  manager owner
```
```sh
ldapadd -H ldap://3.1.11.27 -x -D cn=admin,dc=cangoal,dc=com -w cangoal -f add-refint-overlay.ldif
```
注意：对于参照完整性，之前添加的组要删除后才能生效
