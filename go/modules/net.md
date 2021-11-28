# net

[toc]

### Application

#### 1.socket

##### （1）socket server
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

##### （2）socket client
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

#### 2.http

##### （1）http server
```go
func handle_func(reponse http.ResponseWriter, request *http.Request) {
	reponse.Write([]byte("welcome"))
	fmt.Println(request.Method)
	fmt.Println(request.URL)
	headers,err := json.MarshalIndent(request.Header, "", "  ")
	if err != nil {
		fmt.Println("fail to convert json", err)
		return
	}
	fmt.Println(string(headers))
	fmt.Println(request.Body)

	//the handler doesn't need to close the body,the httpserer will do it
	body,err := ioutil.ReadAll(request.Body)
	if err != nil {
		fmt.Println("fail to get body", err)
		return
	}

	fmt.Println(string(body))
}


func main() {
	http.HandleFunc("/test", handle_func)
	http.ListenAndServe("127.0.0.1:8080", nil)
}
```

##### （2）http client
* must close response body despite not read the body,or
 	* resource leak（file descriptor）
	* cannot reuse tcp connection
```go
client := &http.Client{}

request, err := http.NewRequest("GET", "http://127.0.0.1:8082", nil)
if err != nil {
	fmt.Println("fail to request", err)
	return
}
request.Header.Add("test-h1", "11111")

response,err := client.Do(request)
//close response body
if response != nil {
	defer response.Body.Close()
}
if err != nil {
	fmt.Println("fail to get reponse", err)
	return
}

body, err := ioutil.ReadAll(response.Body)
if err != nil {
	fmt.Println("fail to get body", err)
	return
}
fmt.Println(string(body))
```
