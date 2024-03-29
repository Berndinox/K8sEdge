Source: https://github.com/giantswarm/kube-stresscheck

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: kube-stresscheck-psp
rules:
  - apiGroups:
    - extensions
    resources:
    - podsecuritypolicies
    verbs:
    - use
    resourceNames:
    - kube-stresscheck-psp
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kube-stresscheck-psp
subjects:
  - kind: ServiceAccount
    name: kube-stresscheck
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: kube-stresscheck-psp
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-stresscheck
  namespace: kube-system
---
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: kube-stresscheck-psp
spec:
  allowPrivilegeEscalation: true
  fsGroup:
    rule: RunAsAny
  privileged: true
  runAsUser:
    rule: RunAsAny
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  volumes:
  - 'secret'
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: kube-stresscheck
  namespace: kube-system
  labels:
    app: kube-stresscheck
spec:
  selector:
    matchLabels:
      app: kube-stresscheck
  template:
    metadata:
      labels:
        app: kube-stresscheck
    spec:
      tolerations:
        # Allow the pod to run on the master.
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
      serviceAccount: kube-stresscheck
      securityContext:
        runAsUser: 0
      containers:
        - name: kube-stresscheck
          image: quay.io/giantswarm/kube-stresscheck:latest
```