# keras


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [keras](#keras)
    - [使用](#使用)
      - [1.输入必须是matrix](#1输入必须是matrix)
      - [2.demo](#2demo)

<!-- /code_chunk_output -->


### 使用

#### 1.输入必须是matrix

#### 2.demo

* demo: 怎么才能烤出好的咖啡豆
    * feature: 温度 和 时间

```python
#加载训练集
X,Y = load_coffee_data();

#进行特征缩放
norm_l = tf.keras.layers.Normalization(axis=-1)
norm_l.adapt(X)  # learns mean, variance
Xn = norm_l(X)

#创建神经网络模型，一共两层（不包括input layer）:
#   tf.keras.Input(shape=(2,)) 指定输入的数据格式
#   layer 1: 3个unit，使用sigmoid作为activation function
#   layer 2: 1个unit，使用sigmoid作为activation function
model = Sequential(
    [
        tf.keras.Input(shape=(2,)),
        Dense(3, activation='sigmoid', name = 'layer1'),
        Dense(1, activation='sigmoid', name = 'layer2')
     ]
)

# defines a loss function and specifies a compile optimization
model.compile(
    loss = tf.keras.losses.BinaryCrossentropy(),
    optimizer = tf.keras.optimizers.Adam(learning_rate=0.01),
)

# runs gradient descent and fits the weights to the data
model.fit(
    Xt,Yt,            
    epochs=10,
)

# 进行预测
X_test = np.array([
    [200,13.9],  # positive example
    [200,17],
    [200,11]])   # negative example
X_testn = norm_l(X_test)
predictions = model.predict(X_testn)
```