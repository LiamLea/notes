# ssl

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ssl](#ssl)
    - [配置](#配置)
      - [1.设置加密方式（不采用DHE等方式）](#1设置加密方式不采用dhe等方式)

<!-- /code_chunk_output -->

### 配置

#### 1.设置加密方式（不采用DHE等方式）
```shell
http {
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;  # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;   #优先使用nginx服务端设置的加密方式
    ssl_ciphers AES256-SHA256:AES256-SHA:AES128-SHA256:AES128-SHA:RC4-SHA:RC4-MD5:DES-CBC3-SHA;


    server {
        listen       443 ssl;
        listen       [::]:443 ssl;
        server_name  _;
        root         /usr/share/nginx/html;
        ssl_certificate "/etc/pki/nginx/server.crt";
        ssl_certificate_key "/etc/pki/nginx/server.key";
    }
}
```
