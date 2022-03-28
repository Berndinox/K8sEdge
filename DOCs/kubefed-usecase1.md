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

