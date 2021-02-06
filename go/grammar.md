### 概述

#### 1.基本语法
* 只有package main这个包，才能build，生成可执行文件
  * 并且该包内，必须有main函数，该函数为整个程序的入口
* 函数外只能写声明语句
* 具体的语句（包括变量的赋值等）必须写在函数内部
* go语言中的变量必须先声明，再使用

##### （1）声明变量：`var`
* 在函数内声明的变量，如果没有使用，编译时会报错
```go
var <VARIABLE> <TYPE>
//var name string
//var age int
//var isok bool

// 批量声明变量
var {
  <VARIABLE> <TYPE>
  <VARIABLE> <TYPE>
}

//声明变量并且赋值
var <VARIABLE> <TYPE> = <VALUE>
var <VARIABLE> = <VALUE>
<VARIABLE> := <VALUE>
```

* 如果想要忽略一个变量（即不使用），需要使用 `_`
```go
func main() {
  x, _ = func()   //func()函数返回两个变量，一个变量赋值给x，另一个变量忽略，如果不忽略的话，就必须在这个函数内使用该变量
  fmt.Println(x)
}
```


##### （2）声明常量：`const`
```go
const (
  n1 = 3.1415
  n2 = 4
  n3    //如果n3没有指定值，则n3 = n2
)
```

#### 2.字符串

##### （1）概述
只能用双引号（单引号只能用于字符）
```go
s1 := "hello"
c1 := 'a'
//单引号内的内容原样输出，包括换行等
s2 := `
diyihang
dierhang
`
```

##### （2）相关操作
* 长度：`len(xx)`
* 拼接：`+`
* 分割：`xx.Split()`

##### （3）字符类型
* byte类型
一个ascii码字符
* rune类型
一个utf-8字符，比如："你" 就是一个rune类型的字符


#### 3.流程控制
##### （1）if
```go
if <EXPRESSION> {
  ...
}
else {
  ....
}
```

##### （2）循环（只有for循环）
```go
//初始语句 和 结束语句 都可以省略，但是分号还是要写
for <初始语句>;<条件表达式>;<每次循环的结束语句> {
  ...
}
```

* 无限循环（类似于while）
```go
for {
  ...
}
```

* 遍历可迭代对象：`for range`
```go
s := "adsfdfg"

for i,v := range s {
  ...
}
```

##### （3）switch
```go
switch n {    //根据n的值，执行不同的内容
case xx:
  ...
case xx:
  ...
default:
  ...
}
```

#### 4.运算符
* 逻辑运算符
`&&`、`||`、`!=`


#### 5.数组
```go
var <VARIABLE> [<LENGTH>]<TYPE>

var a1 [3]int   //a1是一个数组，能够存放3个int类型的数据
                //a1的类型是 [3]int，即长度是数组类型的一部分
```

* 数组的初始化
默认如果是int类型，则初始值都是0，如果是bool类型，则初始值都是false

```go
var a1 [3]int{1,2,3}

a2 := [3]int{1,2,3}

a3 := [...]int(1,2,3,4) //... 表示根据初始化的数据，自动设置数据组的长度
```

* 多维数组
```go
a := [3][2]string {
  {"beijing", "shanghai"},
  {"nanjing", "changzhou"},
  {"yangzhou", "nantong"}
}
```

#### 6.切片（类似于列表）
拥有相同元素的可变长度的序列，底层就是数组
切片的长度就是元素的个数
切片的容量就是底层数组从切片的第一个元素到最后一个元素的数据

```go
var <VARIABLE> []<TYPE>
```
* 由数组生成切片
```go
a1 := [...]int{1,2,3,4,5}

s1 := a1[1:3]   // [2,3]，长度：2，容量：4
s2 := a1[:3]    // [1,2,3]，长度：4，容量：5
s3 := a1[1:]    // [2,3,4,5] 长度：4，容量：4
s4 := a1[:]     //长度：5，容量：5
```

* make函数创建切片，可以指定长度和容量
```go
s1 := make([]<TYPE>, <SIZE>, <CAPACITY>)
```

* `append`
```go
s1 := []int{1,2,3}
s2 := []int{4,5,6}

s1 = append(s1, 4, 5)
s1 = append(s1, s2...)   //... 表示当切片拆开成一个个元素
```

* `copy`
```go
s1 := []int{1,2,3}
s2 := make([]int, 3, 3)

copy(s2, s1)   //将s1 copy到s2
```

#### 7.指针
`&`取地址
`*`根据地址取值
```go
//错误的写法
var p1 *int  //p为指针（内存地址），指向一个int类型数据
*p1 = 100 //这样是有问题的，因为p1创建时未初始化，是一个空指针，当*p1时就会报空指针错误

//正确的写法
var p1 = new(int)   //new会开辟新的内存空间
*p1 = 100
```

#### 8.new和make
都是用来分配内存的
new用来给基本的数据类型分配内存，返回的是指针
make用于给slice、map以及channel分配内存，返回的是数据

#### 9.map（类似于字典）
要初始化或者使用make
```go
m1 = make(map[<key_type>]<value_type>, <length>)   //如果容量不够，会自动扩容（最好给出合适的长度，这样避免扩容，提高效率）

//遍历map
for k,v := range m1 {
  ...
}

//删除map指定key
delete(m1, "<KEY>")
```

#### 10.func
```go
func <FUNC_NAME>(<ARGS>)(RETURN) {
  ...
}

//举例
func sum(x int, y int)(ret int) {
  return x + y
}

//等价于，区别就是上面定义了一个ret变量，可以在函数中使用
func sum(x int, y int) int {
  //var ret int
  return x + y
}

//返回多个值
func f3(x int, y int)(int, int) {
  return x + y, x - y
}

func f1(x int, y int) {
  fmt.Println(x + y)
}

func f2(){
  fmt.Println("hhhh")
}
```

* 参数
当参数中 连续多个参数的类型一致时，可以只保留后面的类型
```go
func f1(x, y, z int, m, n, string) int {
  ...
}
```
* 没有默认参数这个概念

* defer
用defer标识的语句，在函数返回之前执行，并且按照从下到上的顺序执行
应用场景：释放某些资源（比如关闭连接）

* 匿名函数（类似lamba）
```go
func(){
  fmt.Println("hhhhh")
}()
```
