# OS

[toc]

### 概述

#### 1.应用程序与内核交互的三种情况：
* 中断
* 异常
* 系统调用（软中断）

#### 2.内存有两种：
* RAM		  	
random access memory，断电后，这里面的内容都会清空  
</br>
* ROM			
read only memory，用来存储BIOS程序（主要功能：加电自检(检查硬件状况)、加载bootloader）

#### 3.trap和interrupt区别
* trap
  * 同步的
  * 是用户进程中的异常
  * 是由程序员发起，希望将控制权转移到特殊的处理程序
* interrupt
  * 异步的
  * 通常由硬件产生，比如键盘的输入等
