[toc]
### `easysnmp`
#### 使用
##### 1.建立session
* snmp v3
```python
session = easysnmp.session(
    hostname = "<HOST>",
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
session = easysnmp.session(
    hostname = "<HOST>",
    version = 2,
    community = "<COMMUNITY>"
)
```

##### 2.执行其他操作
* 执行`snmpwalk`
```python
session.walk("<OID>")
```
