# Web-Applicatio
distributed via KubeFed

## Master: enable ressource federation for the required kubernetes objects
```
kubefedctl enable deployments.apps --kubefed-namespace kube-federation-system
kubefedctl enable services --kubefed-namespace kube-federation-system
```

## Master: create namespace that will be federated
```
kubectl create ns test1
```
within this namespace create a federatedNamespace ressource
```
apiVersion: types.kubefed.io/v1beta1
kind: FederatedNamespace
metadata:
  name: test1
  namespace: test1
spec:
  placement:
    clusters:
    - name: default
    - name: edg1
    - name: edg2
    - name: edg3
```
## Edge-Nodes: verify
```
kubectl get ns
NAME                     STATUS   AGE
default                  Active   10d
kube-system              Active   10d
kube-public              Active   10d
kube-node-lease          Active   10d
kube-federation-system   Active   27m
test1                    Active   3s
```
"test1" appears
## Master: create deployment
```
apiVersion: types.kubefed.io/v1beta1
kind: FederatedDeployment
metadata:
  name: nginx1
  namespace: test1
spec:
  template:
    metadata:
      name: nginx1
    spec:
      replicas: 1
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
  placement:
    clusters:
    - name: default
    - name: edge1
    - name: edge2
    - name: edge3
  overrides:
    - clusterName: edge3
      clusterOverrides:
      - path: "/spec/replicas"
        value: 2
```
and the Service
```
apiVersion: types.kubefed.io/v1beta1
kind: FederatedService
metadata:
  name: nginx1-svc
  namespace: test1
spec:
  template:
    metadata:
      name: nginx1-svc
      labels:
        app: nginx1
    spec:
      ports:
      - name: http
        port: 8000
        targetPort: 80
      selector:
        app: nginx1
    clusters:
    - name: default
    - name: edge1
    - name: edge2
    - name: edge3
```
## Verify on the edge-nodes
```
root@kubefed:/home/pi# kubectl get all -n=test1
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx1-996c49d8f-2hg2k   1/1     Running   0          9m36s
pod/nginx1-996c49d8f-q6fdb   1/1     Running   0          74s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
service/nginx1-svc   ClusterIP   10.43.185.3   <none>        8000/TCP   6m25s

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx1   2/2     2            2           9m36s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx1-996c49d8f   2         2         2       9m36s
```
