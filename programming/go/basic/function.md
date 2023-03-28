# function

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [function](#function)
    - [概述](#概述)
      - [1.特点](#1特点)
    - [使用](#使用)
      - [1.函数基本格式](#1函数基本格式)
        - [（1）当return后面什么都不加时](#1当return后面什么都不加时)
      - [2.传参](#2传参)
      - [3.`defer`关键字](#3defer关键字)
      - [4.万能类型（空接口）：`interface{}`](#4万能类型空接口interface)
      - [5.接收可变数量的参数：`...`](#5接收可变数量的参数)

<!-- /code_chunk_output -->

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

##### （1）当return后面什么都不加时

```go
func test()(a int, b string){
  //...

  //return后面什么都不加，则返回(a int, b string)这里定义的形参，即return a,b
  return
}
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

#### 4.万能类型（空接口）：`interface{}`
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

#### 5.接收可变数量的参数：`...`
```go
//表示参数类型是切片，且切片的元素类型是interface{}
func myFunc(args ...inteface{}){

}

func myFunc2(args ...string){

}
```

* 传入参数
```go
a := []string{"aa", "bbb"}

//a...表示将数组拆开传入
//注意：只能用于函数的接收参数也是可变参数（即切片），且类型要一致）
//参考：https://stackoverflow.com/questions/12990338/cannot-convert-string-to-interface
myFunc2(a...)

//相当于
myFunc2("aa", "bbb")
```
