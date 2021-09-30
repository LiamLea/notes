# routine

[toc]

### 使用

#### 1.基本使用

* 开启一个协程：`go`
```go
func myFunc(arg interface{}) {
  fmt.Println(arg)
}

func main() {
  go myFunc("aaaa")   //开启一个协程，执行myFunc("aaaa")，非阻塞的
}
```

* 退出一个协程
```go
runtime.Goexit()
```

#### 2.协程间的通信：channel

##### （1）开启和关闭channel
关闭channel后，不能发送数据了，但是可以从channel中继续读取数据
```go
//开启一个channel
c := make(chan int)

//关闭一个channel
close(c)

//判断channel是否关闭
if data, ok := <-c; ok {
  fmt.Println("get data from channel：", data)
} else {
  fmt.Println("channel is closed")
}
```

##### （2）无缓冲channel
channel读和写都会阻塞，即写进一个数据后，直到该数据被消费，才会继续往下执行
```go
func main() {
	c := make(chan int)        //int定义了channel传递的数据类型为int

	go func() {
		fmt.Println("start routine...")
		c <- 666
		fmt.Println("end routine...")
	}()

	time.Sleep(1*time.Second)
	num := <- c
	fmt.Println(num)
}

//start routine...
//(等待1s，后面两条语句的顺序不确定）
//end routine...
//666
```

##### （3）有缓冲channel
```go
func main() {
	c := make(chan int, 1)   //代表只能缓存一个写入（即当第一次写入后未被读出，第二次继续写入会阻塞）

	go func() {
		fmt.Println("start routine...")
		c <- 666
		fmt.Println("end routine...")
	}()

	time.Sleep(1*time.Second)
	num := <- c
	fmt.Println(num)
}

//start routine...
//end routine...
//(等待1s）
//666
```

##### （4）利用`range`读取channel数据
```go
c := make(chan int)
for data := range c {   //会阻塞
  ...
}
```

##### （5）处理多个channel：`select`
注意在select中，不会阻塞（即当出现阻塞情况则代表不符合条件）
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
