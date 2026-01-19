# Vite


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Vite](#vite)
    - [Ovewview](#ovewview)
      - [1.Why Vite](#1why-vite)
      - [2.How (as an npm-based tool)](#2how-as-an-npm-based-tool)

<!-- /code_chunk_output -->


### Ovewview

#### 1.Why Vite
* Converts TS/TSX → JS fast
* Bundles + optimizes for production into `dist/`
* Dev server and Hot reload (for local development)

#### 2.How (as an npm-based tool)

* `packgae.json`
```json
{
  "name": "my-app",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
```