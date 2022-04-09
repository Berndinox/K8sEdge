# K3s security check
The following tests are based on the tests performed in the falco scan, however they are modified to fit the K3s environment.


### Permission:
```
/bin/sh -c 'if test -e /var/lib/rancher/k3s/server/cred/admin.kubeconfig; then stat -c %U:%G /var/lib/rancher/k3s/server/cred/admin.kubeconfig; fi'
Return: root:root
```
```
/bin/sh -c 'if test -e scheduler; then stat -c permissions=%a scheduler; fi'
Return: nothing
```
```
/bin/sh -c 'if test -e scheduler; then stat -c %U:%G scheduler; fi'
Return: nothing
```
```
/bin/sh -c 'if test -e controllermanager; then stat -c permissions=%a controllermanager; fi'
Return: nothing
```
```
stat -c %U:%G /var/lib/rancher/k3s/server/tls
Return: root:root
```
```
stat -c %a /var/lib/rancher/k3s/agent/kubeproxy.kubeconfig
Return: 644
```
```
stat -c %U:%G /var/lib/rancher/k3s/agent/kubeproxy.kubeconfig
root:root
```

### API:
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-apiserver' | tail -n1 | grep 'anonymous-auth'
Return: --anonymous-auth=false 
```
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-apiserver' | tail -n1 | grep 'authorization-mode'
Return: --authorization-mode=Node,RBAC 
```
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-apiserver' | tail -n1 | grep 'enable-admission-plugins'
Return: --enable-admission-plugins=NodeRestriction 
```
Solution: `--kube-apiserver-arg="enable-admission-plugins=NodeRestriction,PodSecurityPolicy,ServiceAccount`
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-apiserver' | tail -n1 | grep 'insecure-bind-address'
Return: nothing
```
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-controller-manager' | tail -n1 | grep 'bind-address'
Return: --bind-address=127.0.0.1 
```

### Scheduler:
```
journalctl -D /var/log/journal -u k3s | grep 'Running kube-scheduler' | tail -n1 | grep 'bind-address'
Return:  --bind-address=127.0.0.1
```

### PSP:
```
kubectl get psp -o json | jq .items[] | jq -r 'select((.spec.hostPID == null) or (.spec.hostPID == false))' | jq .metadata.name | wc -l | xargs -I {} echo '--count={}'
kubectl get psp -o json | jq .items[] | jq -r 'select((.spec.hostIPC == null) or (.spec.hostIPC == false))' | jq .metadata.name | wc -l | xargs -I {} echo '--count={}'
kubectl get psp -o json | jq .items[] | jq -r 'select((.spec.hostNetwork == null) or (.spec.hostNetwork == false))' | jq .metadata.name | wc -l | xargs -I {} echo '--count={}'
```
Should all return: `--count=1`
is not the case because of PSP beeing not installed per default.
