# Test

[toc]

### Unit Test

#### 1.Test File:`_test.go`
all test function should be in the file
* test file name must end with `_test.go`
* function name must start with `Test`
* function must accept a parameter which is`*testing.T` type

#### 2.unit test

##### （1）test function
* function name must start with `Test` and parameter must is `*testing.T`
```go
func TestName(t *testing.T) {}
```

##### （2）demo
* `add.go`
```go
package test

func add(x int, y int) int {
	return x+y
}
```

* `add_test.go`
```go
package test

import (
	"reflect"
	"testing"
)

func TestAdd(t *testing.T){

  	type testCase struct{
  		input []int
  		want int
  	}

  	//test cases
  	testGroup := map[string]testCase{
  		"case 1": {input: []int{1,2}, want: 3},
  		"case 2": {input: []int{3,4}, want: 8},
  	}

  	for name,tc := range testGroup {
  		t.Run(name, func(t *testing.T){
  			got := add(tc.input[0], tc.input[1])
  			if !reflect.DeepEqual(got, tc.want){
  				t.Errorf("want: %v but got: %v\n", tc.want, got)
  			}

  		})
  	}
}
```

* execute unit test
```shell
#run the following command in the package directory
go test -v

#view coverage(how many codes in the function will be excuted using these test cases)
go test -cover
go test -cover -coverprofile=xx.out
go tool cover -html=xx.out
```

#### 3.Benchmark Test（performance test）

##### （1）test function
* function name must start with `Benchmark` and parameter must is `*testing.B`
```go
func BenchmarkName(b *testing.B) {
  for i:=0;i<b.N;i++ {
    //run function needed to execute benchmark test
  }
}
```

##### （2）demo

* `add_test.go`
```go
package test

import (
	"reflect"
	"testing"
)

func TestAdd(t *testing.T){

  	type testCase struct{
  		input []int
  		want int
  	}

  	//test cases
  	testGroup := map[string]testCase{
  		"case 1": {input: []int{1,2}, want: 3},
  		"case 2": {input: []int{3,4}, want: 8},
  	}

  	for name,tc := range testGroup {
  		t.Run(name, func(t *testing.T){
  			got := add(tc.input[0], tc.input[1])
  			if !reflect.DeepEqual(got, tc.want){
  				t.Errorf("want: %v but got: %v\n", tc.want, got)
  			}

  		})
  	}
}

func BenchmarkAdd(b *testing.B) {
	for i:=0;i<b.N;i++ {
		add(1,2)
	}
}
```
* execute benchmark test
```go
//this command will execute unit test first and if succeed then will do benchmark test
//the result will show the times of execution、memory used、time per operation and etc
go test -bench=Add --benchmem
```

***

### pprof

#### 1.demo
```go
package main

import (
	"fmt"
	"os"
	"runtime/pprof"
	"time"
)

func logicCode() {
	for {}
}


func main() {
	fobj,err := os.Create("./cpu.pprof")
	defer fobj.Close()
	if err != nil{
		fmt.Println("fail to open the file", err)
		return
	}
	pprof.StartCPUProfile(fobj)
	defer pprof.StopCPUProfile()
	for i:=0;i<=12;i++ {
		go logicCode()
	}
	time.Sleep(time.Second * 5)
}
```

* excute the code above and output cpu.pprof

#### 2.parse cpu pprof
```shell
$ go tool pprof cpu.pprof

(pprof) top #view top cpu useage
(pprof) list <specify_function>	#list the details of the function 
```
[result format](https://stackoverflow.com/questions/32571396/pprof-and-golang-how-to-interpret-a-results)

* also can output pdf
```shell
go tool pprof --pdf ./test.exe ./cpu.pprof > file.pdf
```
