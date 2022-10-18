# lombok

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [lombok](#lombok)
    - [使用](#使用)

<!-- /code_chunk_output -->

### 使用

用于给类自动加上：构造函数、get、set等方法

```java
@Data
public class DataConfig {
    private String url;
    private String driverName;
    private String username;
    private String password;
}

```
