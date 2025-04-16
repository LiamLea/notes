# Socket


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Socket](#socket)
    - [Overview](#overview)
      - [1.basic](#1basic)
      - [(1) socket server](#1-socket-server)
        - [(2) socket client](#2-socket-client)

<!-- /code_chunk_output -->



### Overview

#### 1.basic

#### (1) socket server
```go
package main

import (
	"fmt"
	"net"
)

func main() {
	listener, err := net.Listen("tcp", "127.0.0.1:8080")
	if err != nil {
		fmt.Println("fail to create listener", err)
		return
	}
	conn, err := listener.Accept()
	if err != nil {
		fmt.Println("fail to accept connection", err)
		return
	}

	tmp := make([]byte, 128)
	n, err := conn.Read(tmp)
	if err != nil {
		fmt.Println("fail to read data from connection", err)
		return
	}

	fmt.Println(string(tmp[:n]))
}
```

##### (2) socket client
```go
package main

import "net"

func main() {
	conn, err := net.Dial("tcp", "127.0.0.1:8080")
	if err != nil {
		println("fail to connect", err)
		return
	}

	conn.Write([]byte("nihao ya!!!!"))
	conn.Close()
}
```
