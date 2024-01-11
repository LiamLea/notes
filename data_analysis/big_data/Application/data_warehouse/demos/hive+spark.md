# hive+spark数仓


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [hive+spark数仓](#hivespark数仓)
    - [一站制造项目](#一站制造项目)
      - [1.建模分析](#1建模分析)
        - [(1) 需求分析](#1-需求分析)
        - [(2) 划分主题域](#2-划分主题域)
        - [(3) 构建维度总线矩阵](#3-构建维度总线矩阵)
        - [(4) 明确指标统计](#4-明确指标统计)
        - [(5) 定义事实与维度规范](#5-定义事实与维度规范)
        - [(6) 代码开发](#6-代码开发)
      - [2.建模操作](#2建模操作)
        - [(1) 数据导入](#1-数据导入)
        - [(2) ODS](#2-ods)
        - [(3) DWD](#3-dwd)
        - [(4) DIM (从DWD中抽取维度)](#4-dim-从dwd中抽取维度)
        - [(5) DWM (从DWD中抽取事实)](#5-dwm-从dwd中抽取事实)
        - [(6) DWS](#6-dws)

<!-- /code_chunk_output -->


### 一站制造项目

* 连接Hive，执行SQL建表语句
    * 使用Hive建表，能够保留元数据等，便于多次使用
* 连接Spark SQL，执行SQL计算语句

#### 1.建模分析

##### (1) 需求分析
业务调研和数据调研
* 了解整个业务实现的过程
* 收集所有数据使用人员对于数据的需求
* 整理所有数据来源

##### (2) 划分主题域
* 用户域、店铺域
* 商品域、交易域、
* 客服域、信用风控域、采购分销域

##### (3) 构建维度总线矩阵
明确每个业务主题对应的维度关系
![](./imgs/demo_05.png)
[本项目的维度矩阵](./hive%2Bspark.xlsx)

##### (4) 明确指标统计
明确所有原生指标与衍生指标
* 原生指标：基于某一业务事件行为下的度量，是业务定义中不可再拆分的指标，如支付总金额

* 衍生指标：基于原子指标添加了维度：近7天的支付总金额等

##### (5) 定义事实与维度规范
* 命名规范、类型规范、设计规范等

##### (6) 代码开发

#### 2.建模操作

##### (1) 数据导入

* Oracle -> hdfs 
    * 使用Avro格式
    * 并上传Avro生成的schema

##### (2) ODS

* 建表（当表很多时，可以实现自动化建表）
    * 使用avro时，会生成schema，无需手动指定表结构
    ```sql
    create external table one_make_ods_test.ciss_base_areas
    comment '行政地理区域表'
    PARTITIONED BY (dt string)
    stored as avro
    location '/data/dw/ods/one_make/full_imp/ciss4.ciss_base_areas'
    TBLPROPERTIES ('avro.schema.url'='/data/dw/ods/one_make/avsc/CISS4_CISS_BASE_AREAS.avsc');
    ```

    * 使用其他格式时，没有shema
        * 可以用代码实现，从oracle中获取原始表的字段信息，然后实现自动化建表

##### (3) DWD

本次数据来源于Oracle数据库，没有具体的ETL的需求，可以直接将ODS层的数据写入DWD层
* 用代码实现，从oracle中获取原始表的字段信息，然后实现自动化建表
* 然后将ODS层中的表数据全部抽取到DWD层

##### (4) DIM (从DWD中抽取维度)

* 地区维度表
* 服务网点维度表
* 加油站维度表
* 组织机构维度表
* 仓库维度表
* 物流维度表

##### (5) DWM (从DWD中抽取事实)
* 进行轻度聚合

##### (6) DWS
* 进行统计聚合