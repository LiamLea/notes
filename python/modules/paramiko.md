[toc]
# paramiko模块

### 使用（注意必须要明确关闭ssh连接）

如果将ssh client赋值给一个变量，当该变量结束时，连接不会关闭
这是paramiko的一个bug，会造成 **连接泄漏**
connect一次就会产生一个新的连接，所以如果肯定多次会造成 **连接泄露**（如果要多次connect，先close）

#### 1.建立ssh连接
```python
#创建SSHClient实例
ssh = paramiko.SSHClient()                

#接收秘钥,无需询问
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#连接目标机器
#注意：每执行一次connect，会创建一个连接，之前的连接就会泄露
ssh.connect(hostname = <IP>, port = <NUM>, username = <USER> , password = <PASSWD>)
```

#### 2.执行命令
```python
#执行命令并获取结果
#bufsize = -1，表示默认不开启缓冲
result = ssh.exec_command(<COMMAND>, timeout = None)

#timeout 表示读写的超时时间，默认为None，即不会抛超时异常
#         若超时，会抛出超时异常
```

**基本选项：**

##### （1）`get_pty = True`（**尽量不要使用这个选项**）
获取虚拟终端，用于执行命令时输入
* 只有当shell命令无法从标准输入获取输入时，只能交互式输入时，再使用

* 注意：
  * 获取虚拟终端后，所有输出都输出到标准输出
    * 因为在远端是标准错误输出，该标准错误输出会输出到当前虚拟终端的标准输出
  * 一闪而过的输出也会被捕捉，即输出到标准输出
* 缺点：
  * 就是上面需要注意的内容，输入的内容如果太快，则会在输出中获取，影响输入

#### 3.执行命令时输入
* 比如使用sudo命令时需要输入密码
* 可以不采用pty的方式，sudo可以从标准输入中获取密码
* `sudo -S -p ''` 这样就不会有其他干扰性的输出了
  * -S，stdin表示从标准输入获取密码，比如：`echo xx | sudo -S ls`
  * -p ''，表示不输入任何提示信息
```python
#输入
result[0].write('xx\n')   #必须以'\n'结束
result[0].flush()       #默认是不开启缓冲，所以不一定要flush
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
