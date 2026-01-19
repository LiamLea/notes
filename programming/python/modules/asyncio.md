# asyncio

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [asyncio](#asyncio)
    - [Overview](#overview)
      - [1.callback vs async/await](#1callback-vs-asyncawait)
      - [2.eventloop](#2eventloop)
        - [(1) corountine/task and future](#1-corountinetask-and-future)
        - [(2) async](#2-async)
        - [(3) await](#3-await)
        - [(4) example](#4-example)
      - [3.callback and future](#3callback-and-future)
    - [使用](#使用)
      - [1.简单使用](#1简单使用)
        - [（1）基本使用](#1基本使用)
        - [（2）gather和wait区别](#2gather和wait区别)
        - [（3）设置协程数](#3设置协程数)
        - [（4）与线程和进程结合（能够用await修饰尚未移植到asyncio的旧代码：比如time.sleep(5))](#4与线程和进程结合能够用await修饰尚未移植到asyncio的旧代码比如timesleep5)
    - [asyncssh](#asyncssh)
      - [1.使用](#1使用)

<!-- /code_chunk_output -->

### Overview

#### 1.callback vs async/await

* **Callback hell problem**: It creates a problem when we have multiple asynchronous operations. There it forms a nested structure which becomes complicated and hard to read code.
```python
import time

def legacy_system():
    # Level 1: Get User
    print("Fetching user...")
    get_user_db(101, lambda user: 
        # Level 2: Get Orders (using user['id'])
        print(f"Got user {user['name']}. Fetching orders...")
        get_orders_db(user['id'], lambda orders:
            # Level 3: Calculate Price
            print(f"Got {len(orders)} orders. Calculating total...")
            calculate_total(orders, lambda total:
                # Level 4: Save Log
                print(f"Total is ${total}. Saving log...")
                save_log(f"User {user['id']} spent ${total}", lambda:
                    # Level 5: Final Completion
                    print(">>> Flow Complete!")
                )
            )
        )
    )

# --- Mock functions to make the code runnable ---
def get_user_db(id, cb): cb({"id": id, "name": "Alice"})
def get_orders_db(uid, cb): cb([{"id": 1, "p": 50}, {"id": 2, "p": 30}])
def calculate_total(orders, cb): cb(sum(o['p'] for o in orders))
def save_log(msg, cb): cb()

legacy_system()
```

* how does async solve this problem
```python
import asyncio

async def modern_system():
    try:
        # Step 1: Wait for User
        print("Fetching user...")
        user = await get_user_db(101)
        
        # Step 2: Wait for Orders
        print(f"Got user {user['name']}. Fetching orders...")
        orders = await get_orders_db(user['id'])
        
        # Step 3: Wait for Total
        print(f"Got {len(orders)} orders. Calculating total...")
        total = await calculate_total(orders)
        
        # Step 4: Wait for Log
        print(f"Total is ${total}. Saving log...")
        await save_log(f"User {user['id']} spent ${total}")
        
        print(">>> Flow Complete!")

    except Exception as e:
        # ONE error handler for all four steps!
        print(f"An error occurred somewhere in the chain: {e}")

# --- Modern Mock functions (Returning Awaitables) ---
async def get_user_db(id): return {"id": id, "name": "Alice"}
async def get_orders_db(uid): return [{"id": 1, "p": 50}, {"id": 2, "p": 30}]
async def calculate_total(orders): return sum(o['p'] for o in orders)
async def save_log(msg): pass

asyncio.run(modern_system())
```

#### 2.eventloop

**a single-thread system to manage tasks**

##### (1) corountine/task and future
* task is a corountine object that is running in eventloop

##### (2) async
* create a corountine which can be put into eventloop

##### (3) await
* a signal that tells eventlop that I’m stuck waiting for the completion of this code
* so codes in a function modified by `await` can run in order 

##### (4) example
```python
import asyncio

async def slow_database_fetch():
    async def inner():
        print("inner: start")
        await asyncio.sleep(1)
        print("inner: end")
        return 123

    print("slow_database_fetch: before awaiting inner")
    result = await inner()
    print("slow_database_fetch: result =", result)

async def do_other_work():
    await asyncio.sleep(1)
    return "Other work done"

async def main():
    # put tasks(slow_database_fetch, do_other_work) in the event loop
    # wait for the results of the 2 tasks
    results = await asyncio.gather(
        slow_database_fetch(),
        do_other_work()
    )
    print(results)

# create the event loop
# put the main task in
asyncio.run(main())
```
* 3 tasks, but only 2 of them are “concurrent work tasks"

#### 3.callback and future

In modern asyncio, you can handle results for “every condition” without manually using callbacks or creating Futures yourself

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
