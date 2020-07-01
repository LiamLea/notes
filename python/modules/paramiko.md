[toc]
# paramiko模块
### 概述
### 使用
#### 1.建立ssh连接
```python
#创建SSHClient实例
ssh = paramiko.SSHClient()                

#接收秘钥,无需询问
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#连接目标机器
ssh.connect(hostname = <IP>, port = <NUM>, username = <USER> , password = <PASSWD>)
```

#### 2.执行命令
```python
#执行命令并获取结果
result = ssh.exec_command(<COMMAND>)   
```
##### （1）基本选项
* `get_pty = True`
获取虚拟终端，用于执行命令时输入
注意：
  * 获取虚拟终端后，所有输出都输出到标准输出
    * 因为在远端是标准错误输出，该标准错误输出会输出到当前虚拟终端的标准输出
  * 一闪而过的输出也会被捕捉，即输出到标准输出

#### 3.执行命令时输入
* 比如使用sudo命令时需要输入密码
* 前提：
  * 必须获取pty，即虚拟终端才能输入
  * 输入的内容必须你换行符结尾
```python
#输入
result[0].write('xx\n')   #必须以'\n'结束
result[0].flush()
```

#### 4.获取执行结果
```python
#返回一个元组：输入、输出 和 错误信息 的生成器对象
stdout=result[1].read().decode()
stderr=result[2].read().decode()
```

#### 5.关闭ssh连接
```python
#关闭ssh连接
ssh.close()
```
