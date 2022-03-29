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

## Verify from "any" node
In contrast to KubeFed, KubeEdge comes with network capability out of the box.
```
kubectl get all -n=test1 -o wide
NAME                         READY   STATUS    RESTARTS   AGE    IP           NODE              NOMINATED NODE   READINESS GATES
pod/nginx1-996c49d8f-2b48b   1/1     Running   0          2m8s   172.17.0.3   edge-1            <none>           <none>
pod/nginx1-996c49d8f-mnnx5   1/1     Running   0          2m8s   10.42.0.8    kubeedge-master   <none>           <none>
pod/nginx1-996c49d8f-zgqg4   1/1     Running   0          2m8s   172.17.0.2   raspberrypi       <none>           <none>
pod/nginx1-996c49d8f-xxctp   1/1     Running   0          2m8s   172.17.0.2   edge-2            <none>           <none>

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/nginx1-svc   ClusterIP   10.43.7.255   <none>        8000/TCP   9s    app=nginx1

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES             SELECTOR
deployment.apps/nginx1   4/4     4            4           2m8s   nginx1       nginxdemos/hello   app=nginx1,version=v1
```
