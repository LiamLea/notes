# http2(h2c)


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [http2(h2c)](#http2h2c)
    - [Overview](#overview)
      - [1.basic](#1basic)
        - [（1）server](#1server)
        - [（2）client](#2client)

<!-- /code_chunk_output -->


### Overview

#### 1.basic

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
