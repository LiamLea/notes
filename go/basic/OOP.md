# OOP(object oriented program)

[toc]

### 概述

#### 1.结构体：`struct`
定义一种新的数据类型
```go
type <name> struct {}
```

* demp
```go
type Book struct {
  title string  
  auth string `tag1=xx tag2=yy`  //可以添加一些标签，要用这些标签需要使用反射机制
}

func main(){
  var book1 Book
  book1.title = "xiyouji"
  book1.auth = "wuchengen"
}
```

#### 2.类就是通过结构实现的
```go
//定义类：
type Book struct {
	name string
	auth string
}

//定义类的方法：
func (this *Book) getAuth() {
	fmt.Println(this.auth)

}

func (this *Book) setAuth(auth string) {
	this.auth = auth
}

func main()  {
	book1 := Book{name: "xiyouji", auth: "wuchengen"}
	book1.getAuth()
	book1.setAuth("haha")
	book1.getAuth()
}
```

#### 3.类的继承
```go
type HistoryBook struct {
  Book    //继承Book这个类：直接写父类的类名
  country string    //添加一个新的属性
}

func main() {
  //创建HistoryBook的实例
  book2 := HistoryBook{Book: Book{"sanguozhi", auth: "xxx"}, country: "China"}
}
```

#### 4.通过接口实现多态：`interface`
interface是一种**类型**，用于**抽象方法**，只要该类实现了里面定义的所有抽象方法，则该类就是该interface类型
```go
type AnimalIF interface {
  Sleep(int)    //Sleep这个函数需要传入一个int类型的参数
  GetColor()
  GetType()
}

type Cat struct {
  color string
}

func (this *Cat) Sleep() {
  fmt.Println("Cat is sleeping")
}

func (this *Cat) GetColor() string {
  return this.color
}

func (this *Cat) GetType() string {
  return "Cat"
}

func main() {
  var animal AnimalIF
  animal = &Cat("Green")
  animal.Sleep()
}
```

##### （1）同一个结构体可以实现多个接口

##### （2）接口可以相关嵌套
```go
type mover interface {
  move()
}

type eater interface {
  eat()
}

type animal interface {
  mover
  eater
}
```

##### （3）空接口
能接受任何类型
```go
//空接口没有必要起名字
interface {}
```

* 函数可以接收任意类型的变量
```go
//可以接收任意类型的数据
func myFunc(arg interface{}) {
  fmt.Println(arg)
}
```

* map等使用空接口
```go
var m1 map[string]interface{}
```

###### （4）接口类型断言
```go
//val,ok=xx.(<type>)   xx是一个接口，第一个参数返回该接口的值，第二个参数返回判断的结果
func assert(a interface{}) {
  str,ok = a.(string)
}
```

* 跟switch结合
```go
func assert(a interface{}) {
	switch val := a.(type) {
	case string:
		fmt.Println("string：%v", val)
	case int:
		fmt.Println("int: %v", val)
	default:
		fmt.Println("unsupported values")
	}
}
```
