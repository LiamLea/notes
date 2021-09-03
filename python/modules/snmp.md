[toc]
### `easysnmp`
#### 使用
##### 1.建立session
* snmp v3
```python
session = easysnmp.Session(
    hostname = "<HOST>",
    remote_port = <PORT>,
    version = 3,
    security_username = "<USERNAME>",
    security_level = "auth_with_privacy",
    privacy_protocol = "<PROTOCOL>",
    privacy_password = "<PRIVACY_PASSWD>",
    auth_protocol = "<PROTOCOL>",
    auth_password = "<AUTH_PASSWD>"
  )
```
* snmp v2
```python
session = easysnmp.Session(
    hostname = "<HOST>",
    version = 2,
    community = "<COMMUNITY>"
    )
```

* 其他选项
```python
session = easysnmp.Session()

# use_sprint_value = True,    加了这个参数，跟用snmpwalk获取的输出是一样的，否则会将16进制的数据进行转码
# use_numeric = True（不要用这个选项，并发的时候会报错）          输出的结果的oid都是数字，不会是说明文字，相当于snmpwalk -On选项
# abort_on_nonexistent = True  当使用get方法时，oid不存在时，则会抛出easysnmp.exceptions.EasySNMPNoSuchObjectError异常
# best_guess = 1 相当于-Ib，best_guess = 1 相当于-IB
```

##### 2.执行其他操作
* 执行`snmpwalk`
```python
session.walk("<OID>")
```
