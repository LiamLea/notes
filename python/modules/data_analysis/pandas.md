# pandas

[toc]

### 概述

#### 1.pandas
提供二维表的分析能力

#### 2.支持从多种格式中读取数据
* csv（comma-separated values）

***

### 使用

#### 1.读取数据
```csv
name , liyi , lier , lisan
math_score , 89, 72, 90
sport_score , 91, 99, 100
english_score , 88, 89, 91
```

```python
#默认engine为c语言，sep就不能使用正则（修改为python后可以）
#sep要去掉空格，不然后面使用的话也需要相应的空格
data = pandas.read_csv("<filename>", engine = "python", sep = r"\s*,\s*")
```



#### 3.使用数据

* 读取后生成的数据结构

|name|liyi|lier|lisan|
|-|-|-|-|
|math_score|89|72|90|
|sport_score|91|99|100|
|english_score|88|89|91|

* 使用该数据结构

```python
data["liyi"]    #获取liyi这一列，list(data["liyi"])：[89, 91, 88]

data.columns    #获取所有的列名，list(data.columns)：['name', 'liyi', 'lier', 'lisan']
data.col[0]     #获取第一行数据，list(data.col[0])：['math_score', 89, 72, 90]
```
