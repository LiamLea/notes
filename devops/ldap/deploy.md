# 部署
[toc]
### 安装openldap

#### 1.修改配置文件：slapd.ldif
在`/usr/share/openldap-servers/`目录下

olc：on-line Configuration，在线配置，即可以不需要重启服务就能注入进去

##### （1）修改所在的域
```shell
olcSuffix: dc=xx,dc=xx
```
##### （2）修改数据库管理员并设置密码
* 设置该dn为此数据库的管理员
```shell
olcRootDN: cn=xx,dc=xx,dc=xx
```
* 设置管理员的密码
```shell
olcRootPW: xx					
```
##### （3）加载相关schema
```shell
#根据实际路径填写
include: file:///etc/openldap/schema/core.ldif
include: file:///etc/openldap/schema/cosine.ldif
include: file:///etc/openldap/schema/inetorgperson.ldif
include: file:///etc/openldap/schema/nis.ldif
```
#### 2.生成配置文件
```shell
rm -rf /etc/openldap/slap.d/*

slapadd -n 0 -F /etc/openldap/slapd.d -l /etc/openldap/slapd.ldif
#-n 0，表示将条目添加到第一个数据库
#-F confdir
#-l ldif-file

chown -R ldap:ldap /etc/openldap/slapd.d/
```

#### 3.启动服务：slapd

#### 4.初始化该目录数据库的条目
```shell
#init.ldif
dn: dc=xx1,dc=xx2
objectClass: dcObject
objectClass: organization
dc: xx1
o: Example Company

dn: cn=xx,dc=xx,dc=xx
objectClass: organizationalRole
cn: xx
```
```shell
ldapadd -x -D "cn=xx,dc=xx,dc=xx" -W -f init.ldif
```

***

### 利用SASL进行验证
SASL：simple authentication and security layer
#### 1.安装相应的包：
```shell
yum -y install *sasl*
```

#### 2.修改配置文件：`/etc/sysconfig/saslauthd`
```shell
mech=ldap
```

#### 3.修改配置文件：`/etc/saslauthd.conf`
```shell
ldap_servers: ldap://10.0.36.226
ldap_bind_dn: cn=Manager,dc=lil,dc=com
ldap_bind_pw: 123456
ldap_search_base: ou=People,dc=lil,dc=com
ldap_password_attr: userPassword
```

#### 4.重启服务：saslauthd

#### 5.验证ldap账号
```shell
testsaslauthd -uxx -pxx
```
