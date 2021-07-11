[toc]

[参考](https://github.com/prometheus/mysqld_exporter)

### 容器启动
```shell
docker run -d \
  -p 9104:9104 \
  -e DATA_SOURCE_NAME="user:password@(hostname:3306)/" \
  prom/mysqld-exporter
```
