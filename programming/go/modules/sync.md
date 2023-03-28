# sync

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [sync](#sync)
    - [使用](#使用)
      - [1.互斥锁：mutex](#1互斥锁mutex)
      - [2.读写锁](#2读写锁)
      - [3.执行多次时，确保某个函数只执行一次（常在并发中使用）](#3执行多次时确保某个函数只执行一次常在并发中使用)
      - [4.协程安全的map](#4协程安全的map)
      - [5.提供一些原子函数：`atomic.xx`](#5提供一些原子函数atomicxx)

<!-- /code_chunk_output -->

### 使用

#### 1.互斥锁：mutex
```go
var lock sync.Mutex

lock.Lock()
lock.Unlock()
```

#### 2.读写锁
```go
var rwlock sync.RWMutex

//写锁，只能同时被一个人获取
rwlock.Lock()
rwlocl.Unlock()

//读锁，可以同时被多个人获取（但是加了读锁，就不能获取写锁）
rwlock.RLock()
rwlock.RUnlock()
```

#### 3.执行多次时，确保某个函数只执行一次（常在并发中使用）
```go
var once sync.Once

//当执行多次func1函数时，其他的<func_name>()只会执行一次
func func1 () {
  once.Do(<func_name>)
}
```

#### 4.协程安全的map
```go
var m = sync.Map{}
func main() {
	m.Store("a", "1")
	m.Store("b", "2")
	value, _ := m.Load("a")
	fmt.Println(value)
}
```

#### 5.提供一些原子函数：`atomic.xx`
即这些函数是原子的，是协程安全的
