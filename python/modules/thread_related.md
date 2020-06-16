# Thread
[toc]
### 概述
#### 1.GIL
##### （1）定义
* global interpreter lock，全局解释器锁
* 是一个全局的互斥锁
* 为了保证同一进程内的线程安全，因为同一进程内的线程共享数据
##### （2）特点
* 同一时间，在同一进程内，只有一个线程能被cpu执行（即同一时间内只能执行一个cpu指令），不能利用cpu多核的优势，所以不适合CPU密集型程序
* 适合IO密集型程序，因为IO不需要CPU
* 仍然会有数据不安全的问题
  * 同一时间内只能执行一个cpu指令
  * `a += 1`，是两条cpu指令，如果执行加后，GIL锁被其他线程获取，并操作a，就会数据不安全
##### （3）解决方案
利用多线程处理cpu密集型程序（multiprocessing模块）

#### 2.特点
* **主线程会等待子线程（不包括守护线程）结束之后才结束**
* **主线程结束，主进程就会结束**
* 子线程是不能从外部terminate
* 同一进程中的线程共享数据

#### 3.守护线程
* 守护线程 随着进程的结束而结束
* 如果主线程结束了，还有其他子线程正在运行，守护线程也守护

***

### 使用
#### 1.基本用法
```python
from threading import Thread

t = Thread(target = xx, args = (xx,))
t.start()         #这是一个异步操作，不会阻塞
t.ident           #获取线程id

t.daemon = True    #将该线程设为守护线程（守护所在进程），在start前设置
```
```python
#获取当前线程的id
from threading import current_thread
current_thread().ident

#获取活着的线程对象（即还没有join的线程）
from threading import enumerate
enumerate()
```

#### 2.`join`
```python

t_list = []

t = Thread(target = xx, args = (xx,))
t.start()
t_list.append(p)

t = Thread(target = xx, args = (xx,))
t.start()
t_list.append(p)

for t in t_list:
    t.join()        #阻塞，直到收到t线程返回值（即执行完毕）
```

#### 3.互斥锁
* 当进行运算赋值、判断时，数据不安全
* 当对列表进行append、pop操作时，数据安全
```python
from threading import Lock

lock = Lock()         #创建一把锁

lock.acquire()        #获取锁
pass                  #临界区的代码
lock.release()        #释放锁

#等价于

#建议使用
with lock:
    pass
```
