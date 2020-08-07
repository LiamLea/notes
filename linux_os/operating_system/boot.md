[toc]
### 概述
#### 1.启动流程
```mermaid
graph LR
A("BIOS")--"加载booloader"-->B
subgraph bootloader工作
B("运行bootloader(linux上就是grub),并把控制权交给bootloader")
B-->C("加载kernel（ramdisk或ramfs支持）")
C-->D("识别根文件（并将控制权交给kernel）")
end
D-->E("init程序")
```
bootloader有**两个阶段**：
```mermaid
graph LR
A("读取磁盘的MBR，运行bootloader程序(grub)")--"根据MBR的指引去相应分区（MBR之后的扇区会提供识别该分区文件系统的方法）找到第2阶段所需要的文件"-->B("读取grub配置，完成内核加载和文件系统识别")
```
#### 2.内存有两种：
* RAM		  	
random access memory，断电后，这里面的内容都会清空  
</br>
* ROM			
read only memory，用来存储BIOS程序（主要功能：加电自检(检查硬件状况)、加载bootloader）  

#### 3.加载bootloader
* 读取磁盘的主引导扇区（MBR），指明去哪个分区（即文件系统）读取 引导加载程序（bootloader）  
* 读取指定分区的引导扇区，从而定位到bootloader程序，进而将bootloader程序读取到内存中来  
* bootloader程序的主要作用是**识别磁盘的文件系统**  
