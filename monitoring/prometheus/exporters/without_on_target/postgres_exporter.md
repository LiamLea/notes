[toc]

[参考](https://github.com/prometheus-community/postgres_exporter)

### 容器启动
```shell
docker run \
  -e DATA_SOURCE_NAME="postgresql://<username>:<password>@<ip>:<port>/postgres?sslmode=disable" \
  quay.io/prometheuscommunity/postgres-exporter
```
