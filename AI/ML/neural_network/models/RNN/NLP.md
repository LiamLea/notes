# NLP


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [NLP](#nlp)
    - [overview](#overview)
      - [1.word embedding](#1word-embedding)
        - [(1) embedding matrix: E](#1-embedding-matrix-e)
        - [(2) transfer learning](#2-transfer-learning)
        - [(3) analogy reasoning](#3-analogy-reasoning)

<!-- /code_chunk_output -->


### overview

#### 1.word embedding


##### (1) embedding matrix: E

* 添加特征，一个特征一个维度，数值[-1,1]表示 该word 具有 该特征的程度

![](./imgs/nlp_01.png)


* $n_v$: vocabulary的数量
* $n_e$: embedding features的数量
* E: $(n_e,n_v)$
* $W_{example}$: 一个word的one-hot编码，$(n_v,)$
* $EW_{example}=e_{example}$
    * $e_{example}$: 一个word的embedding features, $(n_e,)$

##### (2) transfer learning
使用别人训练好的word embedding

##### (3) analogy reasoning

比如: 基于 man->woman，进行推理 king -> ?

* cosine similarity
    * 寻找$e_w$使得，maximize $sim(e_{king}-e_w,e_{man}-e_{woman})$，即相似度最高
    * 所以maximize $sim(e_w,e_{king}-e_{man}+e_{woman})$
    * $sim(u,v)=\frac{u^Tv}{\Vert u\Vert_2\Vert v\Vert_2}$

