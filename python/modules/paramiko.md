# paramiko模块
### 概述
### 使用
```python
#创建SSHClient实例
ssh = paramiko.SSHClient()                

#接收秘钥,无需询问
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#连接目标机器
ssh.connect(hostname = <IP>, port = <NUM>, username = <USER> , password = <PASSWD>)

#执行命令并获取结果
result=ssh.exec_command(<COMMAND>)   

#输入
result[0].write('xx\n')   #必须以'\n'结束
result[0].flush()

#返回一个元组：输入、输出 和 错误信息 的生成器对象
stdout=result[1].read().decode()
stderr=result[2].read().decode()

#关闭ssh连接
ssh.close()
```
