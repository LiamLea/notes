# overview
[toc]
#### 单机版oracle有两类进程
* 与监听器有关的进程（`tnslsnr`）
* 与实例有关的进程（`*_<INSTANCE_NAME>`）

### 重要目录
* admin目录
记录Oracle实例的配置, 运行日志等文件, 每个实例一个目录
SID: System IDentifier的缩写, 是Oracle实例的唯一标记. 在Oracle中 **一个实例只能操作一个数据库** . 如果安装多个数据库, 那么就会有多个实例, 我们可以通过实例SID来区分. 由于Oracle中一个实例只能操作一个数据库的原因oracle中也会使用SID来作为库的名称

* oradata目录
存放数据文件

* init.ora文件
