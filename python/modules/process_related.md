# Process
[toc]
### 预备知识
* 同步与异步区别：**通知方式**
请求发出后，是否需要等待结果，才能继续执行其他操作
</br>
* 阻塞与非阻塞区别：**等待过程中的状态**
阻塞和非阻塞这两个概念与程序（线程）等待消息通知(无所谓同步或者异步)时的状态有关
</br>
* 通知方式：
  * 轮询
  * 通知
  * 回调
</br>
* 同步阻塞
发出一个功能调用，等待这个调用的结果，在获取结果之前，当前线程会被挂起
典型的例子：input()、sleep()、get()等
</br>
* 同步非阻塞
发出一个功能调用，等待这个调用的结果，在获得结果之前，当前线程可以去做其他事
典型的例子：strip()、sum()、eval()等函数
</br>
* 异步非阻塞
发出一个功能调用，当前线程去做其他事，当执行完成，会通知当前线程
`p.start()`
</br>
* 异步阻塞
发出一个功能调用，当前线程被挂起，当执行完成，会通知当前线程
典型的例子是：等待多个结果，不知道哪个结果先来
### 概述
![](./imgs/process_related_01.jpg)

#### 1.特点
* windows系统不知道多进程,只支持多线程
* 每个进程都有自己独立的运行环境
* 进程的生命周期
```mermaid
graph LR
A("parent process")--"fork()"-->B("child process")
B--"exec()"-->C("child process")
C--"exit()"-->D("zombine process")
D--"回收"-->A
```

***

### 使用
#### 1. `os.fork()`
底层的命令，其他process相关的模块都是基于这个命令
```python
for i in range(3):
    retval = os.fork()
    if retval == 0:
      print('hello')

#打印7个hello
```
```python
for i in range(3):
    retval = os.fork()
    if retval = 0:
      print('hello')
      exit()

#打印3个hello,注意两者的区别
```
***
### multiprocssing模块
#### 1.基本用法
```python
from multiprocessing import Process

p = Process(target = xx, args = (xx,))
p.start()           #这是一个异步操作，不会阻塞
p.pid               #获取进程的pid
p.terminate()       #强制结束一个子进程，异步非阻塞
```
#### 2.`join()`的用法
```python

p_list = []

p = Process(target = xx, args = (xx,))
p.start()
p_list.append(p)

p = Process(target = xx, args = (xx,))
p.start()
p_list.append(p)

for p in p_list:
    p.join()        #阻塞，直到收到p进程返回值（即执行完毕）
```

#### 3.互斥锁
```python
from multiprocessing import Lock

lock = Lock()         #创建一把锁

lock.acquire()        #获取锁
pass                  #临界区的代码
lock.release()        #释放锁

#等价于

#建议使用
with lock:
    pass
```

#### 4.进程间通信
* 队列
```python
from multiprocessing import Queue

q = Queue()         #创建队列
q.put(xx)           #往队列里存数据
q.get()             #从队列里取数据
```
