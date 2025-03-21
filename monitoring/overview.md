# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [基础概念](#基础概念)
      - [1.监控系统的构建步骤](#1监控系统的构建步骤)
      - [2.监控的理想化](#2监控的理想化)
      - [3.监控指标：](#3监控指标)

<!-- /code_chunk_output -->

### 基础概念

#### 1.监控系统的构建步骤
（1）监控系统设计
* 评估系统系统的业务流程、业务种类和系统架构
* 对监控分类（业务级别、系统级别、网络级别、程序）
* 监控技术方案和软件的选取
* 监控体系人员安排

（2）监控系统搭建

（3）数据采集

（4）监控数据分析
* 设置监控公式和告警阈值

（5）监控稳定性测试

（6）监控自动化

（7）监控图形化

#### 2.监控的理想化
（1）完全的自愈能力
>当产生告警后，能够自动恢复

（2）真实链路式监控
>当产生告警后，能够自动分析出真正的产生告警的原因

#### 3.监控指标：
（1）RED
* rate			
每秒的请求数和被处理的请求数
* errors		
失败的请求数
* duration		
处理每个请求花费的时间

（2）USE
* utilization
cpu、内存、网络、存储使用率
* saturation
衡量当前服务的饱和度（看哪个指标用的多，快满了）
* errors
