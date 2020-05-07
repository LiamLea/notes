# subprocess
### 概述
### 使用
#### 1.函数
```python
subprocess.run(*args, **kwargs)

#返回一个CompleteProcess对象，对象中包含设置的相应属性
#CompletedProcess(args = 'ls', returncode = 0, stdout = b'xx', ...)
```
接收的参数
```python
args = "需要执行的语句"
shell = False
encoding = "utf8"           #返回的数据就是"utf8"编码类型（就是不字节类型的数据了）

stdout = subprocess.PIPE    #标准输出的内容会放到CompletedProcess对象的stdout属性中（是字节类型的数据）
stderr = subprocess.PIPE    #错误输出的内容会放到stderr这个属性中（是字节类型的数据）

timeout = 10                #超时时间设为10s，如果语句还有执行完，会抛出TimeoutExpired

env = 


```


```python
import subprocess

#在shell下执行command命令
result=subprocess.run(command,shell=True)
result.returncode                 #returncode就是$?

result=subprocess.run(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)  
#不显示命令的输出结果,将所有输出信息都放入返回值中
result.returncode   
result.stdout
result.stderr
```
