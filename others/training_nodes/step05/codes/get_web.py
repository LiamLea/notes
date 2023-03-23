import requests
import re
import wget
from urllib import error

def get_web(url):
    reponse=requests.get(url)
    content=reponse.text.split(sep='\n')
    pattern=re.compile('(http|https)://[-./\w]+\.(jpg|jpeg|png|gif)')
    im_list=[]
    for line in  content:
        m=pattern.search(line)
        if m:
            im_list.append(m.group())
    for i in im_list:
        try:
            wget.download(i,'/tmp/')
        except (error.HTTPError,ConnectionResetError):
            pass

if __name__ == '__main__':
    get_web('http://www.163.com')
