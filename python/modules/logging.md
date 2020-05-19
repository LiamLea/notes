# logging
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
#### 1.基本使用
```python
import logging

logging.debug("xx")
logging.info("xx")
logging.warning("xx")
logging.error("xx")
logging.critical("xx")
```

#### 2.配置
```python

#创建一个文件句柄
fh = logging.FileHandler("文件名", encoding = "utf8")
#创建标准错误输出的句柄
sh = logging.StreamHandler()

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
#### 3.实现日志切割
```python
from logging import handlers

#按文件大小切割，当文件超过1Ki时，则创建新的，一共保留5个文件
rh = handlers.RotatingFileHandler("文件名", maxBytes = 1024, backupCount = 5, encoding = "utf8")

#按时间切割，每24小时创建新的文件，最多保留5个文件
th = handlers.TimedRotatingFileHandler("文件名", when = "h", interval = 24, backupCount = 5， encoding = "utf8")
```
