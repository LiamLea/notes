# http


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [http](#http)
    - [Overview](#overview)
      - [1.basic](#1basic)
        - [（1）http server](#1http-server)
        - [（2）http client](#2http-client)
      - [2.request multiplexer (router)](#2request-multiplexer-router)

<!-- /code_chunk_output -->


### Overview

#### 1.basic

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

#### 2.request multiplexer (router)

```go
mux := http.NewServeMux()


// mux.Handle("/hello", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
//     fmt.Fprintln(w, "hi")
// }))

// is equivalent to

mux.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "hi")
})

http.ListenAndServe(":8080", mux)
```