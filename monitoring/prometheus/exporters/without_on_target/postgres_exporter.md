
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [容器启动](#容器启动)

<!-- /code_chunk_output -->

[参考](https://github.com/prometheus-community/postgres_exporter)

### 容器启动
```shell
docker run \
  -e DATA_SOURCE_NAME="postgresql://<username>:<password>@<ip>:<port>/postgres?sslmode=disable" \
  quay.io/prometheuscommunity/postgres-exporter
```
