[toc]
# 基础积累
### python虚拟化环境
（1）图形化创建
>settings -> project -> project interpreter -> add local... -> 指定虚拟环境的目录和python的目录 -> 确定 -> 选择解释器(即选择了虚拟环境)

（2）命令行创建
```shell
python3 -m venv 目录      #该虚拟环境使用的是python3
source 目录/bin/activate

#此时就进入python虚拟环境了,退出输入:deactivate
#交换式直接输入python
#执行python脚本:python xx.py
```
### 基本语法
* 靠缩进表达代码逻辑(加了冒号后,才能进行缩进)
* 命令
>变量名 用小写字母,多个单词用_隔开  
类名   用大驼峰形式(UpperCamelCase)

* 变量初始化必须赋值
* divmod(x,y)   //同时获得商和余数
* 幂运算:**     //优先级高于乘法
* 逻辑运算符号:and or
* 进制表示(不区分大小写)
>0o    八进制  
0x    十六进制  
0b    二进制  

* 序列
>列表用中括号表示  
元组用小括号表示,不能够修改  
字典用花括号表示(一个元素是键值对)  

* 数量类型分类
>按存储模型分:  
>>标量:数字,字符串  
容器:列表,元祖,字典  

>按更新模型分:  
>>不可变:数字,字符串,元祖  
可变:列表,字典  

>按访问模型分:  
>>直接:数字  
顺序:字符串,列表,元祖  
映射:字典  

* 字符串替换:%
>xx='...%s...' %变量  
xx='...%s...%s...' %(变量1,变量2)  
print('...%s...' %变量)  

* 成员关系判断:in
>'i' in str  
'hi' in list  
```python
if '' in '123':           #这个判断为真,空字符属于字符串
if '' in  ['1','2','3']   #这个判断就为假了
```

* 三个引号可以在输入时,保存回车等输入的样式
>a='''xx  
yy  
zz'''  

* 指定分隔符输出
>print(str1,str2,sep='xxx')  

* 循环
```python
for i in range(n):  
    pass

while xx:  
    pass

#都可以与else结合使用  
else:     #当循环自然停止时,执行else语句,被break终止时不执行  
    pass
```

* return m if x>5 else n    
>如果x>5返回m,否则返回n  

* int指定进制
>int('11',base=2)   //表示11为2进制数,返回的结果为3  

* **bytes和str的转换**
```       
str类型的表示方式:    'xx'
bytes类型的表示方式:  b'xx'
bytes类型的数据,一个字节正好能表示成一个ASCII字符,所以就显示成字符
而一个汉字需要占3个字节,一个字节用16进制表示形如:\xaa
str转换成bytes:
    s.encode()
bytes转换成string:
    d.decode()
```
* 变量赋值

（1）多元赋值
```python
  a,b=1,2   #a=1,b=2
  a,b='12'  #a='1',b='2'
  a,b=[1,2] #a=1,b=2
  a,b=(1,2) #a=1,b=2
```
（2）变量交换
```python
  a,b=b,a   #a,b交换数值
```

* python模块布局
```python
#!/usr/local/bin/python    

"""描述信息
xxx"""

import xx

global_var=xx

class xx:

def func():

if __name__=='__main__'
  程序主体
```
* pass代表空动作

* **func(\*args,\*\*kwargs)这样的函数能接收任意参数**
>因为*args会用元组来接受，当它无法接受时，\*\*kwargs会接着接受  
\*\*kwargs是用字典来接受参数   
因为参数参数是值和键值对结合的方式(值必须写在最前面,且按照顺序)  
所以这样接受，能接受任意和任何类型的参数  

### 模块
（1）一个以.py结尾的python程序就是一个模块(模块名去除.py即可)
（2）编写一个模块
```python
"""模块名
描述信息
"""
...
def xx():
  "函数描述信息"
  ...
...
```
（3）使用一个模块
**导入模块时,python在sys.path定义的路径中搜索模块**
```python
  import xx         #即运行一遍该模块
  help(xx)
  xx.function()
  xx.variable
```
（4）导入模块中的某些功能
```python
  from xx import function1,function2,...
```

（5）导入模块时起别名
```python
  import xx as yy
```

（6）每个模块都有一个特殊的变量:\_\_name\_\_    
```python
#用来控制导入模块时,是否执行相应代码
#当模块文件直接运行时,该__name__变量的值为__main__
#当模块间接运行(被import导入)时,__name__变量的值为模块名
if __name__=='__main__':     #直接输入main,然后按下tab
    ...
```
### 常用简单模块
（1）随机数模块：random
```python
  import random
  random.choice(xx)           #里面可以时字符串,列表等等
  random.randint(0,9)         #包括最后一个元素
```
（2）位置参数模块：sys
```python
  import sys
  sys.argv                  #返回一个列表,包含位置参数
  sys.argv[0]               #返回程序名  
  ...
```
（3）subprocess（用于执行系统命令）
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
### 文件操作
**文件对象是可迭代对象**
**注意 文件指针的移动**

（1）读取文本文件(**用for循环读取,for line in f**)
```python
  f=open('xx')
  data=f.read()
  data=f.readline()     #读取一行
  data=f.readlines()    #读取所有行放入列表
  f.close()
```

（2）以bytes方式读取文件(**用whiled循环读取,终止条件 if not data**)  
```python
#用于处理非文本文件,如可执行程序
  f=open('xx','rb')
  data=f.read(4096)    #括号填字节数,一个块为4096字节,所以一般一次读取4096字节
  f.close()
```
（3）写文本文件
```python
  f=open('xx','w')    #w模式,清空或创建文件,a模式,必要时创建文件
  f.write('xx')      
  f.close()
```

（4）**with语句**  
```python
 #适用于对资源访问的场合,无论是否异常退出,都会执行必要的清理操作
  with open('xx') as fobj1,open('yy') as fobj2:
    ...
```

（5）移动文件指针(**当打开文件后才会有 文件指针**)
```python
  f.tell()        #当前文件指针所在的位置
  f.seek(-2,2)    #第一个参数是偏移量
                  #第二个参数是相对位置,0表示开头,1表示当前位置,2表示结尾
```
# exception
* 常见异常
```python
  NameError             #没有声明或初始化对象
  IndexError
  SyntaxError           #语法错误
  KeyboardInterrupt     #用户终端(按ctrl+c)
  EOFError              #读到EOF(按ctrl+d)
  IOError               #输入/输出操作失败
```
* 处理异常
```python
  try:
    ...               //可能发生异常的程序,不会发生异常的不要放在里面
  except xx:          //多个异常:(xx1,xx2,..)
    ...               //捕获异常
  else:               //不发生异常会执行
    ...
  finally:            //无论如何都会执行
    ...
  ...                 //继续执行下面的程序,除非上面指明退出(exit())
```
* 触发异常(自己编写)
```python
如:
  if n>200:
    raise ValueError('n的值超过了200')

或者使用 断言异常:

  assert n<=200,'n的值超过了200'    //这里产生的异常是:AssertionError
```
#生成器
**潜在可以提供很多数据**
**不会立即生成全部数据,所以节省内存空间**
**生成器对象通过迭代访问,访问一次后,里面的数据就没有了**
* 通过 生成器表达式 生成 生成器对象
```python
  (10+i for i in range(10))
  ('hello' for i in range(100))
```
* 通过函数,多次使用yeild语句 生成 生成器对象
```python
  def mygen():
    yield 10
    yield 'hello'
    n=10*2
    yield n
  mg=mygen()    //mg就是一个生成器对象
```
