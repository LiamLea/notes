# ngx_http_headers_module

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ngx_http_headers_module](#ngx_http_headers_module)
    - [配置](#配置)
      - [1.`add_header`](#1add_header)

<!-- /code_chunk_output -->

### 配置

#### 1.`add_header`
* 上下文：http, server, location, if in location

用于添加发往客户端的**响应头**
```python
add_header <HEADER> <VALUE>;
```
