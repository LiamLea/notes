### 函数补充
#### 1.反汇编：`dis.dis(<func>)`
dis：disassemble
```python
import dis

def func():
  a = 0
  a += 1

dis.dis(func)   #输入汇编语言（即CPU指令）
```
