# wireshark

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [wireshark](#wireshark)
    - [使用](#使用)
      - [1.利用key解析https](#1利用key解析https)
        - [（1） 导入key](#1-导入key)
        - [（2）查看http流量](#2查看http流量)
      - [2.reassemble](#2reassemble)
        - [(1)当tcp被分成多个segment时](#1当tcp被分成多个segment时)
        - [(1)当ip packegt被分成多个fragment时](#1当ip-packegt被分成多个fragment时)

<!-- /code_chunk_output -->

### 使用

#### 1.利用key解析https

##### （1） 导入key
  * edit -> perferences -> protocol -> TLS

![](./imgs/wireshark_01.png)

##### （2）查看http流量
![](./imgs/wireshark_02.png)

#### 2.reassemble

##### (1)当tcp被分成多个segment时
会抓取到多个reassemble包，说明相应的segment是在哪里进行reassemble的

##### (1)当ip packegt被分成多个fragment时
会抓取到多个reassemble包，说明相应的fragment是在哪里进行reassemble的