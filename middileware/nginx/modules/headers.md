# ngx_http_headers_module

[toc]

### 配置

#### 1.`add_header`
* 上下文：http, server, location, if in location

用于添加发往客户端的**响应头**
```python
add_header <HEADER> <VALUE>;
```
