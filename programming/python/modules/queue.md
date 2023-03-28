# queue

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [queue](#queue)
    - [使用](#使用)
      - [1.队列](#1队列)
      - [2.栈](#2栈)
      - [3.优先级队列](#3优先级队列)

<!-- /code_chunk_output -->

### 使用
#### 1.队列
```python
import queue

#定义一个队列（不指定长度，长度无限）
q = queue.Queue(<NUMBER>)     

#当规定了长度并且队列已满，put就会阻塞
q.put(<OBJECT>)

#获取队首的一个对象（当队列为空时会阻塞）
q.get()

#当队列为空时，不会阻塞，会报一个错误
q.get_nowait()

```

#### 2.栈
```python
import queue

stack = queue.LifoQueue()
```

#### 3.优先级队列
```python
pq = queue.PriorityQueue()

#传入一个元组，第一个元素为该对象的优先级
#优先级高的对象放在队首，取的时候，就会先被取出
pq.put((<int>, <OBJECT>))
```
