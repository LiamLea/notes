# asyncio

[toc]

### 概述

#### 1.高层级API和低层级API
要在程序中使用协程，依赖这两种API
* 高层级API就是已经用协程写好的模块，协程只支持用协程写好的模块（比如：asynchttp、asyncssh等）
  * 所以不是所有程序都可以使用协程，依赖已有的协程模块
* 低层级API用于编写自己的协程代码（比如：async、await等关键字）

#### 2.基础概念
* event_loop
事件循环，把 协程对象 注册到事件循环上
</br>
* coroutine
协程对象，即使用`async`关键字定义的函数，这样 每次调用函数 就会返回一个 协程对象
</br>
* task（是Future的子类）
任务，是对 协程对象 的封装，包含了任务的各种状态
</br>
* future
跟task差不多，包含了任务的各种状态，当协程结束后，会将执行结果存入Future对象中

#### 3关键字

##### （1）`async`
用于修改函数，被修饰的函数被执行就返回 协程对象

##### （2）`await`
只有awaitable的函数，使用await才有意义
* awaitable的函数都是用协程开发的函数
  * 比如：asyncio.sleep()、asyncssh中的函数等

***

### 使用

#### 1.简单使用

##### （1）基本使用
```python
#定义一个协程对象
#执行func()函数就会得到一个 协程对象
async def func():
  pass

#定义回调函数，接收future对象
def callback(future):
  pass

#创建事件循环
loop = asyncio.get_event_loop()

#创建task
task1 = loop.create_task(func())
task2 = loop.create_task(func())
tasks = [task1, task2]
#task绑定回调函数，Future对象（包含执行结果）会作为参数传给回调函数
task1.add_done_callback(callback)

#运行任务（这里会阻塞，直到所有任务完成）
result = loop.run_until_complete(asyncio.wait(tasks))

# 获取执行结果
for task in tasks:
  print(task.result())
```

##### （2）gather和wait区别
这两个函数都是非阻塞的，只是获取结果的方式不同
* `asyncio.gather(task1, task2)`
`result = loop.run_until_complete(asyncio.gather(task1,ttask2))`
按顺序获取执行的结果，返回结果：[task1的结果, task2的结果]
</br>
* `asyncio.wait(task1, task2)`
谁先结束，结果就放在前面，如果task2先结束，返回结果：[task2的future对象, task1的future对象]

##### （3）设置协程数
```python
sem = asyncio.Semaphore(3)


async def safe_download(i):
    async with sem:  # semaphore limits num of simultaneous downloads
        return await download(i)
```

##### （4）与线程和进程结合（能够用await修饰尚未移植到asyncio的旧代码：比如time.sleep(5))
其实就是线程和进程，只不过通过asyncio来调用

```python
from concurrent.futures import ThreadPoolExecutor
executor = ThreadPoolExecutor(max_workers=5)

await loop.run_in_executor(executor, time.sleep, 5)
```

***

### asyncssh

#### 1.使用
* 不使用sudo
```python
import asyncio, asyncssh, sys

async def run_client():
    async with asyncssh.connect(host = '3.1.5.19', port = 22, username = "root", password = "Cangoal_123") as conn:
        result = await conn.run('dmidecode -t system')
        print(result.stdout)

try:
    asyncio.get_event_loop().run_until_complete(run_client())
except (OSError, asyncssh.Error) as exc:
    sys.exit('SSH connection failed: ' + str(exc))
```

* 使用sudo
```python
import asyncio, asyncssh, sys

async def run_client():
    async with asyncssh.connect(host = '3.1.5.19', port = 22, username = "lil", password = "xxx") as conn:
        async with conn.create_process('sudo -S -p '' -i dmidecode -t system') as process:
            process.stdin.write("xxx\n")
            result = await process.stdout.read()
            print(result)

try:
    asyncio.get_event_loop().run_until_complete(run_client())
except (OSError, asyncssh.Error) as exc:
    sys.exit('SSH connection failed: ' + str(exc))
```
