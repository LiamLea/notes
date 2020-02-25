#多进程
**解决效率问题
windows系统不知道多进程,只支持多线程
每个进程都有自己独立的运行环境**
* **进程的生命周期**
```mermaid
graph LR
A("parent process")--"fork()"-->B("child process")
B--"exec()"-->C("child process")
C--"exit()"-->D("zombine process")
D--"回收"-->A
```
* **多进程执行**
```python
for i in range(3):
    retval=os.fork()
    if retval==0:
      print('hello')

#打印7个hello
```
```python
for i in range(3):
    retval=os.fork()
    if retval=0:
      print('hello')
      exit()

#打印3个hello,注意两者的区别
```
#多线程
```python
import thread

t=threading.Thread(target=函数名,args=(参数1,),kwargs={'key1':value1,'key2',balue2})
t.start()
#如果一个参数,不加括号,则会把字符串转换为元组,即每一个字符是一个元素,就会出错
#target=MyClass(),也可以传递一个实例,这个实例有可调用方法(__call__)
```
