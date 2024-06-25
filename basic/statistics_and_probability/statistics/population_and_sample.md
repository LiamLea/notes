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
        - [(3) 特殊情况](#3-特殊情况)
      - [3.confidence intervals](#3confidence-intervals)
        - [(1) 前提](#1-前提)
        - [(2) confidence intervals and margin of error](#2-confidence-intervals-and-margin-of-error)
        - [(3) estimating a population proportion](#3-estimating-a-population-proportion)
        - [(4) estimating a population mean](#4-estimating-a-population-mean)

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

**已知population，分析sampling distribution（即每次采样，某种统计指标可能出现的情况）**

##### (1) sampling distribution of a sample propotion
* population
  * X: number of successes in **n** trials (在采样场景下就是n samples) where P(success) for each trial is **p**
  * $\mu_X=np$
  * $\sigma_X=\sqrt{np(1-p)}$
* sample (样本数为：n)
  * 根据10% rule，这里每个样本都可以看作独立的
  * **sample propotion**: propotion of the number of successes to n samples
    * $\hat p=\frac{\text {\# of successes in a sample}}{\text {\# of samples}}=\frac{X}{n}$

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
  
  ![](./imgs/ps_02.png)

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

    ![](./imgs/ps_03.png)

##### (3) 特殊情况
* 当population是Bernoulli distribution时，$\hat p=\overline x$，所以 $\hat p$的分布 == $\overline x$ 的分布

#### 3.confidence intervals

**根据某次采样结果**，分析 $\hat p$ 或 $\overline x$ 的**sampling distribution**，**估计** $p$ 或 $\mu$ 可能所在区间


##### (1) 前提
* random sample
* normal distribution
  * 比如: 对于sampling distribution of a sample propotion，需要满足:
    * $np \ge 10$
    * $n(1-p) \ge 10$
* independent:
  * 10% rule

##### (2) confidence intervals and margin of error

* population的指标可以使用smaple来估计
  * $p\approx\hat p=\frac{\text{\# of successes in the sample}}{\text{\# of samples}}$
  * $\mu\approx\overline x$
  * $\sigma\approx S_{n-1}$

* 寻找某个区间（confidence intervals），$p$ 或 $\mu$ 有一定概率（confidence level）落在该区间内
  * 比如: **每一次sample**，$p$ 有 95\% 的机率落在 $[\hat p-2\sigma_{\hat p}\ ,\ \hat p+2\sigma_{\hat p}]$中
    * 95%称为 **confidence level**
    * 这个区间称为 **confidence intervals**
    * $2\sigma_{\hat p}$称为 **margin of error**
    * 其中2称为 **critical value (Z)**
      * 即Z-score

##### (3) estimating a population proportion
* $P(\hat p \text{ is within }2\sigma_{\hat p} \text { of } p) \Leftrightarrow P(p \text{ is within }2\sigma_{\hat p} \text { of } \hat p)$
  * 所以问题转换为：根据此次sample，分析 $\hat p$ 的sampling distribution，寻找区间，满足 $P(p \text{ is within } \hat p\pm Z\cdot\sigma_{\hat p})=\text {confidence level}$

##### (4) estimating a population mean
* $P(\overline x \text{ is within }2\sigma_{\overline x} \text { of } \mu) \Leftrightarrow P(\mu \text{ is within }2\sigma_{\overline x} \text { of } \overline x)$
  * 所以问题转换为：根据此次sample，分析 $\overline x$ 的sampling distribution，寻找区间，满足 $P(\mu \text{ is within } \overline x\pm Z\cdot\sigma_{\overline x})=\text {confidence level}$

* ![](./imgs/ps_01.png)
  * 每一行是一次sample
  * 每一次sample，$\mu$有confidence level的机率落在confidence intervals的区间中