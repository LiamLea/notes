# NLP


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [NLP](#nlp)
    - [overview](#overview)
      - [1.word embedding](#1word-embedding)
        - [(1) embedding matrix: E](#1-embedding-matrix-e)
        - [(2) 衡量两个词的相似度: cosine similarity](#2-衡量两个词的相似度-cosine-similarity)
        - [(3) t-SNE (t-distributed Stochastic Neighbor Embedding)](#3-t-sne-t-distributed-stochastic-neighbor-embedding)
        - [(4) transfer learning](#4-transfer-learning)
        - [(5) analogy reasoning](#5-analogy-reasoning)
      - [2.learning word embeddings](#2learning-word-embeddings)
        - [(1) word2vec skip gram](#1-word2vec-skip-gram)
        - [(2) negative sampling](#2-negative-sampling)
        - [(3) Glove word vectors](#3-glove-word-vectors)
      - [3.sentiment classification](#3sentiment-classification)
      - [4.debias word embeddings](#4debias-word-embeddings)
        - [(1) identify bias direction](#1-identify-bias-direction)
        - [(2) neutralize](#2-neutralize)

<!-- /code_chunk_output -->


### overview

#### 1.word embedding


##### (1) embedding matrix: E

* 添加特征，一个特征一个维度，数值[-1,1]表示 该word 具有 该特征的程度

![](./imgs/nlp_01.png)


* embedding vector: 每个word的特征vector（即图中的一列）
  * $e_{example}$: 表示"example"的embedding vector
* embedding matrix: 由$n_v$个embedding vector组成
* $n_v$: vocabulary的数量
* $n_e$: embedding features的数量
* E: $(n_e,n_v)$
* $W_{example}$: 一个word的one-hot编码，$(n_v,)$
* $EW_{example}=e_{example}$
    * $e_{example}$: $(n_e,)$

##### (2) 衡量两个词的相似度: cosine similarity
* cos_sim(u,v) $=\cos\theta = \frac{u\cdot v}{\Vert u\Vert_2\Vert v\Vert_2}$
  * u、v分别是两个word的embedding vector

##### (3) t-SNE (t-distributed Stochastic Neighbor Embedding)
an unsupervised non-linear dimensionality reduction technique for data exploration and visualizing high-dimensional data
![](./imgs/nlp_07.png)
* 每个点是一个word

##### (4) transfer learning
使用别人训练好的word embedding

##### (5) analogy reasoning

比如: 基于 man->woman，进行推理 king -> ?

* 寻找$e_w$使得，maximize $sim(e_{king}-e_w,e_{man}-e_{woman})$，即相似度最高
* 所以maximize $sim(e_w,e_{king}-e_{man}+e_{woman})$
* 可以使用cosine similarity表示相似度

#### 2.learning word embeddings

* 训练出每个word的embedding vector（即embedding matrix）
  * embedding matrix的维度（即特征数）需要设置

##### (1) word2vec skip gram
![](./imgs/nlp_02.png)
![](./imgs/nlp_03.png)

* 给定context，求target word出现的概率
  * 这里context是一个word
  * context的位置不一定，可能离target word前后 $\pm 10$个单词

* projecttion:
  * 是一个embedding matrix，矩阵中的值都是需要训练的参数
    * $e_c$表示 context word的embedding vector

* output(softmax):
  * $p(t|c)=\frac{e^{\theta_t^Te_c}}{\sum\limits_{j=1}^{n_v}e^{\theta_j^Te_c}}$
    * $\theta_t$是softmax的参数，softmax输出每个word是target word的概率，最终结果是一个one-hot vector

##### (2) negative sampling

* 构建训练数据
  * 选择context word，target word，构建一个positive example（即y=1）
  * 选择context word，然后从vocabulary中随机选择一个word，构建一个negative example（即y=0）
  * 构建多个negative example
  ![](./imgs/nlp_04.png)

* $p(y=1|c,t)=\sigma(\theta_t^Te_c)$
  * 给定一个context word和一个word，该word是target(y=1)的概率

##### (3) Glove word vectors

* $X_{ij}$: #times j appears in the context of i 
* minimize $\sum\limits_{i=1}^{n_v}\sum\limits_{j=1}^{n_v}f(X_{ij})(\theta_i^Te_j + b_i + b_j'-\log X_{ij})^2$
  * 表示用$\log X_{ij}$来衡量两个词的相似度，所以希望训练出的embedding matrix能够接近这个指标
  * 两个求和是为了所有词 两两都要 进行一次比较
  * $f(X_{ij})$用作权重
    * 当$X_{ij}=0$时，log就会趋近负无穷，所以通过$f(X_{ij})=0$忽略掉
    * 对于经常出现的词（比如: of,is等），给较大的权重
      * 理解：两个词经常同时出现，但不代表这两个词是相似的
    * 对于不经常出现的词，给较小的权重
      * 理解：两个词不经常同时出现，但这两个词可能是相似的

#### 3.sentiment classification
![](./imgs/nlp_05.png)

#### 4.debias word embeddings

##### (1) identify bias direction
* $e_{male}-e_{femal}$
* $e_{he}-e_{she}$
* ...（不一定要很多，一个效果就可以很好了）
* average上面的值，能够得到一个vector g，只包含gender信息

* $sim(g, e)$
  * 当值为正数，表示输入的word，与男性有关
  * 当值为负数，表示输入的word，与女性有关
  * 对于actor/actress，与性别有关
  * 对于computure等，则与性别无关，所以希望输出的值为0

##### (2) neutralize

* 输入$e_{receptionist}$，需要清除其bias direction上的分量
![](./imgs/nlp_06.png)