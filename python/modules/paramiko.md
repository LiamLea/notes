# paramiko模块
* **使用**
```python
  ssh=paramiko.SSHClient()                
#创建SSHClient实例
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy()
#接收秘钥,无需询问
  ssh.connect(ip/host,username='xx',password='xx',port=xx)
  result=ssh.exec_command(命令)   
#返回一个元组:输入,输出和错误信息的生成器对象
  out=result[1].read().decode()
  err=result[2].read().decode()
  ssh.close()
```
