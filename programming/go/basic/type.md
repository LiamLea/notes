# type


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [type](#type)
    - [overview](#overview)
      - [1.types](#1types)
        - [(1) basic types](#1-basic-types)
        - [(2) composite types](#2-composite-types)
        - [(3) interface](#3-interface)
        - [(4) user-defined types](#4-user-defined-types)
        - [(5) special types](#5-special-types)
      - [2.method](#2method)
        - [(1) function vs method](#1-function-vs-method)
      - [3.interface](#3interface)
        - [(1) interface value](#1-interface-value)
        - [(1) empty interface](#1-empty-interface)
      - [4.type determination](#4type-determination)
        - [(1) type assertions](#1-type-assertions)
        - [(2) type switches](#2-type-switches)

<!-- /code_chunk_output -->

### overview

#### 1.types

##### (1) basic types
* int
* float
* bool
* string
* ...

##### (2) composite types
* array
* slice
* map
* structure
* pointer
* func
* ...

##### (3) interface
* An interface type is defined as a set of **method signatures**
  * method signature defines a method's:
    * name
    * parameters
    * return values
* A value of interface type can hold any value that implements those methods

##### (4) user-defined types

```go
// named types
type MyInt int

//type aliases
type MyString = string
```

##### (5) special types
* error
* nil

#### 2.method

##### (1) function vs method
* a method is just a function with a **receiver** argument
  * common use is **pointer receiver** (e.g. `v *Vertex` below)
    * pointer receiver can point to any type (`*T`)
      * `T` cannot itself be a pointer such as `*int`
    * uncommon use is value receiver([ref](https://go.dev/tour/methods/1))
```go
type Vertex struct {
	X, Y float64
}

func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
```

#### 3.interface

##### (1) interface value
* Under the hood, interface values can be thought of as a tuple of a value and a concrete type
  * `(<value>, <type>)` 
    * e.g. `v: (&{3, 4}, *Vertex)` below
    * empty interface value: `(nil, nil)`
  * so a interface type can express every specific implementation of it

```go
type Abser interface {
	Abs() float64
}

type Vertex struct {
	X, Y float64
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	var a Abser
	v := Vertex{3, 4}

	a = &v // a *Vertex implements Abser

	// In the following line, v is a Vertex (not *Vertex)
	// and does NOT implement Abser.
	a = v
}
```

##### (1) empty interface
* hold values of any type
```go
var i interface{}

i = 42
```

#### 4.type determination

##### (1) type assertions

```go
v, ok := <var>.(<type>)
```

* e.g.
```go
if v, ok := result.([3]int); ok {
    for _, item := range v {
        fmt.Println(item)
    }
}
```

##### (2) type switches

```go
switch v := i.(type) {
case <type1>:
    // here v has type <type1>
case <type2>:
    // here v has type <type2>
default:
    // no match; here v has the same type as i
}
```

* e.g,
```go
func do(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Printf("Twice %v is %v\n", v, v*2)
	case string:
		fmt.Printf("%q is %v bytes long\n", v, len(v))
	default:
		fmt.Printf("I don't know about type %T!\n", v)
	}
}

func main() {
	do(21)
	do("hello")
	do(true)
}
```