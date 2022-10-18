# subprocess

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [subprocess](#subprocess)
    - [概述](#概述)
    - [使用](#使用)
      - [1.函数](#1函数)

<!-- /code_chunk_output -->

### 概述
### 使用
#### 1.函数
```python
#调用这个函数，会创建一个子进程执行命令
#非阻塞
p = subprocess.Popen(*args, **kwargs)

#阻塞，等待输出
#返回一个元组
stdout, stderr = p.communicate(timeout = <sec>)     

#关闭这个进程
p.kill()  
```

* 接收的参数
```python
args = "需要执行的语句"
shell = False               #如果shell设置成False，则CMD就需要以['/bin/bash', '-c', 'xx']这样的形式
                            #如果shell设置成True，则CMD直接为"xx"这种形式
encoding = "utf8"           #返回的数据就是"utf8"编码类型（就是不字节类型的数据了）

stdout = subprocess.PIPE    #接收标准输出
stderr = subprocess.PIPE    #接收标准错误输出

env =
```

* 下面是上面的一个封装，但是不建议使用(timeout经常失效)
```python
import subprocess

result=subprocess.run(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)  
#不显示命令的输出结果,将所有输出信息都放入返回值中
result.returncode       #returncode就是$?
result.stdout
result.stderr
```
