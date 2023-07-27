# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.block chain](#1block-chain)
        - [(1) 定义](#1-定义)
        - [(2) 分类](#2-分类)
      - [2.数字签名](#2数字签名)
      - [3.block](#3block)
        - [(1) block header](#1-block-header)
        - [(2) block size](#2-block-size)
        - [(3) block frequency](#3-block-frequency)
        - [(4) block例子](#4-block例子)
      - [4.block chain结构](#4block-chain结构)
        - [(1) 如何保证不被篡改](#1-如何保证不被篡改)
      - [5.consensus mechanism](#5consensus-mechanism)
        - [(1) Longest Chain](#1-longest-chain)
        - [(2) POW (proof of work)](#2-pow-proof-of-work)
      - [6.proof of work](#6proof-of-work)
        - [(1) difficulty](#1-difficulty)
        - [(2) difficulty target (leading zero)](#2-difficulty-target-leading-zero)
        - [(3) hash rate](#3-hash-rate)
        - [相关概念](#相关概念)
      - [1.decentralized network](#1decentralized-network)
      - [1.lightning network](#1lightning-network)
      - [2.NFT (Non-Fungible Token)](#2nft-non-fungible-token)
      - [3.cryptocurrency](#3cryptocurrency)

<!-- /code_chunk_output -->

### 概述

#### 1.block chain

##### (1) 定义
使用 **密码** 技术将 **共识** 确认的区块按顺序追加形成的 **分布式账本**

##### (2) 分类

* 公链
* 联盟链
* 私链

#### 2.数字签名

* 利用私钥加密，公钥解密
* 钱包的地址就是公钥

#### 3.block

* 以下均以bitcoin为例

##### (1) block header

|内容|说明|详细说明|
|-|-|-|
|Version|版本|这个block使用的协议的版本（对于bitcoin就是bitcoin protocol的版本）|
|Previous block header hash|前一个block的header的哈希值|
|Timestamp|时间戳|这个block创建的时间|
|Difficulty|难度|用于调整difficulty target的值，使得能够稳定十分钟找到一个block|
|Nonce|number used once，找出的答案|找出答案后才能创建块|
|MerkleRoot|当前block 交易信息 的哈希值|

##### (2) block size
不能超过1MB

##### (3) block frequency
* block产生速度
    * one block per 10 minute
    * 144 blocks per day
    * 2016 blocks per two weeks

* 实现方式
    * 通过difficulty控制，计算速度
    * 每2016 blocks（即每2周）调整一次difficulty

##### (4) block例子
![](./imgs/overview_01.png)

* block hash
    * 该block header的哈希值，用于唯一表示该block

* summary
    * Height
        * 链的高度，第一个block为0，以后依次加一
    * Confirmations
        * 当block后面加一个block，confirmations加一
        * 最后一个block的confirmations为1
    * Block Size
        * 块的总大小
    * Stripped Size
        * 去除witness data后块的大小（为了满足块不能超过1M限制的要求）
    * weight
        ```wasm
        block weight = (transaction data size * 3) + witness data size
        ```
    * Difficulty
        * 用于调整difficulty target的值
    * Block Reward
        * 创建该block获得的奖励
    * Tx Count
        * 交易数
    * Tx Volume
        * 交易体量，即所有交易的金额

* Transactions
    * 该block中记录的交易
    * 第一笔交易是coinbase交易，即给创建该block的人的奖励

#### 4.block chain结构

![](./imgs/overview_02.png)

##### (1) 如何保证不被篡改
比如修改第一个块后，就会使得block header hash变了，后面的块维护了previous block header hash，所以想要篡改前面的难度很大

#### 5.consensus mechanism

##### (1) Longest Chain 
* 目的: 用于决定该block添加在哪条chain上

##### (2) POW (proof of work)
* 目的: 用于决定谁来写这个block
* 原理: 需要找到一个nonce，该nonce的hash需要满足系统规定的要求

#### 6.proof of work

##### (1) difficulty
* 为了调整difficulty target的值，使得能够稳定十分钟找到一个block
    * 每2016 blocks（即每2周）调整一次difficulty
    * 计算公式（具体要看算法，这里这是给出一个例子）
        * `New difficulty = old difficulty x (2016 blocks / time taken to mine last 2016 blocks)`

##### (2) difficulty target (leading zero)
* 是一个256-bit的数字，当`block的hash < difficulty target`时，则表示找到符合要求的块
* 这就意味着block的hash前面一定位数都是0,所以有等价于有多个leading zero

* 计算方式
    * `difficulty target = 2^256/(difficulty * 2^32)`

* 当difficulty为1（即难度最小）时，此时difficulty target最大：
    * 理论应为：
        * `0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF`
    * 但是由于bitcoin存储的是loating-point type（即64-bit，将后面的数值截断了），所以实际为：
        * `0x00000000FFFF0000000000000000000000000000000000000000000000000000`

##### (3) hash rate
* 挖取一块block理论所需要的hash rate
* `Hash Rate = (2^256 / defult target) / 600 = difficulty * 2^32 / 600` (单位: `H/s`)
    * 总共的hash值: 2^256
    * 符合要求的hash值: default target
    * 平均需要计算的hash次数: `2^256 / defult target`
    * 一个块的产生的时间: 10min * 60 = 600s

##### 相关概念
POW: proof of work
POS: proof of stake
POC: proof of capacity
DeFi: decentralized finance
NFT: Non-fungible tokens

#### 1.decentralized network
#### 1.lightning network

#### 2.NFT (Non-Fungible Token)

#### 3.cryptocurrency

* GPU
* ASIC  (application-specific integrated circuit)
* Mining Pool
* 方式
    * mining software 
    * cloud mining
    * centralized hardware management
