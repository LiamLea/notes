import requests
import json
import sys

def send_msg(url,reminders,msg):
    headers={'Content-Type': 'application/json;charset=utf-8'}
    data={
        "msgtype": "text",
        "text": {
            "content": msg
        },
        "at": {
            "atMobiles": [
                reminders
            ],
            "isAtAll": False
        }
    }
    reponse=requests.post(url,headers=headers,data=json.dumps(data))
    return reponse.text

if __name__ == '__main__':
    msg=sys.argv[1]
    reminders=['18705157558']
    url='https://oapi.dingtalk.com/robot/send?access_token=8cecb934120e905d0e0277de7cf88c10747095d424e53a7ea46a9bd127cdf191'
    print(send_msg(url,reminders,msg))
