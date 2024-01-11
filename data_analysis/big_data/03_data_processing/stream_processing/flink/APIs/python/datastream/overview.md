# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [基本使用](#基本使用)
        - [(1) 配置](#1-配置)
      - [1.数据源](#1数据源)
        - [(1) kafka](#1-kafka)

<!-- /code_chunk_output -->

```shell
pip install apache-flink==1.18.0
```

### 基本使用

* `a.txt`
```txt
hello flink
hello spark
hello hive
```

```python
from pyflink.common import Types
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.common import Configuration

def split_words(x):
    result = []
    for i in x.split():
        result.append((i,1))
    return result

#配置
conf = Configuration().set_string(key="rest.port", value="8081")

# 创建执行环境
env = StreamExecutionEnvironment.get_execution_environment(conf)

# 读取数据
ds = env.read_text_file("a.txt")
# socketTextStream 从socket读取数据，pyflink不支持
# ds = env.socketTextStream('localhost', 9999)

# 所有的结果返回都是列表
# output_type说明列表中每个元素的类型
# 使用索引为0的元素进行分组，求索引为1的元素的和
ds = ds.flat_map(split_words, output_type=Types.TUPLE([Types.STRING(),Types.INT()]))\
    .key_by(lambda x: x[0], key_type=Types.STRING())\
    .sum(1)

ds.print()

# 开始读取数据
env.execute("test_app")

'''
结果：由于是流处理，所以每一行是一个输入，有一个输入计算一次，每次计算都保留结果（所以是有状态的）
2> (spark,1)
5> (flink,1)
4> (hello,1)
4> (hello,2)
4> (hello,3)
10> (hive,1)
'''
```

##### (1) 配置

* 常用配置
```python
env.set_parallelism(4)
```

* 更多配置
[参考](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/deployment/config/)

#### 1.数据源

##### (1) kafka
* 需要下载依赖的jar，然后加载该jar包，[参考](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/connectors/datastream/kafka/)
    * 直接加载（建议）
    ```shell
    cp /home/liamlea/Downloads/flink-sql-connector-kafka-3.0.2-1.18.jar ~/miniconda3/envs/flink/lib/python3.9/site-packages/pyflink/lib/
    ```
    * 在代码中加载
    ```python
    env.add_jars("file:///home/liamlea/Downloads/flink-sql-connector-kafka-3.0.2-1.18.jar")
    ```
```python
env = StreamExecutionEnvironment.get_execution_environment()

source = KafkaSource.builder() \
    .set_bootstrap_servers("10.10.10.163:19092") \
    .set_topics("flink-test_topic") \
    .set_group_id("my-group-1") \
    .set_starting_offsets(KafkaOffsetsInitializer.committed_offsets(KafkaOffsetResetStrategy.LATEST)) \
    .set_value_only_deserializer(SimpleStringSchema()) \
    .build()

ds = env.from_source(source, WatermarkStrategy.no_watermarks(), "Kafka Source")
```