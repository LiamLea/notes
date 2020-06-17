# concurrent
[toc]
### 概述
#### 1.Future对象
* Future对象用于开辟一块空间，用于保存将来的结果
  * 比如开启一个线程执行一个任务，可以创建一个Future对象，刚开始Future对象内没有数据，当线程结束后，会将执行结果存入Future对象中

#### 2.进程和线程启动数量
* `cpu_count * 1 < 进程数 < cpu_count * 2`
* `线程数 = cpu_count * 5`

***

### 使用
#### 1.线程池和进程池
```python
from concurrent.futures import ThreadPoolExecutor
from concurrent.futures import ProcessPoolExecutor

#创建线程池（需要指定线程数）
thread_pool = ThreadPoolExecutor(<NUMBER>)

#提交任务到线程池
#ret是一个Future对象，用于保存结果，这一步不会阻塞（结果可能还没存入这个对象，所以叫未来对象）
ret = thread_pool.submit(<func_name>,*args，**kwargs)

#获取执行结果，这一步会阻塞，直到任务执行结束并返回结果
ret.result()

#在当前线程中，添加回调函数，添加的这个动作是非阻塞的
#调用回调函数是阻塞的，当有多个线程时，这个就是异步非阻塞（因为不知道哪个线程会先执行完回调函数）
#将Future对象作为参数传给回调函数
ret.add_done_callback(<callback_func>)

```
