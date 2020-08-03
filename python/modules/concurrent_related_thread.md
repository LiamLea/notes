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

#### 4.递归锁
* 这个锁可以被同一个人acquire多次
* acquire多少次就必须release多少次，否则别人无法acquire这个锁
* 作用：
  * 当线程需要同时获取某两个锁时，才能执行，如果只获取其中一个，另一个被另一个线程获取，就会发生死锁
  * 所以用同一把锁 锁住两个变量，一个线程获得其中一把锁，其他线程就无法获取该锁，所以被该锁 锁住 的两个变量，只能只能被一个线程操作
* 特点：
  * 性能较低
  * 尽量用一把互斥锁，从而避免死锁

可能死锁的代码
```python
from threading import Lock

lock1 = Lock()
lock2 = Lock()

def thread1():
    lock1.acquire()
    lock2.acquire()
    pass
    lock2.release()
    lock1.releas()

def thread2():
    lock2.acquire()
    lock1.acquire()
    pass
    lock1.release()
    lock2.release()

#当启动连个线程同时执行thread1和thread2两个函数时，可能会发生死锁
#当thread1获得lock1锁，thread2获取lock2锁，此时就会死锁

```

快速解决死锁：把所有的互斥锁都改成一把递归锁
```python
from threading import RLock

locl1 = lock2 = RLock()

def thread1():
    lock1.acquire()
    lock2.acquire()
    pass
    lock2.release()
    lock1.releas()

def thread2():
    lock2.acquire()
    lock1.acquire()
    pass
    lock1.release()
    lock2.release()

```

#### 5.上下文管理
threading.local对象，用于为每个线程开辟一块空间来保存该线程独有的值
```python
local_obj = threading.local()

#可以存储一些变量，这个变量被各个线程独有
def func(val):
  local_obj.k1 = val
  print(local_obj.k1)

for i in range(20):
  th = threading.Thread(target = func, args = (i, ))
  th.start()
```
