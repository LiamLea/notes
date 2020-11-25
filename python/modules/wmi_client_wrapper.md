# wmi_client_wrapper

[toc]

### 使用

#### 1.安装模块
该模块 **只支持linux系统**
```shell
pip3 install wmi-client-wrapper-py3
```

#### 2.使用

```python
import wmi_client_wrapper
from sh import ErrorReturnCode,TimeoutException

ret = ""

wmic = wmi_client_wrapper.WmiClientWrapper(
    username="administrator",
    password="jsepc123!",
    host="192.168.41.158",
)


try:
    result = wmic.query("SELECT * FROM Win32_Processor")

except ErrorReturnCode:
    print("凭证错误")

except TimeoutException:
    print("主机无法连接")

print(ret)
```
