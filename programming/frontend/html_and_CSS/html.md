# html


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [html](#html)
    - [Overview](#overview)
      - [1.standard html boilerplate](#1standard-html-boilerplate)
      - [2.html element](#2html-element)
        - [(1) essential tags](#1-essential-tags)
      - [3.使用案例](#3使用案例)
        - [(1) div](#1-div)
        - [(2) input](#2-input)
        - [(3) button](#3-button)
      - [4.link css and js to html](#4link-css-and-js-to-html)

<!-- /code_chunk_output -->


### Overview

html is not styled, it's all about **structure**

#### 1.standard html boilerplate

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Hello, world!</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <script src="js/scripts.js"></script>
</body>
</html>
```

#### 2.html element

[参考](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference)

* tag and attribute
```html
<p class="some-class"> content </p>
<!-- 
    <p></p> is a tag
    'class' is an attribute 
-->
```

##### (1) essential tags

|tags|description|
|-|-|
|`<h1></h1>`|用户描述标题，一般只用到h1,h2,h3|
|`<p></p>`|paragraph，纯文本内容|
|`<span></span>`|选择paragraph中的一部分文本，使用CSS添加一些特殊的格式|
|`<div></div>`|content division|
|`<a></a>`|anchor|
|`<input />`|让用户输入|
|`<image />`|展示图片|
|`<button></button>`|定义按钮（需要监听该按钮的事件，从而调用相关函数|
|`<ul></ul>`| unordered list (bullet points)|
|`<ol></ol>`|ordered list (数字编号)

#### 3.使用案例

##### (1) div
* html
```html
<div class="div-1">
  <p> this is div 1</p>
</div>

<div class="div-2">
  <p> this is div 2</p>
</div>
```

* CSS
```css
.div-1, .div-2 {
  border: 1px solid black;
  margin: 20px;
}
```

##### (2) input
```html
<input name="input-1" placeholder="Enter email address here"/>
```

##### (3) button
```html
<button onclick="alertMe()">CLICK ME</button>

<!--
  监听click这个事件
  当点击了这个按钮，则调用alerMe()
-->
```

```js
function alertMe() {
  alert('Hi!');
}
```

#### 4.link css and js to html

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- ... -->

    <!-- link css file to the html -->
    <link rel="stylesheet" href="css/styles.css">

  </head>

  <body>
    <!-- ... -->

    <!-- link js file to the html -->
    <script src="js/scripts.js"></script>
    
  </body>

</html>
```