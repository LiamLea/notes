# error


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [error](#error)
    - [Overview](#overview)
      - [1.error handling in golang](#1error-handling-in-golang)
      - [2.two types of error](#2two-types-of-error)
        - [(1) expected error](#1-expected-error)
        - [(2) panic (which will stop the program)](#2-panic-which-will-stop-the-program)

<!-- /code_chunk_output -->


### Overview

#### 1.error handling in golang

a shift towards **active** error management, as opposed to the former approach where the system passively awaited the occurrence of an error. 

* why not try-catch
It’s crucial to use try-catch only in **unexpected situations**, not as a regular method for controlling flow

#### 2.two types of error

##### (1) expected error
```go
const filePath = "exemple.txt"

func main() {
 content, err := os.ReadFile(filePath)
 if err != nil {
  fmt.Println("Error while try reading file")
 }
 fmt.Println(string(content))
}
```

##### (2) panic (which will stop the program)

```go
func getCharIndex(str string, idx int) (char rune, err error) {
 defer func() {
  if r := recover(); r != nil {
   err = fmt.Errorf("Index %d was not exist in  the string '%s'", idx, str)
  }
 }()

 char = rune(str[idx])
 return char, nil
}
```

* if we can expect the error, we can change it to
```go
func getCharIndex(str string, idx int) (char rune, err error) {
 if len(str) > idx {
  char = rune(str[idx])
 } else {
  err = fmt.Errorf("Index %d was not exist in  the string '%s'", idx, str)
 }
 return char, err
}
```