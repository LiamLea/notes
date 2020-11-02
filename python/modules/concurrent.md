# concurrent
[toc]
### 概述
#### 1.Future对象
* Future对象用于开辟一块空间，用于保存将来的结果
  * 比如开启一个线程执行一个任务，可以创建一个Future对象，刚开始Future对象内没有数据，当线程结束后，会将执行结果存入Future对象中

#### 2.Future对象的属性
* `_condition`
用于保证 Future 对象内的线程安全
* `_state`
用于 保存 线程的状态（比如：RUNNING、FINISHED等）
* `_result`
用于 保存 线程的返回结果
* `_exception`
用于 捕捉 线程产生的异常
* `_waiters`
用于 标识Future对象内 等待运行的函数
* `_done_callbacks`
用于 标识Future对象内 完成运行的函数

#### 3.进程和线程启动数量
* `cpu_count * 1 < 进程数 < cpu_count * 2`
* `线程数 = cpu_count * 5`

#### 4.进程间数据是独立的，不能共享数据（子进程会 复制 主进程的数据）
即子进程不能操作主进程中的数据，如果需要操作主进程中的数据可以利用回调函数
```python
from concurrent.futures import ProcessPoolExecutor

t = []
def call_back(future):
  t.append(future.result())

process_pool = ProcessPoolExecutor(<NUMBER>)

process_pool.submit(<func_name>,*args，**kwargs).add_done_callback(call_back)
```

***

### 使用
#### 1.线程池和进程池
不能清空线程池，当线程池满了，会自动清空（之前使用过的线程）
```python
from concurrent.futures import ThreadPoolExecutor
from concurrent.futures import ProcessPoolExecutor

#创建线程池（需要指定最大线程数）
#设置最大线程数（没有其他关于线程数的配置了）
thread_pool = ThreadPoolExecutor(<NUMBER>)      

#提交任务到线程池
#返回一个Future对象，用于保存结果，这一步不会阻塞（结果可能还没存入这个对象，所以叫未来对象）
future = thread_pool.submit(<func_name>,*args，**kwargs)

#获取执行结果，这一步会阻塞，直到任务执行结束并返回结果
#注意：  
#   当使用future.result这个方法时，如果线程中的任务出现异常，则程序会抛出异常，当不使用这个方式时，Future对象会自动捕获异常，不会抛给程序
future.result()

#在当前线程中，添加回调函数，添加的这个动作是非阻塞的
#当Future对象执行完成，会自动调用该回调函数，并将Future对象作为参数传给回调函数
future.add_done_callback(<callback_func>)
```

#### 2.当回调函数需要扩展参数时：paritial偏函数
```python
from functools import partial

def when_finished(future, id):
  pass

new_when_finished = partial(when_finished, id = 1)
ret.add_done_callback(new_when_finished)
```

#### 3.Future对象的方法
```python
future.running()        #判断是否正在运行（返回True或False）
future.done()           #判断是否完成（取消也是完成，返回True或False）

future.result(timeout = <NUM>)    #阻塞，获取线程的执行结果
                                  #可以设置阻塞时间，超时会抛出TimeoutEorror异常

future.exception()                #阻塞，获取线程发生的异常

future.cancel()         #取消提交的任务，如果任务已经在线程池中运行了，就取消不了
                        #如果取消了返回True，否则返回False
```

#### 4.常用函数
* `as_completed`
  * as_completed接受future的可迭代对象
  * 在没有任务完成的时候，会阻塞
    * 在有某个任务完成的时候，会yield这个任务，就能执行for循环下面的语句
    * 然后继续阻塞住，循环到所有的任务结束
```python
from concurrent.futures import as_completed

for future in as_completed(future_list):
    pass
```
