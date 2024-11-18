# jsonnet

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [jsonnet](#jsonnet)
    - [Overview](#overview)
      - [1.jsonnet](#1jsonnet)
        - [(1) convert to yaml](#1-convert-to-yaml)
        - [(2) combine multiple jsonnet](#2-combine-multiple-jsonnet)
      - [2.jsonnet-bundler](#2jsonnet-bundler)
      - [3.standard library](#3standard-library)
    - [Grammar](#grammar)
      - [1.Syntax](#1syntax)
        - [(1) Variables](#1-variables)
        - [(2) References](#2-references)
        - [(3) Operation](#3-operation)
        - [(4) Function](#4-function)
        - [(5) Array and Object](#5-array-and-object)
        - [(6) Object-Orientation](#6-object-orientation)
        - [(7) override](#7-override)
      - [2.Imports](#2imports)
      - [3.Top-level arguments](#3top-level-arguments)
      - [4.debug](#4debug)
      - [5.modify anything (at the top level)](#5modify-anything-at-the-top-level)

<!-- /code_chunk_output -->


### Overview

#### 1.jsonnet
```shell
jsonnet -J <lib_dir> <jsonnet_file>
```

##### (1) convert to yaml

```shell
mkdir -p manifests

# jsonnet -J <lib_dir> -m manifests <jsonnet_file>
#   output relative file path: e.g. manifests/alertmanager-alertmanager
# {}: represent each item from input pipe, i.e. relative file path
jsonnet -J <lib_dir> -m manifests <jsonnet_file> | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml'

# Make sure to remove json files
find manifests -type f ! -name '*.yaml' -delete
```

##### (2) combine multiple jsonnet
```jsonnet
{
  k1: "v1",
  k2: {
    aa: "bb",
  }
}

{
  k2: "v2",
}
```

* output
```json
{
  "k1": "v1",
  "k2": "v2"
}
```

#### 2.jsonnet-bundler

* generate dependency `jsonfile.json`
```shell
jb init
```

* install modules
```shell
# Install new dependencies. Existing ones are silently skipped
jb install https://github.com/anguslees/kustomize-libsonnet
```

* update modules
```shell
jb update
```

* demo: import the installed module
```jsonnet
local kustomize = import 'kustomize-libsonnet/kustomize.libsonnet';

local my_resource = {
  metadata: {
    name: 'my-resource',
  },
};

kustomize.namePrefix('staging-')(my_resource)
```

#### 3.standard library

[Ref](https://jsonnet.org/ref/stdlib.html)

```jsonnet
{
  standard_lib:
    std.join(' ', std.split('foo/bar', '/')),
  len: [
    std.length('hello'),
    std.length([1, 2, 3]),
  ],
}
```

* output
```json
{
  "len": [
    5,
    3
  ],
  "standard_lib": "foo bar"
}
```

***

### Grammar

[Ref](https://jsonnet.org/learning/tutorial.html)

#### 1.Syntax

* Trailing commas at the end of arrays / objects
* Fields that happen to be valid identifiers have no quotes
    * `'Tom Collins'` is invalid identifier
    * `Manhattan` is valid indentifier
* fields, defined with `::`, which do not appear in generated JSON

```jsonnet
/* A C-style comment. */
# A Python-style comment.
{
  cocktails: {
    'Tom Collins': {
      ingredients: [
        { kind: "Farmer's Gin", qty: 1.5 },
        { kind: 'Lemon', qty:: 1 },
      ],
      garnish: 'Maraschino Cherry',
      served: 'Tall',

      // Text blocks
      description: |||
        The Tom Collins is essentially gin and
        lemonade.  The bitters add complexity.
      |||,

    },
    Manhattan: {
      ingredients: [
        { kind: 'Rye', qty: 2.5 },
        { kind: 'Sweet Red Vermouth', qty: 1 },
      ],
      garnish: 'Maraschino Cherry',
      served: 'Straight Up',

      // Verbatim strings
      description: @'A clear \ red drink.',
    },
  },
}
```

* output 
```json
{
  "cocktails": {
    "Manhattan": {
      "description": "A clear \\ red drink.",
      "garnish": "Maraschino Cherry",
      "ingredients": [
        {
          "kind": "Rye",
          "qty": 2.5
        },
        {
          "kind": "Sweet Red Vermouth",
          "qty": 1
        }
      ],
      "served": "Straight Up"
    },
    "Tom Collins": {
      "description": "The Tom Collins is essentially gin and\nlemonade.  The bitters add complexity.\n",
      "garnish": "Maraschino Cherry",
      "ingredients": [
        {
          "kind": "Farmer's Gin",
          "qty": 1.5
        },
        {
          "kind": "Lemon"
        }
      ],
      "served": "Tall"
    }
  }
}
```

##### (1) Variables
```jsonnet
// A regular definition.
local house_rum = 'Banks Rum';

{
  // A definition next to fields.
  local pour = 1.5,

  Daiquiri: {
    ingredients: [
      { kind: house_rum, qty: pour, unit: 'leaves'},
      { kind: 'Lime', qty: 1 },
    ],
    served: 'Straight Up',
  },
}
```

* output
```json
{
  "Daiquiri": {
    "ingredients": [
      {
        "kind": "Banks Rum",
        "qty": 1.5,
        "unit": "leaves"
      },
      {
        "kind": "Lime",
        "qty": 1
      }
    ],
    "served": "Straight Up"
  }
}
```

##### (2) References

* `self` refers to the current object
* `$` refers to the outer-most object

```jsonnet
{
  'Tom Collins': {
    ingredients: [
      { kind: "Farmer's Gin", qty: 1.5 },
      { kind: 'Lemon', qty: 1 },
    ],
  },
  Martini: {
    local drink = self,
    ingredients: [
      {
        // Use the same gin as the Tom Collins.
        kind:
          $['Tom Collins'].ingredients[0].kind,
        qty: 2,
      },
      { kind: 'Dry White Vermouth', qty: drink.ingredients[0].qty },
    ],
  },
  // Create an alias.
  'Gin Martini': self.Martini,
}
```

* output.json
```json
{
  "Gin Martini": {
    "ingredients": [
      {
        "kind": "Farmer's Gin",
        "qty": 2
      },
      {
        "kind": "Dry White Vermouth",
        "qty": 2
      }
    ]
  },
  "Martini": {
    "ingredients": [
      {
        "kind": "Farmer's Gin",
        "qty": 2
      },
      {
        "kind": "Dry White Vermouth",
        "qty": 2
      }
    ]
  },
  "Tom Collins": {
    "ingredients": [
      {
        "kind": "Farmer's Gin",
        "qty": 1.5
      },
      {
        "kind": "Lemon",
        "qty": 1
      }
    ]
  }
}
```

##### (3) Operation
```jsonnet
{
  concat_array: [1, 2, 3] + [4],
  concat_string: '123' + 4,
  equality1: 1 == '1',
  equality2: [{}, { x: 3 - 1 }]
             == [{}, { x: 2 }],
  ex1: 1 + 2 * 3 / (4 + 5),
  // Bitwise operations first cast to int.
  ex2: self.ex1 | 3,
  // Modulo operator.
  ex3: self.ex1 % 2,
  // Boolean logic
  ex4: (4 > 3) && (1 <= 3) || false,
  // Mixing objects together
  obj: { a: 1, b: 2 } + { b: 3, c: 4 },
  // Test if a field is in an object
  obj_member: 'foo' in { foo: 1 },
  // String formatting
  str1: 'The value of self.ex2 is '
        + self.ex2 + '.',
  str2: 'The value of self.ex2 is %g.'
        % self.ex2,
  str3: 'ex1=%0.2f, ex2=%0.2f'
        % [self.ex1, self.ex2],
  // By passing self, we allow ex1 and ex2 to
  // be extracted internally.
  str4: 'ex1=%(ex1)0.2f, ex2=%(ex2)0.2f'
        % self,
  // Do textual templating of entire files:
  str5: |||
    ex1=%(ex1)0.2f
    ex2=%(ex2)0.2f
  ||| % self,
}
```

* output
```json
{
  "concat_array": [
    1,
    2,
    3,
    4
  ],
  "concat_string": "1234",
  "equality1": false,
  "equality2": true,
  "ex1": 1.6666666666666665,
  "ex2": 3,
  "ex3": 1.6666666666666665,
  "ex4": true,
  "obj": {
    "a": 1,
    "b": 3,
    "c": 4
  },
  "obj_member": true,
  "str1": "The value of self.ex2 is 3.",
  "str2": "The value of self.ex2 is 3.",
  "str3": "ex1=1.67, ex2=3.00",
  "str4": "ex1=1.67, ex2=3.00",
  "str5": "ex1=1.67\nex2=3.00\n"
}
```

##### (4) Function

```jsonnet
// Define a local function.
local func1(x, y=10) = x + y;

// Define a local multiline function.
local func2(x) =
  // define a local variable
  local temp = x * 2;
  
  [temp, temp + 1];

local object1 = {
  // A method
  my_method(x): x * x,
};

local Sour(spirit, garnish='Lemon twist') = {
  ingredients: [
    { kind: spirit, qty: 2 },
  ],
  garnish: garnish,
};

{
  // use inline function
  key1:
    (function(x) x * x)(5),
  
  key2: func1(2),
  
  key3: func2(4),

  key4: object1.my_method(3),

  standard_lib:
    std.join(' ', std.split('foo/bar', '/')),
  len: [
    std.length('hello'),
    std.length([1, 2, 3]),
  ],
   'Whiskey Sour': Sour('Bulleit Bourbon',
                       'Orange bitters'),
}
```

* output
```json
{
  "Whiskey Sour": {
    "garnish": "Orange bitters",
    "ingredients": [
      {
        "kind": "Bulleit Bourbon",
        "qty": 2
      }
    ]
  },
  "key1": 25,
  "key2": 12,
  "key3": [
    8,
    9
  ],
  "key4": 9,
  "len": [
    5,
    3
  ],
  "standard_lib": "foo bar"
}
```

##### (5) Array and Object

```jsonnet
local arr = std.range(5, 8);
{
  array_comprehensions: {
    higher: [x + 3 for x in arr],
    evens_and_odds: [
      '%d-%d' % [x, y]
      for x in arr
      if x % 2 == 0
      for y in arr
      if y % 2 == 1
    ],
  },
  object_comprehensions: {
    evens: {
      ['f' + x]: true
      for x in arr
      if x % 2 == 0
    },
  },
}
```

* output
```json
{
  "array_comprehensions": {
    "evens_and_odds": [
      "6-5",
      "6-7",
      "8-5",
      "8-7"
    ],
    "higher": [
      8,
      9,
      10,
      11
    ]
  },
  "object_comprehensions": {
    "evens": {
      "f6": true,
      "f8": true
    }
  }
}
```

##### (6) Object-Orientation

* merges two objects: `+`
    * `self`: a reference to the current object
    * `super`: access fields on a base object
* fields, defined with `::`, which do not appear in generated JSON

```jsonnet
local Base = {
  f: 2,
  g: self.f + 100,
  z:: "haha"
};

{
  Derived: Base + {
    f: 5,
    old_f: super.f,
    old_g: super.g,
  },
}
```

* output
```json
{
  "Derived": {
    "f": 5,
    "g": 105,
    "old_f": 2,
    "old_g": 105
  }
}
```

##### (7) override

* The `+:` field syntax for overriding deeply nested fields

```jsonnet
local Base = {
  f: 2,
  g: self.f + 100,
};

local WrapperBase = {
  Base: Base,
};

{
  WrapperDerived: {
    Base+: { f: 5 },
  },
}
```

* output
```json
{
  "WrapperDerived": {
    "Base": {
      "f": 5
    }
  }
}
```

#### 2.Imports

* Files designed for import by convention end with `.libsonnet`
* The `importstr` construct is for verbatim UTF-8 text
* The `importbin` construct is for verbatim binary data

* `'martinis.libsonnet`
```jsonnet
{
  'Vodka Martini': {
    ingredients: [
      { kind: 'Vodka', qty: 2 },
    ],
    garnish: 'Olive',
    served: 'Straight Up',
  },
  Cosmopolitan: {
    ingredients: [
      { kind: 'Vodka', qty: 2 },
    ],
    garnish: 'Orange Peel',
    served: 'Straight Up',
  },
}
```
* `garnish.txt`
```
Maraschino Cherry
```
* `main.jsonnet`
```jsonnet
local martinis = import 'martinis.libsonnet';

{
  'Vodka Martini': martinis['Vodka Martini'],
  Manhattan: {
    ingredients: [
      { kind: 'Rye', qty: 2.5 },
    ],
    garnish: importstr 'garnish.txt',
  },
}
```

* output
```json
{
  "Manhattan": {
    "garnish": "Maraschino Cherry",
    "ingredients": [
      {
        "kind": "Rye",
        "qty": 2.5
      }
    ]
  },
  "Vodka Martini": {
    "garnish": "Olive",
    "ingredients": [
      {
        "kind": "Vodka",
        "qty": 2
      }
    ],
    "served": "Straight Up"
  }
}
```

#### 3.Top-level arguments

the whole config is written as a function

* `a.jsonnet`

```jsonnet
function(prefix, brunch=false) {

  [if brunch then prefix + 'Bloody Mary']: {
    ingredients: [
      { kind: 'Vodka', qty: 1.5 },
    ],
  },
}
```

* render the jsonnet
  * jsonnet command
  ```shell
  jsonnet --tla-str prefix="Happy Hour " \
          --tla-code brunch=true a.jsonnet
  ```

  * import
  ```shell
  local mya=import 'a.jsonnet';
  mya("Happer Hour", true)
  ```

* output
```json
{
  "Happer HourBloody Mary": {
    "ingredients": [
      {
        "kind": "Vodka",
        "qty": 1.5
      }
    ]
  }
}
```

#### 4.debug

* origin
```jsonnet
local Person(name='Alice') = {
  name: name,
  welcome: 'Hello ' + name + '!',
};
{
  person1: Person(),
  person2: Person('Bob'),
}
```

* debug
  * `std.trace(<to_err>, <return>)`
  * can output various formats, e.g.
    * `std.toString(...)`
    * `std.manifestJson(...)`
    * `std.manifestYamlDoc(...)`
  * cannot output **hidden fields**
    * so can use method1, when hidden fields are called, it will print the value

```jsonnet
local Person(name='Alice') = {
  name: name,
  welcome: 'Hello ' + name + '!',
};
{
  // method-1:
  person1: std.trace('\n'+std.manifestJson(Person()), Person()),
  person2: Person('Bob'),
  // method-2
  debug: std.trace('\n'+std.manifestJson(self.person1), ""),
}
```

* output
  * json
  ```json
  {
    "person1": {
        "name": "Alice",
        "welcome": "Hello Alice!"
    },
    "person2": {
        "name": "Bob",
        "welcome": "Hello Bob!"
    }
  }
  ```
  * err
  ```
  TRACE: /Users/liamlea/Workspace/the-plant/repos/terraform/k8s/shared-test/addons/prometheus/temp.jsonnet:6 
  {
      "name": "Alice",
      "welcome": "Hello Alice!"
  }
  ```

#### 5.modify anything (at the top level)

* example (kube-prometheus: values.jsonnet)
```jsonnet
//...

{
  'kubernetes-prometheusRule'+: {
    spec+: {
      groups: [item for item in kp.kubernetesControlPlane.prometheusRule.spec.groups if item['name'] != 'kubernetes-system-scheduler' && item['name'] != 'kubernetes-system-controller-manager']
    }
  }
}
```