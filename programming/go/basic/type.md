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
      - [5.Reflection](#5reflection)
        - [(1) The Laws of Reflection](#1-the-laws-of-reflection)
        - [(2) `reflect.Kind` vs `reflect.Type`](#2-reflectkind-vs-reflecttype)
        - [(3) `reflect.Type` (`reflect.TypeOf` returns)](#3-reflecttype-reflecttypeof-returns)
        - [(4) `reflect.Value` (`reflect.ValueOf` returns)](#4-reflectvalue-reflectvalueof-returns)

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

* The **static type** of the interface determines what methods may be invoked with an interface variable, even though the concrete value inside may have a larger set of methods.
* e.g.
```go
var r io.Reader
tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
if err != nil {
    return nil, err
}
r = tty

// r is an interface variable: (tty, *os.File)
// r can't call write method because its staic type of the interface is io.Reader

var w io.Writer
w = r.(io.Writer)

// w is an interface variable: (tty, *os.File)
// w can call write method

var empty interface{}
empty = w

// empty is an interface variable: (tty, *os.File)
```

##### (1) interface value
* `var r io.Reader`
* A variable of interface type (`r` which is `io.Reader` type) 
	* stores a pair: value and the value's **concrete type** instead of **interface type**
	* `(<value>, <concrete_type>)`
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

*  asserts that the interface value `<var>` holds the concrete type `<type>` and assigns the underlying `<type>` value to the variable `v` (i.e. the type of `v` is `<type>`)
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

#### 5.Reflection
reflection is just a mechanism to examine the type and value pair stored inside an interface variable at **running time**


##### (1) The Laws of Reflection

* interface value -> reflection object
	```go
	var x float64 = 3.4
	fmt.Println("type:", reflect.TypeOf(x))
	```
	* When we call reflect.TypeOf(x), x is first stored in an **empty interface**

* reflection object -> interface value
	* Given a reflect.Value we can recover an interface value using the Interface method; in effect the method packs the type and value information back into an interface representation and returns the result
	```go
	fmt.Println(v.Interface())
	```

* To modify a reflection object, the value must be settable

##### (2) `reflect.Kind` vs `reflect.Type`

* Type is named type, such as `MyInt`, `map[string]int`
* Kind is underlying category, such as `int`, `map`, `struct`, `ptr`
```go
type Kind uint

const (
	Invalid Kind = iota
	Bool
	Int
	Int8
	Int16
	Int32
	Int64
	Uint
	Uint8
	Uint16
	Uint32
	Uint64
	Uintptr
	Float32
	Float64
	Complex64
	Complex128
	Array
	Chan
	Func
	Interface
	Map
	Pointer
	Slice
	String
	Struct
	UnsafePointer
)
```

##### (3) `reflect.Type` (`reflect.TypeOf` returns)
```go
type Type interface {
	// Kind returns the specific kind of this type.
	Kind() Kind

	// String returns a string representation of the type
	String() string

	// Elem returns a type's element type.
	// It panics if the type's Kind is not Array, Chan, Map, Pointer, or Slice.
	Elem() Type

	// ...
}
```

* Elem()
	* returns the type of the elements contained in the container-type

| Container Type   | `Elem()` returns                     |
|------------------|--------------------------------------|
| `[]T` (slice)     | `T`                                  |
| `[N]T` (array)    | `T`                                  |
| `map[K]V`         | `V` (value type)                     |
| `chan T`          | `T`                                  |
| `*T`              | `T`                                  |
| `interface{}`     | The dynamic type inside the interface |

##### (4) `reflect.Value` (`reflect.ValueOf` returns)

```go
type Value struct {
	// contains filtered or unexported fields
}

// Interface returns v's value as an interface{}.
func (v Value) Interface() interface{}

// returns v's Kind. If v is the zero Value (Value.IsValid returns false), Kind returns Invalid
func (v Value) Kind() Kind

// if v's Kind is not String, it returns a string of the form "<T value>" where T is v's type
func (v Value) String() string

// Elem returns the value that the interface v contains or that the pointer v points to.
// It panics if v's Kind is not Interface or Pointer.
func (v Value) Elem() Value

// ...
```