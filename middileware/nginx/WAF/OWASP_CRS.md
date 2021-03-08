# OWASP CRS

[toc]

### 概述

#### 1.OWASP CRS
open web application security core rule set

#### 2.核心规则集工作原理
* 提供 通用的黑名单
检查请求和响应的内容，判断是否存在攻击迹象
* 计分
当request违反一个rule，inbound_anomaly_score（入站异常分数）就会增加，当经过了所有request rules，判断分数是否达到了阈值，如果达到了阈值，这个请求就会被处理（默认处理是丢弃）
reponse同理

#### 3.规则集解析
核心规则集rule id的范围：900,000 - 999,999
##### （1）`REQUEST-901-INITIALIZATION`
用于设置一些默认值（比如分数的阈值、paranoia级别等等）

##### （2）入站规则校验

##### （3）`REQUEST-949-BLOCKING-EVALUATION.conf`
检查入站异常分数，如果达到阈值，则block请求

##### （4）出战规则校验

##### （5）`RESPONSE-959-BLOCKING-EVALUATION.conf`
检查出站异常分数，如果达到阈值，则block响应

##### （6）统计：`RESPONSE-980-CORRELATION.conf`
在日志阶段，进行统计此次请求-响应的过程（比如入站异常的分数、出站异常的分数）
会记录在nginx的error日志中（级别为info）

***

### 使用

#### 1.下载规则集
```shell
wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.0.2.tar.gz
#解压并放到某一个路径下
```

#### 2.创建核心规则集的基础配置文件
用于 设置核心规则集 的基础配置
```shell
mv crs-setup.conf.example crs-setup.conf
```

#### 3.在modsecurity中嵌入核心规则集
在`modsecurity.conf`添加
```shell
#导入核心规则集的基础配置
Include /etc/nginx/crs/crs-setup.conf

#添加核心规则集的基础配置

#定义了两个变量：入站异常分数 和 出站异常分数（默认就为5，这里明确定义，只是为了提醒使用者）
SecAction "id:900110,phase:1,pass,nolog,\
  setvar:tx.inbound_anomaly_score_threshold=5,\
  setvar:tx.outbound_anomaly_score_threshold=5"

#定义：paranoia级别（1-4），级别越高，过滤越严格，越容易误报
SecAction "id:900000,phase:1,pass,nolog,\
  setvar:tx.paranoia_level=1"

#在导入核心规则集前，排除的规则
#SecRuleRemoveById <rule_id>
#SecRuleRemoveByTag "<rule_tag>"
#...

#导入核心规则集
Include /etc/nginx/crs/rules/REQUEST-901-INITIALIZATION.conf
Include /etc/nginx/crs/rules/REQUEST-903.9001-DRUPAL-EXCLUSION-RULES.conf
Include /etc/nginx/crs/rules/REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
Include /etc/nginx/crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf
Include /etc/nginx/crs/rules/REQUEST-910-IP-REPUTATION.conf
Include /etc/nginx/crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf
Include /etc/nginx/crs/rules/REQUEST-912-DOS-PROTECTION.conf
Include /etc/nginx/crs/rules/REQUEST-913-SCANNER-DETECTION.conf
Include /etc/nginx/crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf
Include /etc/nginx/crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf
Include /etc/nginx/crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf
Include /etc/nginx/crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf
Include /etc/nginx/crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf
Include /etc/nginx/crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf
Include /etc/nginx/crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf
Include /etc/nginx/crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf
Include /etc/nginx/crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
Include /etc/nginx/crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf
Include /etc/nginx/crs/rules/RESPONSE-950-DATA-LEAKAGES.conf
Include /etc/nginx/crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf
Include /etc/nginx/crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf
Include /etc/nginx/crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf
Include /etc/nginx/crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf
Include /etc/nginx/crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf
Include /etc/nginx/crs/rules/RESPONSE-980-CORRELATION.conf

#在导入核心规则集后，排除的规则
#SecRuleRemoveById <rule_id>
#SecRuleRemoveByTag "<rule_tag>"
#...
```

***

### 解决误报

#### 1.禁用某个规则

```shell
SecRuleRemoveById <rule_id>
#或者 SecRuleRemoveByTag "<rule_tag>"
```
* 缺点：
  * 增加被攻击的风险

#### 2.针对某个api禁用某个规则
```shell
SecRule REQUEST_FILENAME "@streq /login/Login.do" \
    "phase:1,nolog,pass,id:15000,ctl:ruleRemoveById=932160"
```

#### 3.针对某个参数禁用某个规则
```shell
#当参数中包含password时，排除932160这个rule
SecRuleUpdateTargetById 932160 !ARGS:password

#也可以加一些限制条件
SecRule REQUEST_HEADERS:Referer "@streq http://localhost/login/displayLogin.do" \
    "phase:1,nolog,pass,id:15000,ctl:ruleRemoveTargetById=932160;ARGS:password"
```
