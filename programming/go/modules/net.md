# net

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [net](#net)
    - [Application](#application)
      - [1.socket](#1socket)
        - [（1）socket server](#1socket-server)
        - [（2）socket client](#2socket-client)
      - [2.http](#2http)
        - [（1）http server](#1http-server)
        - [（2）http client](#2http-client)
      - [3.http2(h2c)](#3http2h2c)
        - [（1）server](#1server)
        - [（2）client](#2client)

<!-- /code_chunk_output -->

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

#### 3.http2(h2c)

##### （1）server
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
        h2s := &http2.Server{}

        handler := http.HandlerFunc(handle_func)

        server := &http.Server{
                Addr:    "0.0.0.0:8080",
                Handler: h2c.NewHandler(handler, h2s),
        }

        server.ListenAndServe()
}
```

##### （2）client
```go
func send_request(client *http.Client){

        request, err := http.NewRequest("GET", "http://0.0.0.0:8080/test", nil)
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
}

func main() {
        client := &http.Client{
                Transport: &http2.Transport{
                        // So http2.Transport doesn't complain the URL scheme isn't 'https'
                        AllowHTTP: true,
                        DialTLS: func(network, addr string, cfg *tls.Config) (net.Conn, error) {
                                return net.Dial(network, addr)
                        },
                },
        }
        send_request(client)
        send_request(client)
}
```
