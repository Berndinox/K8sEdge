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
    - name: edg1
    - name: edg2
    - name: edg3
  overrides:
    - clusterName: default
      clusterOverrides:
      - path: "/spec/replicas"
        value: 2
```
