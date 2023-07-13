```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-test-1              
spec:
  storageClassName: <sc>
  accessModes: ["ReadWriteOnce"]  
  resources:
    requests:
      storage: <size>

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: volume-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: volume-test

  template:
    metadata:
      labels:
        app: volume-test
    spec:
      containers:
      - name: volume-test
        image: busybox
        args:
        - "sleep"
        - "86400"
        volumeMounts:
        - name: volume-1
          mountPath: /root/test
      volumes:
      - name: volume-1
        persistentVolumeClaim:
          claimName: pvc-test-1     
```
