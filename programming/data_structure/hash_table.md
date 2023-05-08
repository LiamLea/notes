# hash table (hash map)


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [hash table (hash map)](#hash-table-hash-map)
    - [概述](#概述)
      - [1.hash](#1hash)
        - [(1) hash table (hash map)](#1-hash-table-hash-map)
        - [(2) hash function](#2-hash-function)
      - [2.基础的hash function](#2基础的hash-function)
        - [(1) 除余法 (divice)](#1-除余法-divice)
        - [(2) 对除余法的改进: MAD (multiply - add - divide)](#2-对除余法的改进-mad-multiply---add---divide)
      - [3.排解散列冲突: Separate Chaining (Closed Addressing)](#3排解散列冲突-separate-chaining-closed-addressing)
        - [(1) 说明](#1-说明)
        - [(2) 缺点](#2-缺点)
      - [4.排解散列冲突: Open Addressing](#4排解散列冲突-open-addressing)
        - [(1) 说明](#1-说明-1)
        - [(2) probing chain](#2-probing-chain)
        - [(3) lazy removal](#3-lazy-removal)
        - [(4) 优点和缺点](#4-优点和缺点)
      - [5.应用](#5应用)
        - [(1) bucket sort](#1-bucket-sort)
        - [(2) counting sort (计算排序)](#2-counting-sort-计算排序)

<!-- /code_chunk_output -->


### 概述

#### 1.hash

无法杜绝冲突，所以需要设置合理的散列表和散列函数，尽可能降低冲突概率

##### (1) hash table (hash map)
hash table中的元素 就是 bucket的地址，一个bucket能够存储一定数量的key

##### (2) hash function
* 要求
    * determinism (确定性)
        * 同一key总是被映射到同一bucket中
    * efficiency (高效性)
    * surjection (满射性)
        * 所有的key都能在映射到hash table
    * uniformity (均匀性)
        * key映射到hash table中各位置的概率尽量均衡，避免聚集现象

* 返回值:  称为hash code、digests等

#### 2.基础的hash function

##### (1) 除余法 (divice)
* `hash(key) = key % M`
* M为素数
    * 能使分布尽可能均匀
        * 因为数据的局部性，比如for语句都有一个步长，当M为素数时，不论步长为多少，只要数足够多，都能均匀分布，因为步长和M的最大公约数为1
* 缺陷:
    * 不动点
        * 无论M取值如何, hash(0)永远等于0
    * 零阶均匀
        * 相邻key的散列地址也必相邻

##### (2) 对除余法的改进: MAD (multiply - add - divide)
* `hash(key) = (a * key + b) % M`
* a > 0, b > 0, a % M != 0
* 一阶均匀
    * 相邻key的散列地址不再相邻

#### 3.排解散列冲突: Separate Chaining (Closed Addressing)

##### (1) 说明
* 本质: hash table + list
    * 一个bucket存储一个list，list用于链接冲突的key

##### (2) 缺点
空间未必连续分布，系统缓存几乎失效

#### 4.排解散列冲突: Open Addressing

##### (1) 说明
key存入的bucket不总是确定
* 根据hash(key)计算出hash code
* 根据hash code在hash table中寻找bucket
* 判断当前bucket是否存入了当前的key
    * 如果有，则直接返回成功
    * 如果没有，则判断当前bucket是否full
        * 如果没有full，则存入到当前bucket中
        * 如果full (即发生**冲突**)，则根据**probing chain** (**查找链**) 寻找下一个bucket

##### (2) probing chain

* linear probing (线性探测)
    * 每次查找后一个相邻的桶
    * 缺点
        * 数据聚集现象严重 (通过平方查找可以优化)

* quadratic probing (平方探测)
    * 以平方数为距离，确定下一次探测的位置
    * M取值: 素数 且  当双向平方时M=4k+3
    * 缺点
        * 极端情况下，会破坏数据的局部性，导致I/O增加
        * 装填因子最最糟糕情况下只有50% (可通过双向平方试探提高装填因子)

![](./imgs/hash_01.png)
![](./imgs/hash_02.png)


##### (3) lazy removal
* 当删除一个bucket中的key，不是立即删除这个key，而是做一个标记
    * 这样查找链到这个并不会终止
    * 当插入时，查找链会用新的key替换删除掉的key

##### (4) 优点和缺点
* 优点
    * 查找链具有局部性，可充分利用系统缓存

* 缺点
    * 冲突增多
    * hash table可能变满，这时就需要扩展hash table，不然新的key无法存入hash table中

#### 5.应用

##### (1) bucket sort
* 说明
    * 对每个桶进行排序

* 时间复杂度: O(n+M)
    * n为key的数量
    * M为桶的数量

* demo
    * 将key放入桶中
    ![](./imgs/hash_03.png)

    * 进行桶排序
    ![](./imgs/hash_04.png)

##### (2) counting sort (计算排序)

* 说明
    * 遍历输入集，进行计数
        * 每个不同的key就是一个桶，桶的值就是key的数量
    ![](./imgs/hash_05.png)
    * 按照key的顺序进行输出
    ![](./imgs/hash_06.png)