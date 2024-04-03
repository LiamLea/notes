# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [基本使用](#基本使用)
      - [1.定义变量和初始化](#1定义变量和初始化)
      - [2.相关运算函数](#2相关运算函数)
      - [3.neuron network相关函数](#3neuron-network相关函数)

<!-- /code_chunk_output -->


### 基本使用

#### 1.定义变量和初始化
```python
#创建初始化器
initializer = tf.keras.initializers.GlorotNormal()

#定义变量并初始化
W1 = tf.Variable(initializer(shape=(25, 12288)), dtype=tf.float32)
b1 = tf.Variable(initializer(shape=(25,1)), dtype=tf.float32)
```

#### 2.相关运算函数

* 矩阵运算
```python
Z1 = tf.math.add(tf.linalg.matmul(W1, X), b1)
A1 = tf.keras.activations.relu(Z1)
Z2 = tf.math.add(tf.linalg.matmul(W2, A1), b2)
A2 = tf.keras.activations.relu(Z2)
Z3 = tf.math.add(tf.linalg.matmul(W3, A2), b3)
```

#### 3.neuron network相关函数

* activation
```python
tf.keras.activations.
```

* loss function
```python
tf.keras.losses.
``` 