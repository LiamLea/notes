# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [设置](#设置)
      - [1.修改powershell编码](#1修改powershell编码)

<!-- /code_chunk_output -->

### 设置

#### 1.修改powershell编码
`regedit: HKEY_CURRENT_USER\Console\CodePage`
将值改为 65001 ，即utf8编码，默认为936，简体中文(GB2312)
