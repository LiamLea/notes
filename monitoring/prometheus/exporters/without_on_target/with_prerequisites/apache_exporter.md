
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [前提准备](#前提准备)
- [容器启动](#容器启动)

<!-- /code_chunk_output -->

[参考](https://github.com/Lusitaniae/apache_exporter)

### 前提准备
```shell
$ vim httpd.conf

ExtendedStatus on
<Location /server-status>
  SetHandler server-status
  allow from all
</Location>
```

### 容器启动
```shell
docker run -d -p 9117:9117 apache_exporter \
  --scrape_uri="https://your.server.com/server-status?auto"
```
