
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [serice over public network](#serice-over-public-network)
  - [1.ssh](#1ssh)
    - [（1）需求](#1需求)
    - [（2）防护](#2防护)

<!-- /code_chunk_output -->

### serice over public network

#### 1.ssh

##### （1）需求
gitlab需要暴露ssh端口

##### （2）防护
* 更改ssh端口
* 禁止使用密码登录，只能使用密钥进行登录
