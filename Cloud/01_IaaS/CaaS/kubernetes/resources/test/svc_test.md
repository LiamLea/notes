```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: svc-test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: svc-test

  template:
    metadata:
      labels:
        app: svc-test
    spec:
      containers:
      - name: svc-test
        image: nicolaka/netshoot
        args:
        - "sleep"
        - "86400"
        
---     

apiVersion: v1
kind: Service
metadata:
  labels:
    app: svc-test
  name: svc-test-hl
spec:
  clusterIP: None
  ports:
  - name: app
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: svc-test
  type: ClusterIP
```