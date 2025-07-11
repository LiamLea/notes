# google APIs

[toc]

### Overview

#### 1.APIs discovery (e.g. python)

[google-api-python-client](https://github.com/googleapis/google-api-python-client/blob/main/docs/start.md)

##### (1) Building and calling a service

[Supported APIs](https://github.com/googleapis/google-api-python-client/blob/main/docs/dyn/index.md)

* example (use service account to complete authrization)
```python
from google.oauth2 import service_account
import googleapiclient.discovery

SCOPES = ['https://www.googleapis.com/auth/admin.directory.user', 'https://www.googleapis.com/auth/admin.directory.user.readonly', 'https://www.googleapis.com/auth/cloud-platform']
SERVICE_ACCOUNT_FILE = '<key_json_file>'

credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# delegate domain-wide authority to the service account
# because The Admin SDK Directory API does not allow service accounts to access user data directly
delegated_credentials = credentials.with_subject('user@example.org')

service = googleapiclient.discovery.build('admin', 'directory_v1', credentials=delegated_credentials)

result = service.users().list(domain="mycp.jp").execute()
print(result)
```

#### 2.More APIs
[APIs Explorer](https://developers.google.com/apis-explorer/)