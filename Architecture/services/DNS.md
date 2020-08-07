# DNS
[toc]
### 概述
#### 1.域名解析时的各项解析记录

* A记录
  将域名指向一个IPv4地址
</br>
* AAA记录
  将域名指向一个IPv6地址
</br>
* CNAME记录
  该域名的别名
</br>
* MX记录
指向邮件服务器地址
</br>
* NS记录
域名解析服务器记录
</br>
* TXT记录
  可任意填写，可为空
</br>
* SRV记录
  服务记录(记录了哪台计算机提供了哪个服务)
</br>
* SOA记录
  SOA叫做起始授权机构记录，NS用于标识多台域名解析服务器，SOA记录用于在众多NS记录中那一台是主服务器
</br>
* PTR记录
  PTR记录是A记录的逆向记录，又称做IP反查记录或指针记录，负责将IP反向解析为域名

#### 2.DNS的search选项
```shell
#vim /etc/resolv.conf
nameserver <DNS_SERVER>
search <DOMAIN1> <DOMAIN@>
```
```shell
ping <HOST>
```
* 首先会在本地解析`<HOST>`
* 当本地无法解析时，会去DNS服务器解析`<HOST>`
* 当DNS服务器无法解析`<HOST>`时，会加上search中设置的域，即会尝试去DNS服务器解析`<HOST>.<DOMAIN1>`，`<HOST>.<DOMAIN2>`

***

### 使用
#### 1.`dig`
```shell
dig <SERVER>
    +search         #利用/etc/resolv.conf中的search参数，默认不使用
    -t <TYPE>       #查询指定记录
```
