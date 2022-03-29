# Web-Application
distributed via KubeEdge

## Master: create deployment
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx1
  namespace: test1
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx1
      version: v1
  template:
    metadata:
      labels:
        app: nginx1
        version: v1
    spec:
      containers:
      - image: nginxdemos/hello
        imagePullPolicy: IfNotPresent
        name: nginx1
        ports:
        - containerPort: 80
```
and the Service pointing to it
```
apiVersion: v1
kind: Service
metadata:
  name: nginx1-svc
  namespace: test1
  labels:
    app: nginx1
spec:
  ports:
  - name: http
    port: 8000
    targetPort: 80
  selector:
    app: nginx1
```
## deploy it:
kubectl create ns test1
kubectl apply -f deploy.yaml service.yaml
