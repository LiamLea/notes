# license

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [license](#license)
    - [概述](#概述)
      - [1.GPL（genneral public license）](#1gplgenneral-public-license)
      - [2.MIT](#2mit)
      - [3.BSD](#3bsd)
      - [4.Apache 2.0](#4apache-20)
    - [使用](#使用)
      - [1.Apache 2.0](#1apache-20)
        - [（1）`LICENSE` file](#1license-file)
        - [（2）当修改了别人的源码，需要添加:`NOTICE` file](#2当修改了别人的源码需要添加notice-file)

<!-- /code_chunk_output -->

### 概述

#### 1.GPL（genneral public license）
copyleft（与copyright相关），具有传染性，代码中使用了 相关库（GPL许可的），则该代码必须继承GPL许可（即要开源）

#### 2.MIT
允许你任意的使用、复制、修改原MIT代码库，随便你卖钱还是开源，唯一需要遵循的原则就是在你的软件中声明你也使用的是MIT协议就行了

#### 3.BSD
跟GPL基本一样，但不允许使用原先的作者进行宣传

#### 4.Apache 2.0
比MIT严格，比GPL宽松
原先的内容必须遵循Apache协议，必须明确说明修改了的内容和保留作者信息


***

### 使用

#### 1.Apache 2.0

##### （1）`LICENSE` file
在源码的top目录上，创建License file，[文件内容下载](http://www.apache.org/licenses/LICENSE-2.0)

##### （2）当修改了别人的源码，需要添加:`NOTICE` file

* 标识源作者和修改内容等信息

```
Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
