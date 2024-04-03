# keras


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [keras](#keras)
    - [使用](#使用)
      - [1.输入必须是matrix](#1输入必须是matrix)
      - [2.demo](#2demo)
        - [(2) softmax优化（减轻round-off error的影响）](#2-softmax优化减轻round-off-error的影响)

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

##### (2) softmax优化（减轻round-off error的影响）

* 未优化版
```python
model = Sequential(
    [ 
        Dense(25, activation = 'relu'),
        Dense(15, activation = 'relu'),
        Dense(4, activation = 'softmax')    # < softmax activation here
    ]
)
model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(),
    optimizer=tf.keras.optimizers.Adam(0.001),
)

model.fit(
    X_train,y_train,
    epochs=10
)

p_nonpreferred = model.predict(X_train)
```

* loss function会将a带入计算，而不会先计算a，因为浮点数的原因，如果先计算a会产生误差
* 用更准确的cost function，训练出参数后，再将参数代入，生成最后的模型
* $ \text {logit(p)}= \ln\frac{p}{1-p}$
    * 当概率等于0.5时，logit(p) = 0
    * 当概率小与0.5时，logit(p) < 0
    * 当概率大于0.5时，logit(p) > 0
    * 所以用logit score表示 未经过归一化的概率得分，分数越高，概率越高
```python
preferred_model = Sequential(
    [ 
        Dense(25, activation = 'relu'),
        Dense(15, activation = 'relu'),
        Dense(4, activation = 'linear')   #<-- Note
    ]
)

# logits表示最后一层raw, unnormalized的输出（还没有应用activation function）
# 在loss function使用from_logits=True，用于表示最后的输出没有做过任何处理
preferred_model.compile(
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),  #<-- Note
    optimizer=tf.keras.optimizers.Adam(0.001),
)

preferred_model.fit(
    X_train,y_train,
    epochs=10
)

#用更准确的cost function，训练出参数后，再将参数代入，生成最后的模型
p_preferred = preferred_model.predict(X_train)
sm_preferred = tf.nn.softmax(p_preferred).numpy()
```

* 每一层设置regulirization的$\lambda$
```python
model_r = Sequential(
    [
        Dense(120, activation = 'relu', kernel_regularizer=tf.keras.regularizers.l2(0.1), name="L1"), 
        Dense(40, activation = 'relu', kernel_regularizer=tf.keras.regularizers.l2(0.1), name="L2"),  
        Dense(classes, activation = 'linear', name="L3")  
    ], name="ComplexRegularized"
)
```