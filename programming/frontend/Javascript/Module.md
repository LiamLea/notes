# Module


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Module](#module)
    - [Overview](#overview)
      - [1.Module Systems](#1module-systems)
        - [(1) CommonJS (legacy, depend on nodejs)](#1-commonjs-legacy-depend-on-nodejs)
        - [(2) ES modules](#2-es-modules)
        - [(3) main differences](#3-main-differences)
      - [2.strict mode](#2strict-mode)

<!-- /code_chunk_output -->


### Overview

#### 1.Module Systems

##### (1) CommonJS (legacy, depend on nodejs)
```js
// import
const x = require("./x");
// export
module.exports = { x };
```

##### (2) ES modules
```js
// import
import x from "./x.js";
// export
export { x };
```

* use ES modules in Web Browser
```html
<script type="module" src="app.js"></script>
```

* use ES modules in Nodejs: `package.json`
```json
{
  "name": "my-lambda-app",
  "version": "1.0.0",
  "type": "module"  // <--- This tells Node.js to treat all .js files as ESM
}
```

##### (3) main differences

* commonjs
  * **Syntax**: Uses `require()` to pull code in and `module.exports` to push code out.

  * **Behavior**: It is **synchronous**. When you call `require()`, Node.js stops everything else, reads the file from your hard drive, executes it, and then continues.

  * **File Extension**: Usually `.js` (by default) or `.cjs`.

* ES module
  * **Syntax**: Uses `import` to pull code in and `export` to push code out.

  * **Behavior**: It is asynchronous. It pre-scans the files to see how they connect before executing them. This allows for features like Top-Level Await and Tree Shaking (removing unused code to make the file smaller).

  * **File Extension**: Usually `.mjs` or `.js` (if you add `"type": "module"` to your `package.json`).

#### 2.strict mode

unable to access variables from the broswer console, unless expose these variables in the code

* ES Modules are always in strict mode automatically