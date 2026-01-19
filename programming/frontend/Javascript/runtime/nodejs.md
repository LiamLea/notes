# Nodejs


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Nodejs](#nodejs)
    - [Ovewview](#ovewview)
      - [1.What](#1what)
      - [2.Demo](#2demo)
        - [(1) create `package.json`](#1-create-packagejson)
        - [(2) `server.js`](#2-serverjs)
        - [(3) run the code](#3-run-the-code)

<!-- /code_chunk_output -->


### Ovewview

#### 1.What
* run JavaScript outside the browser

#### 2.Demo

##### (1) create `package.json`
* create
```shell
npm init -y
```
* edit
```json
{
  "type": "module"
}
```

##### (2) `server.js`

```js
import http from "node:http";

const server = http.createServer((req, res) => {
  if (req.method === "GET" && req.url === "/hello") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ message: "Hello from ES Modules!" }));
    return;
  }

  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "Not found" }));
});

server.listen(3000, () => {
  console.log("✅ Server running at http://localhost:3000");
});
```

##### (3) run the code
```shell
node server.js
```