# uv


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [uv](#uv)
    - [Usage](#usage)
      - [1.Basic Usage](#1basic-usage)
        - [(1) install dependencies](#1-install-dependencies)

<!-- /code_chunk_output -->


### Usage

[Ref](https://docs.astral.sh/uv/guides/)

#### 1.Basic Usage

##### (1) install dependencies
* according to `pyproject.toml`
```shell
uv sync

# will create .venv in the current dir
# --active: Sync dependencies to the active virtual environment
```