# exception
[toc]

### 简单使用
#### 1.常见异常

```python
NameError             #没有声明或初始化对象
IndexError
SyntaxError           #语法错误
KeyboardInterrupt     #用户终端(按ctrl+c)
EOFError              #读到EOF(按ctrl+d)
IOError               #输入/输出操作失败
```

#### 2.处理异常

```python
try:
    pass              #可能发生异常的程序,不会发生异常的不要放在里面

except <EXCEPTION> as e:   #多个异常:(xx1,xx2,..)
                           #e.args 是一个元组，用于存储信息
    pass              #捕获异常

else:                 #不发生异常会执行
    pass

finally:              #无论如何都会执行（但是如果捕获后还是抛出异常，这里不会执行）
    pass

#继续执行下面的程序,除非上面指明退出(exit())
```

#### 3.捕获异常的堆栈信息（一般用于记录在日志中）
```python
import traceback

try:
    pass

except <EXCEPTION>:

    print(traceback.format_exc())
```

#### 4.触发异常(自己编写)
```python
#如:
if n>200:
  raise ValueError('n的值超过了200')

#或者使用 断言异常:

assert n<=200,'n的值超过了200'      #这里产生的异常是:AssertionError
```

***

### 应用
#### 1.自定义一个异常类
```python
class BusinessException(Exception):
  pass
```

#### 2.自己抛出异常，然后在外层捕获
```python
raise BusinessException("说明信息")
```
* 在外层捕获
```python
try:
  main()
except BusinessException:
  pass
```
