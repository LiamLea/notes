# routine

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [routine](#routine)
    - [概述](#概述)
      - [1.goroutine](#1goroutine)
      - [2.协程调度：GMP调度模型](#2协程调度gmp调度模型)
      - [3.context接口](#3context接口)
    - [使用](#使用)
      - [1.基本使用](#1基本使用)
        - [（1）开启一个协程：`go`](#1开启一个协程go)
        - [（2）退出一个协程](#2退出一个协程)
      - [2.协程安全的计数器：`WaitGroup` (i.e. global variable)](#2协程安全的计数器waitgroup-ie-global-variable)
      - [3.协程间的通信：channel (i.e. shared memory)](#3协程间的通信channel-ie-shared-memory)
        - [（1）创建和关闭channel](#1创建和关闭channel)
        - [（2）在channel中生产和消费](#2在channel中生产和消费)
        - [（3）利用`range`读取channel数据](#3利用range读取channel数据)
        - [（4）channel multiplexing（处理多个channel）：`select`](#4channel-multiplexing处理多个channelselect)
      - [4.worker pool（goroutine池）](#4worker-poolgoroutine池)

<!-- /code_chunk_output -->

### 概述

#### 1.goroutine
协程，也叫用户态线程，由go语言自己控制，对操作系统来说不可见
协程之间通过channel进行通信

#### 2.协程调度：GMP调度模型
* G:goroutine
* M:内核线程
* P:processor（一个goroutine队列），P的数量一般设为跟物理cpu的核心数一样
  * 通过设置GOMAXPROCS能够限制最多使用的cpu核心数
  ```go
  runtime.GOMAXPROCS(2) //最多使用两个cpu核心
  ```

![](./imgs/routine_01.jpeg)

#### 3.context接口
用于处理多个goroutine之前 与数据、信号等相关的操作
该接口定义了4个方法
```go
type Context interface {
  Deadline()(deadline time.Time, ok bool)
  Done() <-chan struct{}
  Err() error
  Value(key interface{}) interface{}
}
```

***

### 使用

#### 1.基本使用

##### （1）开启一个协程：`go`
```go
func myFunc(arg interface{}) {
  fmt.Println(arg)
}

func main() {
  go myFunc("aaaa")   //开启一个协程，执行myFunc("aaaa")，非阻塞的
}
```

##### （2）退出一个协程
```go
runtime.Goexit()
```

#### 2.协程安全的计数器：`WaitGroup` (i.e. global variable)
WaitGroup其实就是一个加锁的计数器
* 初始化一个计数器：`var wg sync.WaitGroup`，wg的初始值为0
* 每次执行`wg.Done()`时，wg的值会`-1`
* 每次执行`wg.ADD(n)`时，wg的值会`+n`
* `wg.Wait()`会一直阻塞到wg的值变为0
```go
var wg sync.WaitGroup

func func1(i int) {
	defer wg.Done()
	fmt.Println(i)
}

func main() {
	for i:=0;i<=10;i++{
		wg.Add(1)
		go func1(i)
	}
	wg.Wait()

	print("main")
}
```

#### 3.协程间的通信：channel (i.e. shared memory)

channel是有**类型的**，每个channel只能传输特定类型的数据

##### （1）创建和关闭channel
关闭channel后，不能发送数据了，但是可以从channel中继续读取数据
```go
//创建一个int类型的channel，该channel的大小为10（不设置的话为1），
//表示该channel能够缓冲10个int类型的数据
//当channel满时，再往channel中写时，会阻塞，除非有协程消费channel中的数据
c := make(chan int, 10)  

//关闭一个channel（channel关闭后，还是能够从中读取值的）
close(c)

//判断channel是否关闭
if data, ok := <-c; ok {
  fmt.Println("get data from channel：", data)
} else {
  fmt.Println("channel is closed")
}
```

* 单项通道
```go
//表示ch1这个通道只能写入值，不能读取值
func func1(ch1 chan<- int) {
  ...
}

//表示ch1这个通道只能读取值，不能写入值
func func2(ch1 <-chan int) {
  ...
}

func main() {
  c := make(chan int, 10)
  func1(c)
  func2(c)
}
```

##### （2）在channel中生产和消费
```go
c := make(chan string, 10)

//生产
c <- "xxxx"

//消费
temp := <- c
fmt.Println(temp)
//xxxx
```

##### （3）利用`range`读取channel数据
```go
c := make(chan int)
for data := range c {   //会阻塞
  ...
}
```

##### （4）channel multiplexing（处理多个channel）：`select`

select工作原理（多路复用）：
* 一个case就是一个外部通道，select维护着自己的一个通道（队列）
* 某个case的条件满足了，就会放入到select的通道中
* 执行select时，select会从自己的通道中，拿取case，如果其中没有case，则会用自己设置的default（如果没有设置default，就会阻塞）

```go
for {
  select {
  case <- chan1:
    //如果能从chan1读取数据，则执行这里的代码
  case chan2 <- 1:
    //如果往chan2中写入1，则执行这里的代码
  default:
    //否则执行这里的代码
  }
}
```
* Demo
```go
c1 := make(chan int, 10)
c2 := make(chan int, 10)

for i:=1;i<=9;i++{
  select {
  case c1 <- 1:
    fmt.Println("c1---",i)
  case c2 <- 2:
    fmt.Println("c2---",i)
  default:
    fmt.Println("default",i)
  }
}

// c1--- 1
// c1--- 2
// c2--- 3
// c1--- 4
// c1--- 5
// c2--- 6
// c1--- 7
// c2--- 8
// c2--- 9
```

#### 4.worker pool（goroutine池）
```go
func worker(jobs <-chan string, wg *sync.WaitGroup){
	defer wg.Done()
	for job := range jobs {
		...
	}
}

func main() {
	jobs := make(chan string, 10)
	wg := new(sync.WaitGroup)

	//这里设置创建三个goroutine（即worker pool为3)
	for i:=1;i<=3;i++ {
		wg.Add(1)
		go worker(jobs, wg)
	}

	//这里创建了5个任务，通过channel交给3个goroutine去执行
	for i:=1;i<=5;i++{
		jobs <- "xxx"
	}

	close(jobs)    //任务都已经放进channel了，所以可以先关闭，不影响消费
	wg.Wait()
}
```