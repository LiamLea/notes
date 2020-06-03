# 基础使用
### 命令行
#### 1.查询条目
```shell
ldapsearch [options] "filter" "attributes"

#选项：
#  -H ldap://地址        #指明ldap服务器地址
#  -x                   #采用简单认证
#  -D <admin的dn>       #D：dn，与该服务器绑定的dn
#  -w <password>
#  -b <base dn>         #设置访问点，若不设置，则表示访问点为该ldap的根（dc=xx,dc=xx）
#  -LLL                 #以ldif格式打印结果

#attributes:
#   "*"        #表示显示所有 用户属性（不指定的话，默认就是这个）
#   "+"        #表示所有 操作属性
```

* 查询openldap的配置
```shell
ldapsearch ... -b cn=config
```

#### 2.添加条目
```shell
ldapadd
  -H ldap://地址
  -x                        #简单认证
  -D "cn=xx,dc=xx,dc=xx"    #此处的dn用于指定数据库管理员
  -w xx                     #xx为数据库管理员的密码
  -f xx.ldif
```

### filter（过滤器）
#### 1.格式
```shell
#过滤器必须用括号括起来
(xx)    
```
#### 2.常用过滤器
* 过滤某个属性
```shell
(uid=lil)           #过滤出uid为"lil"的条目
```
* 通配符
```shell
(uid=*)             #过滤有用uid属性的条目
```
* 与
```shell
(&(uid=lil)(sex=男))   #过滤uid=lil且sex=男的条目
```
* 或
```shell
(|(uid=lil)(uid=zhangsan))      #过滤uid=lil或uid=zhangsan的条目
```
* 非
```shell
(!(uid=*))          #过滤没有uid属性的条目
```
