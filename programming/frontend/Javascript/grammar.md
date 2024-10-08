# grammar


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [grammar](#grammar)
    - [overview](#overview)
      - [1.declare varianbles](#1declare-varianbles)
      - [2.data type](#2data-type)
        - [(1) object](#1-object)
      - [3.loop](#3loop)
      - [4.function](#4function)
      - [5.built-in utility methods](#5built-in-utility-methods)

<!-- /code_chunk_output -->


### overview

#### 1.declare varianbles

```js
// constant variable
const V1 = 10;

// common variable
let v2 = 10;
v2 = 20

// 不建议使用var，因为能够redeclare同一个变量名，一不小心就容易出错
```

#### 2.data type
##### (1) object
* 类似字典
* 有多个properties
```js
const objectVariable = {prop1: 20, prop2: 30}
objectVariable.prop1
objectVariable['prop1']
```

#### 3.loop
```js
for (let i = 0;i < 100; i++) {}
```

#### 4.function
```js
// most common way to define function
const myFunction = () => {}

//traditional way
function myFunction(param1, param2) {}

// call immediately
(function myFunction() {})();

//assign function to a variable
const function1 = function() {
    return 20;
}
```

#### 5.built-in utility methods