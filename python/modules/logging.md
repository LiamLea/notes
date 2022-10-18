# logging

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [logging](#logging)
    - [概述](#概述)
      - [1.作用](#1作用)
      - [2.日志等级](#2日志等级)
    - [使用](#使用)
      - [1.全局配置](#1全局配置)
      - [2.创建 日志器](#2创建-日志器)
      - [3.使用 日志器](#3使用-日志器)
      - [4.实现日志切割](#4实现日志切割)
      - [5.关闭某个 日志器](#5关闭某个-日志器)

<!-- /code_chunk_output -->

### 概述
#### 1.作用
* 记录用户行为 —— 数据分析
* 记录用户行为 —— 操作审计
* 排查代码中的错误

#### 2.日志等级
* debug
* info
* warning
* error
* critical

### 使用

#### 1.全局配置
不要在这里配置，在这里配置会自动生一个一个日志器，在具体的 日志器 里配置
```python
import logging

logging.basicConfig = (

  #设置日志打印的格式
  format = '%(asctime)s - %(name)s - %(levelname)s[line:%(lineno)d] - %(module)s: %(message)s',

  #设置时间的格式，即%(astime)s的格式
  datefmt = '%Y-%m-%d %H:%M:%S',

  #设置打印DEBUG以上等级的日志，默认打印warning即以上等级
  level = logging.DEBUG,

  #设置日志输出到指定地方，默认只输出到标准错误输出
  handlers = [fh, sh]
)
```

#### 2.创建 日志器
日志需要到指定句柄（即输出到指定目标）
* 创建句柄
```python
#创建一个文件句柄
fh = logging.FileHandler("文件名", encoding = "utf8")
#创建标准错误输出的句柄
sh = logging.StreamHandler()
```

* 配置句柄（包括日志格式）
```python
#设置日志格式
formatter = logging.Formatter("%(asctime)s - %(name)s  - %(levelname)s[line:%(lineno)d] - %(module)s %(funcName)s: %(message)s")

#设置时间格式
formatter.datefmt = "%Y-%m-%d %H:%M:%S"

#设置句柄
sh.setFormatter(formatter)
```


* 创建日志器
```python
#创建日志器，并给该日志器取一个名字
logger = logging.getLogger("<CUSTOME_NAME")

#配置日志器
logger.setLevel(logging.DEBUG)    #设置打印DEBUG以上等级的日志，默认打印warning即以上等级
logger.addHandler(<HANDLER>)
```

#### 3.使用 日志器
```python
logger.debug("xx")
logger.info("xx")
logger.warning("xx")
logger.error("xx")
logger.critical("xx")
```


#### 4.实现日志切割
```python
from logging import handlers

#按文件大小切割，当文件超过1Ki时，则创建新的，一共保留5个文件
rh = handlers.RotatingFileHandler("文件名", maxBytes = 1024, backupCount = 5, encoding = "utf8")

#按时间切割，每24小时创建新的文件，最多保留5个文件
th = handlers.TimedRotatingFileHandler("文件名", when = "h", interval = 24, backupCount = 5， encoding = "utf8")
```

#### 5.关闭某个 日志器
```python
logging.getLogger(<LOGGER_NAME>).disabled = True
```
