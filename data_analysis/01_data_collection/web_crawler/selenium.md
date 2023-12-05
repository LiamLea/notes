# selenium


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [selenium](#selenium)
    - [使用](#使用)
      - [1.环境准备](#1环境准备)
      - [2.打开浏览器（即创建驱动）](#2打开浏览器即创建驱动)
      - [3.打开指定网页](#3打开指定网页)
      - [4.定位元素(一定要唯一)：](#4定位元素一定要唯一)
      - [5.操作元素](#5操作元素)
      - [6.元素的属性：](#6元素的属性)
      - [7.通过 css selector定位（css selector通过拷贝得到）](#7通过-css-selector定位css-selector通过拷贝得到)
      - [8.通过xpath定位（xpath通过拷贝得到）](#8通过xpath定位xpath通过拷贝得到)
      - [9.css selector和下xpath比较：](#9css-selector和下xpath比较)
      - [10.模拟用户事件](#10模拟用户事件)
      - [11.设置等待时间](#11设置等待时间)
    - [selenium进阶](#selenium进阶)
      - [1.对弹出的处理：](#1对弹出的处理)
      - [2.自动化测试验证码解决方案](#2自动化测试验证码解决方案)

<!-- /code_chunk_output -->


### 使用

#### 1.环境准备
安装selenium模块
下载相应浏览器的驱动，放入python的路径下

#### 2.打开浏览器（即创建驱动）
```python
driver=selenium.webdriver.Chrome()
```

#### 3.打开指定网页
```python
driver.get(url)
```

#### 4.定位元素(一定要唯一)：  
* 通过id：
```python
driver.find_element_by_id('xx')
```
* 通过name：
```python
driver.find_element_by_name('xx')
```
* 通过class：	
```python
driver.find_element_by_class_name('xx')
```
* 通过a标签的内容：	
```python
driver.find_element_by_link_text('xx')      
```
* 通过a标签的部分内容：
```python
driver.find_element_by_partial_link_text('xx')
```
* 通过标签名：
```python
driver.find_element_by_tag_name('xx')
```

#### 5.操作元素
```python
#网元素内输入内容
send_keys('xx')

#点击相应元素
click()

#清空元素的内容
back()

#后退页面
back()

#最大化窗口
maximize_window()

#提交表单
submit()	
```

#### 6.元素的属性：
* 标签名
  * tag_name
* 文本内容
  * text

#### 7.通过 css selector定位（css selector通过拷贝得到）
```python	
driver.find_element_by_css_selector('xx')
```

#### 8.通过xpath定位（xpath通过拷贝得到）
```python
driver.find_element_by_path('xx')
```

#### 9.css selector和下xpath比较：
* 这两种是最常用的方法，，缺点是太长，看起来不方便
  * css是尽量描述该元素的属性，从而唯一确定一个元素，有时可能会匹配到多个
  * xpath利用路径能够唯一确定一个元素

#### 10.模拟用户事件
```python
from selenium.webdriver.common.action_chains import ActionChains

#这是一个链，最后调用perform()方法时，事件依次执行
ActionChains(driver).<action1>.<action2>	
```

* 事件:
```python
click(ele)            #单击某个元素
context_click(ele)    #鼠标右键某个元素
double_click(ele)     #双击某个元素
move_to_element(ele)  #鼠标移动到某个元素，即hover
ele.send_keys('xx')   #输入内容到某个元素，输入之前先清空clear()
```

#### 11.设置等待时间

* 强制等待：
```python
time.sleep(n)
```
* 隐形等待：
```python
driver.implicitly_wait(n)		//最长等待n秒,对下面的查找都有效
```
* 显性等待：
  * 最长等待n秒，每m秒检测一次，超市没有找到则抛出异常
  ```python
  from selenium.webdriver.support.ui import WebDriverWait
  from selenium.webdriver.common.by import By
  from selenium.webdriver.support import expected_conditions as EC
  ele=WebDriverWait(driver,n,m).until(EC.presence_of_element_located((By.xx,'xx'))
  ```

***

### selenium进阶

#### 1.对弹出的处理：

* 出现弹窗后，首先要切换到弹窗
```python
win=driver.switch_to_alert()
```

* 处理弹窗
```python
win.accept()	#确定
win.dismiss()	#取消
```

#### 2.自动化测试验证码解决方案
* 破解验证码：ocr或AI机器学习，不可取
* 绕过验证码：让开发人员临时关闭或提供一个万能的验证码
* 使用cookie（登录主要是为了拿cookie，获取登录凭证），最常用的方法：
```python
driver.add_cookie({'name':'token','value':'xx'})
```