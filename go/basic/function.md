# function

[toc]

### 概述

#### 1.特点

* 支持多返回值

***

### 使用

#### 1.函数基本格式
```go
func <FUNC_NAME>(<ARGS>) <RETURN_TYPE> {
  ...
}

//举例
func sum(x int, y int) (int, int) {
  return x + y, x - y
}

//举例
func f1(x int, y int) {
  fmt.Println(x + y)
}
```

* 匿名函数（类似lamba）
```go
func(){
  fmt.Println("hhhhh")
}()
```

#### 2.传参

```go
func f1(x, y, z int, m, n, string) int {
  ...
}
```

* 参数类型为 指针
```go
func changeValue(p *int) {
  *p = 10
}

func main () {
  a := 1
  changeValue(&a)
}
```

* 参数类型为 切片
```go
//接收 int类型的 数组 或 切片
//注意这里是引用传递
func f1(a1 []int) {
  ...
}
```

#### 3.`defer`关键字
就是在函数return后执行（类似于类的析构函数）
```go
func main() {
  defer fmt.Println("defer 111")
  defer fmt.Println("defer 222")
  fmt.Println("test1 xx")
}

//结果就是：
//test1 xx
//defer 222
//defer 111
```

#### 4.万能类型：`interface{}`
```go
//可以接收任意类型的数据
func myFunc(arg interface{}) {
  fmt.Println(arg)
}
```

* interface提供断言机制，来判断类型
```go
func myFunc(arg interface{}) {
  value, ok := arg.(string)   //判断arg是否为string类型
}
```
