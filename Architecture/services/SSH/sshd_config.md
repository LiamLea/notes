# sshd_config

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [sshd_config](#sshd_config)
    - [配置项](#配置项)
      - [1.`MaxSessions`](#1maxsessions)

<!-- /code_chunk_output -->

### 配置项

#### 1.`MaxSessions`
指定 每个网络连接 允许的 最大会话数
即多少个ssh session能够复用同一个TCP连接，默认为10
