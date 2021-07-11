[toc]

[nginx-prometheus-exporter](https://github.com/nginxinc/nginx-prometheus-exporter)
[nginx-vts-exporter](https://github.com/hnlq715/nginx-vts-exporter)

### 前提准备

#### 1.使用nginx-prometheus-exporter
需要安装stub_status模块

#### 2.使用nginx-vts-exporter
需要安装nginx-vtx-module模块

### 容器启动

#### 1.使用nginx-prometheus-exporter
```shell
docker run -p 9113:9113 nginx/nginx-prometheus-exporter:0.9.0 -nginx.scrape-uri=http://<nginx>:8080/stub_status
```
