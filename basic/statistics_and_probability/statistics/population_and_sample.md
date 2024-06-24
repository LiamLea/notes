# population and sample


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [population and sample](#population-and-sample)
    - [overview](#overview)
      - [1.population and sample](#1population-and-sample)
        - [(1) sample measures](#1-sample-measures)
        - [(2) 为什么除以n-1](#2-为什么除以n-1)
        - [(3) random sample strategies](#3-random-sample-strategies)
        - [(4) sample bias](#4-sample-bias)
      - [2.sampling distribution](#2sampling-distribution)
        - [(1) sampling distribution of a sample propotion](#1-sampling-distribution-of-a-sample-propotion)
        - [(2) sampling distribution of a sample mean (central limit theorem)](#2-sampling-distribution-of-a-sample-mean-central-limit-theorem)
      - [3.confidence intervals](#3confidence-intervals)
        - [(1) confidence intervals and margin of error](#1-confidence-intervals-and-margin-of-error)

<!-- /code_chunk_output -->


### overview

#### 1.population and sample

当无法对整体进行统计时（由于数量大、数据无法获得等），可以进行采样统计，从而反映整体的统计信息

##### (1) sample measures
* mean: $\overline {x}$
* variance:
  * biased variance: $S^2_n=\frac{1}{n}\sum_{i=1}^n(x_i-\mu)^2$
  * unbiased variance: $S^2_{n-1}=\frac{1}{n-1}\sum_{i=1}^n(x_i-\mu)^2$
* standard deviation
  * biased standard deviation: $S_n$
  * unbiased standard deviation: $S_{n-1}$

##### (2) 为什么除以n-1
* 没有明确的证明，sample时，除以n-1，方差更准确
  * 当sample数量越多时
    * 数据越接近population
    * n-1影响就会越小

##### (3) random sample strategies
* simple random sample
* stratified sample
  * 比如：大一，大二，大三，大四，每一个年级抽取一部分样本
* clustered sample
  * 比如：在全校，抽取几个班级的学生

##### (4) sample bias 
* voluntary bias
* convenience bias
* reponse bias
* wording bias

#### 2.sampling distribution

由样本的统计数据 推测 整体的统计数据，描述推测值的分布情况

##### (1) sampling distribution of a sample propotion
根据 样本中某种类型的**占比**(下文中的$\hat p$) 评估 其在整体样本中的占比(下文中的$p$)

* population
  * X: number of successes in **n** trials where P(success) for each trial is **p**
  * $\mu_X=np$
  * $\sigma_X=\sqrt{np(1-p)}$
* sample (样本数为：n)
  * 根据10% rule，这里每个样本都可以看作独立的
  * **sample propotion**: propotion of number of successes to n samples
    * $\hat p=\frac{X}{n}$

* sampling distribution of a sample propotion ($\hat p$)
  * $\mu_{\hat p}=\frac{\mu_X}{n}=p$
  * $\sigma_{\hat p}=\frac{\sigma_X}{n}=\sqrt{\frac{p(1-p)}{n}}$
  * 当p在0.5附近时，趋近于normal distributions
  * 当p较小时（比如0.1）
    * 可能distribution skewd right
      * 因为概率的范围在0-1之间，所以会偏向右边
    * 但当样本数足够多时，$\sigma$就会很小，也会趋近于正态分布
  * 当p较大时（比如0.9）
    * 可能 distribution skewd left
    * 但当样本数足够多时，$\sigma$就会很小，也会趋近于正态分布
  * 趋近**normal distribution**的条件:
    * $np \ge 10$
    * $n(1-p) \ge 10$
  * 当趋近正态分布时，可以使用正太分布的相关特性 进行评估

##### (2) sampling distribution of a sample mean (central limit theorem)
* 对于任意分布的数据，
  * 每次取n个samples求平均值
  * 当取样次数很大时，样本平均值的分布 趋近正态分布
    * 当n越大，越趋近正态分布

* population
  * 任意分布（各种奇怪的分布都有可能）
    * $\mu$
    * $\sigma$

* sampling distribution of a sample mean ($\overline x$，样本数：n)
  * 趋近**normal distribution**
    * $\mu_{\overline x}=\mu$
    * $\sigma_{\overline x}^2=\frac{\sigma^2}{n}$

#### 3.confidence intervals

##### (1) confidence intervals and margin of error
估计$\mu$ (the mean of population) 可能所在区间

* 以**95% confidence level**为例:
* 根据sampling distribution of a sample propotion，可得 
    * $P(\hat p \text{ is within }2\sigma_{\hat p} \text { of } p)=95\%$
    * 所以, $P(p \text{ is within }2\sigma_{\hat p} \text { of } \hat p)=95\%$
    * 其中，$\sigma_{\hat p}=\sqrt{\frac{p(1-p)}{n}}\approx\sqrt{\frac{\hat p(1-\hat p)}{n}}$
    * 所以，能够通过样本计算得到 $[\hat p-2\sigma_{\hat p}\ ,\ \hat p+2\sigma_{\hat p}]$
    * 这个区间称为 **confidence intervals**
    * $2\sigma_{\hat p}$称为 **margin of error**
    * 所以：**每一次sample，$\mu$有 95\% (confidence level) 的机率落在 $[\hat p-2\sigma_{\hat p}\ ,\ \hat p+2\sigma_{\hat p}]$ (confidence intervals)中**

![](./imgs/ps_01.png)
* 每一行是一次sample
* 每一次sampl，$\mu$有confidence level的机率落在confidence intervals的区间中