# email和smtplib模块
```python
from email.mime.text import MIMEText
from email.header import Header
import smtplib
```
* 准备邮件
```python
message=MIMEText('正文\r\n','plain','utf8')  
#plain表示纯文本(在mime中定义的)
message['From']=Header('发件人','utf8')
message['To']=Header('收件人','utf8')
message['Subject']=Header('主题')
```
* 本地发送邮件
```python
smtp=smtplib.SMTP('127.0.0.1')
smtp.sendmail('发件人',['收件人1'],message.as_bytes())
```
* 网络发送邮件
```python
smtp=smtplib.SMTP()
smtp.connect(server)        
#与邮件服务器建立连接（如：smtp.126.com)
#smtp.starttls()            //如果服务器要求安全连接，加这一句
smtp.login(sender,passwd)   
#sender为发件人的地址，passwd为授权码，不是登录密码
smtp.sendmail(sender,receivers,message.as_bytes())
```
