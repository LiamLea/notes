# url探测详设文档

**文档版本**: V1.0

**文档日期**: 2020年08月07日

**编写人**：李亮

本技术文件是北京中电广通技术服务有限公司商业机密文件，书中的所有信息均为机密信息，务请妥善保管并且仅在与项目有关人员范围内使用。未经南京沧和信息科技有限公司明确作出的书面许可，不得为任何目的、以任何形式或手段（包括电子、机械、复印、录音或其他形式）对本文档的任何部分进行复制、存储、引入检索系统或者传播

## 版本记录

| 修订历史 			(REVISI/ON HISTORY) |          |            |        |                                                              |
| ---------------------------------------- | -------- | ---------- | ------ | ------------------------------------------------------------ |
| 版本                                     | 修正章节 | 日期       | 作者   | 变更纪录                                                     |
| V1.0                                     | 全体     | 2020-08-07  | 李亮 | 新增           

## 目    录

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [url探测详设文档](#url探测详设文档)
  - [版本记录](#版本记录)
  - [目    录](#目-录)
  - [1. 背景](#1-背景)
  - [2.	业务功能](#2业务功能)
    - [2.1 功能点简介](#21-功能点简介)
    - [2.2 相关负责人](#22-相关负责人)
  - [3.	功能设计](#3功能设计)
    - [3.1 逻辑拓扑的组件](#31-逻辑拓扑的组件)
    - [3.2 解析组件的配置信息](#32-解析组件的配置信息)
      - [3.2.1 集群配置](#321-集群配置)
      - [3.2.2 负载配置](#322-负载配置)
    - [3.3 匹配规则](#33-匹配规则)
    - [3.4 流程图](#34-流程图)
    - [3.5参数](#35参数)

<!-- /code_chunk_output -->

## 1. 背景

智能运维平台提供url探测能力。


## 2.	业务功能

### 2.1 功能点简介

| **序号** | **功能点**         | **描述**                             |
| -------- | ------------------ | ------------------------------------ |
|     1.   | url探测           | 根据url，生成逻辑拓扑 |



### 2.2 相关负责人

| **序号** | **角色**   | **姓名** | **备注**                       |
| -------- | ---------- | -------- | ------------------------------ |
| 1        | 研发      | 李亮 | 负责代码落地                 |
| 2        | 测试      | 宋强国 | 负责测试用例编写和质量把控    |
| 3        | 架构师    | 刘纯 | 数据库脚本定义和核心逻辑定义  |
| 4        | 产品经理  | 王然 | 需求定义                     |



## 3.	功能设计

### 3.1 逻辑拓扑的组件
* 原子系统
`cmdb_atom_system`表
* Load_Balance
`monitor_host`表
* 其他

### 3.2 解析组件的配置信息
#### 3.2.1 集群配置
#### 3.2.2 负载配置
* 软件负载（nginx）
```json
"cluster": {
  "name": "mysql",
  "url": "/",
  "instance": [
    {
      "role": "member",
      "type": "",
      "listen": [
        "3.1.5.140:8080"
      ],
      "status": ""
    },
    {
      "role": "member",
      "type": "",
      "listen": [
        "3.1.5.141:8080"
      ],
      "status": ""
    },
    {
      "role": "member",
      "type": "",
      "listen": [
        "3.1.5.142:8080"
      ],
      "status": ""
    },
    {
      "role": "proxy",
      "type": "nginx",
      "listen": [
        "127.0.0.1:80",
        "3.1.5.140:80"
      ],
      "status": "UP"
    }
  ],
  "uuid": "7fcc83e22d8878da69ef232dc85c3861"
}
```
* 硬件负载（F5）
```json
"VirtualServer": [
  {
    "VirtualServName": "/Common/test2",
    "VirtualServAddr": "172.28.202.173",
    "VirtualServWildmask": "255.255.255.255",
    "VirtualServPort": "80",
    "VirtualServIpProto": "6",
    "VirtualServType": "poolbased",
    "VirtualServConnLimit": "0",
    "VirtualServDefaultPool": "",
    "VirtualServRule": []
  },
  {
    "VirtualServName": "/Common/testvirtual",
    "VirtualServAddr": "192.168.33.59",
    "VirtualServWildmask": "255.255.255.255",
    "VirtualServPort": "8000",
    "VirtualServIpProto": "6",
    "VirtualServType": "poolbased",
    "VirtualServConnLimit": "0",
    "VirtualServDefaultPool": "/Common/pool1",
    "VirtualServRule": []
  }
],

"Pool": [
  {
    "PoolName": "/Common/pool1",
    "PoolActiveMemberCnt": "2",
    "PoolMonitorRule": "/Common/http",
    "PoolMemberCnt": "4",
    "PoolLbMode": "roundRobin",
    "PoolMember": [
      {
      	"PoolMemberPoolName": "/Common/pool1",
      	"PoolMemberAddr": "192.168.33.57",
      	"PoolMemberPort": "8000",
      	"PoolMemberMonitorRule": "",
      	"PoolMemberMonitorState": "down"
      },
      {
      	"PoolMemberPoolName": "/Common/pool1",
      	"PoolMemberAddr": "192.168.33.58",
      	"PoolMemberPort": "8000",
      	"PoolMemberMonitorRule": "",
      	"PoolMemberMonitorState": "down"
      },
      {
      	"PoolMemberPoolName": "/Common/pool1",
      	"PoolMemberAddr": "192.168.33.55",
      	"PoolMemberPort": "7003",
      	"PoolMemberMonitorRule": "",
      	"PoolMemberMonitorState": "up"
      },
      {
      	"PoolMemberPoolName": "/Common/pool1",
      	"PoolMemberAddr": "192.168.33.55",
      	"PoolMemberPort": "7004",
      	"PoolMemberMonitorRule": "",
      	"PoolMemberMonitorState": "up"
      }
    ]
  }
],
```

### 3.3 匹配规则
* 首先获取url中的ip和port，如果是域名，需对域名进行解析
* 遍历`cmdb_atom_system`表中的ip字段，判断url中的ip:port是否在在该字段中
  * 如果存在，则获取相应的uuid，根据uuid获取该原子系统的配置信息
* 如果不存在，则遍历 `monitor_host`表中Load_Balance的记录，获取Load_Balance的配置，根据配置判断url的ip:port是否匹配该Load_balance
* 如果成功匹配，则解析对应的配置，递归匹配
  * 解析配置需要根据对应的软件类型或设备类型，做一些特定的处理

### 3.4 流程图

```plantuml
start
:获取url中ip:port;
repeat

while (遍历cmdb_atom_system的ip字段) is (match)
:获取组件uuid;
:解析组件配置获取ip:port;
endwhile (no match)

backward: 获取组件uuid，解析组件配置获取ip:port;
repeat while (遍历monitor_host表中Load_Balance的记录) is (match)
->no match;

end
```

### 3.5参数
* 入参
```shell
url
```

* 出参
```json
[
  {
    "uuid": "xx",
    "type": "Load_Balanace",
    "level": "1"
  },
]
```
