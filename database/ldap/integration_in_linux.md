### linux系统集成使用openldap账号登录

nslcd：name service local daemon

#### 1.安装软件openldap和nss-pam-ldapd

#### 2.修改配置文件：`/etc/nslcd.conf`
```shell
uri ldap://xx
base dc=xx,dc=xx
```

#### 3.修改配置文件：`/etc/nsswitch.conf`
```shell
passwd: files ldap
shadow: files ldap
group: files ldap
```

#### 4.修改配置文件：`/etc/pam.d/xx`

#### 5.启动服务：nslcd
具体怎么修改去网上搜一下

##### 6.设置可以sudo提权，修改配置文件：`/etc/sudoers`
```shell
%组名 ALL=(ALL)   ALL
```
