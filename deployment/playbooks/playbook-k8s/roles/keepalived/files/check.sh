#/bin/bash
if [ `curl  --insecure -s --write-out  '%{http_code}' --output /dev/null -m 5 https://127.0.0.1:6443/healthz` == 200 ];then exit 0 ;else exit 1;fi
