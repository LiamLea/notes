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
type Book struct {
	name string
	auth string
}

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

#### 4.多态的实现：`interface`
```go
type AnimalIF interface {
  Sleep()
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
