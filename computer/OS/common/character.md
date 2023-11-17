# character


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [character](#character)
    - [概述](#概述)
      - [1.character set 和 character encoding](#1character-set-和-character-encoding)
      - [2.常用字符集和字符编码](#2常用字符集和字符编码)
        - [(1) ASCII字符集和字符编码](#1-ascii字符集和字符编码)
        - [(2) GBK字符集和字符编码](#2-gbk字符集和字符编码)
        - [(3) Unicode字符集和UTF-8字符编码](#3-unicode字符集和utf-8字符编码)
      - [3.打印出所有隐藏字符](#3打印出所有隐藏字符)
      - [4.字符 -> 十进制数](#4字符---十进制数)
      - [5.十进制数 -> 字符](#5十进制数---字符)

<!-- /code_chunk_output -->

### 概述

#### 1.character set 和 character encoding
* character set
    * 定义一系列字符 及 其表示方式
        * 比如: 在ASCII中，数值97表示a
    * 常用字符集：ASCII、GBK、Unicode
* character encoding
    * 将 字符集 中的 字符 编码成 二进制
    * 常用字符编码：ASCII、GBK、UTF-8

#### 2.常用字符集和字符编码

##### (1) ASCII字符集和字符编码

* 1个字符用 **1个字节**
* 容量：256个字符
* 用途：用于表示英文字母和一些特殊符号（大概一百多个）

##### (2) GBK字符集和字符编码

* 兼容Ascii，中文字符用 **2个字节** 
* 容量: 2^16
* 用于：用于兼容Ascii和中文字符

##### (3) Unicode字符集和UTF-8字符编码

* 用于：用于将世界上的所有字符进行编码
    * 兼容ASCII
* **可变长**编码
    * 英文字符、数字等 用1个字节 (兼容ASCII)
        * `0xxxxxxx`
    * 2个字节
        * `110xxxxx 10xxxxxx`
    * 汉字字符 用3个字节
        * `1110xxxx 10xxxxxx 10xxxxx`
    * 4个字节
        * `11110xxx 10xxxxxx 10xxxxxx 10xxxxxx`

#### 3.打印出所有隐藏字符
```shell
sed  -n 'l' <file_path>
```

#### 4.字符 -> 十进制数

* character -> decimal

```shell
printf "%d" "'$character"
```

* text -> decimal
```shell
hexdump -v -e '/1 "%u "' <file_path>
```

#### 5.十进制数 -> 字符
```shell
python3 -c "print(chr(97))"
python3 -c "print(chr(20013))"
```