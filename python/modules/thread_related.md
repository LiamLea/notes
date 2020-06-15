# Thread
[toc]
### 概述
#### 1.GIL
##### （1）定义
* global interpreter lock，全局解释器锁
* 是一个全局的互斥锁
* 为了保证同一进程内的线程安全，因为同一进程内的线程共享数据
##### （2）特点
* 同一时间，在同一进程内，只有一个线程能被cpu执行，不能利用cpu多核的优势，所以不适合CPU密集型程序
* 适合IO密集型程序，因为IO不需要CPU
##### （3）解决方案
利用多线程处理cpu密集型程序（multiprocessing模块）

### 使用
```python
import thread

t=threading.Thread(target=函数名,args=(参数1,),kwargs={'key1':value1,'key2',balue2})
t.start()
#如果一个参数,不加括号,则会把字符串转换为元组,即每一个字符是一个元素,就会出错
#target=MyClass(),也可以传递一个实例,这个实例有可调用方法(__call__)
```
