# distribute


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [distribute](#distribute)
    - [Overview](#overview)
      - [1.build source distribution (sdist) and built distributions (wheels)](#1build-source-distribution-sdist-and-built-distributions-wheels)
        - [(1) preparation](#1-preparation)
        - [(2) source-tree architeture](#2-source-tree-architeture)
        - [(3) create build file](#3-create-build-file)
        - [(4) build](#4-build)
        - [(5) upload](#5-upload)
        - [(6) install and import](#6-install-and-import)

<!-- /code_chunk_output -->


### Overview

[Python Packaging](https://packaging.python.org/en/latest/overview/)

#### 1.build source distribution (sdist) and built distributions (wheels)

##### (1) preparation
* install build
```shell
# enter venv
source <venv>

python3 -m pip install --upgrade build
```

##### (2) source-tree architeture
* `scan_service` must use `_` instead of `-` because python import cannot support `-`
``` 
---scan-service
|
|--- scan_service/
|
|--- pyproject.toml
|
|--- <others>
```

##### (3) create build file
* `pyproject.toml`(recommend) or `setup.py`
* use [setuptools](https://setuptools.pypa.io/en/latest/userguide/quickstart.html) as build backend

```toml
[build-system]
requires = ["setuptools>=42"]
build-backend = "setuptools.build_meta"

[project]
# this name is package name (pip install scan-service==0.0.8)
name = "scan-service"
version = "0.0.8"
authors = [
  { name="LiamLea", email="liweixiliang@gmail.com" },
]
description = "scan IT resources using ssh, snmp, wmi"
readme = "README.md"
requires-python = ">=3.6"
classifiers = [
    "Programming Language :: Python :: 3",
    "License :: OSI Approved :: MIT License",
    "Operating System :: OS Independent",
]

[tool.setuptools.packages]
# will put these directories into the package
find = { include = ["scan_service*"] }
```

* create a command
    ```toml
    [project.scripts]
    cli-name = "mypkg.mymodule:some_func"
    ```
    * When this project is installed, a cli-name executable will be created. cli-name will invoke the function some_func in the mypkg/mymodule.py file when called by the user. 

##### (4) build
```shell
cd scan-service
python3 -m build 
```
* check
```shell
$ ls dist/            
scan-service-0.0.8-py3-none-any.whl scan-service-0.0.8.tar.gz
```

##### (5) upload

```shell
python3 -m pip install --upgrade twine
python3 -m twine upload --repository testpypi dist/*
```

##### (6) install and import
```shell
pip install scan-service==0.0.8
pip show scan-service
```
```python
import scan_service
```