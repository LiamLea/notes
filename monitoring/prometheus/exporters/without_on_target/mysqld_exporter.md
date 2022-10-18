
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [容器启动](#容器启动)

<!-- /code_chunk_output -->

[参考](https://github.com/prometheus/mysqld_exporter)

### 容器启动
```shell
docker run -d \
  -p 9104:9104 \
  -e DATA_SOURCE_NAME="user:password@(hostname:3306)/" \
  prom/mysqld-exporter
```
