# Install
Install KubeFed: https://github.com/kubernetes-sigs/kubefed

## Master
```
# Update
apt-get update && apt-get upgrade -y
# Install K3s (Lighweiht K8s)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --disable-cloud-controller" sh -s -
```
Connect using Lens and/or kubectl & install KubeFed
```
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --version=0.9.1 --create-namespace
```
Install KubeFedCTL
```
wget https://github.com/kubernetes-sigs/kubefed/releases/download/v0.9.1/kubefedctl-0.9.1-linux-amd64.tgz
tar xvf kubefedctl-0.9.1-linux-amd64.tgz
cp kubefedctl /usr/bin/
kubefedctl version
  kubefedctl version: version.Info{Version:"v0.9.0-7-g90dd17b10", GitCommit:"90dd17b108e80fa6b1fe49366a1daf5f650bb807", GitTreeState:"clean", BuildDate:"2022-02-15T10:38:17Z",   GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}
```
Fix KubeConfig
```
mkdir /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
export KUBECONFIG=/root/.kube/config
# add also to /etc/profile
```

## Edge 1-N
```
# Update
apt-get update && apt-get upgrade -y
# Install K3s (Lighweiht K8s)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --disable-cloud-controller" sh -s -
# The Kubeconfig of edge locations must be added as additional context to the Master.
cat /etc/rancher/k3s/k3s.yaml
# Fix weired config location of k3s
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
export KUBECONFIG=/root/.kube/config
# add also to /etc/profile
```

## Master
Follow: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
To add the Edge 1 KubeConfig to .kube/config.


Join Clusters to KubeFed
```
# Join Edge1 with Context Edge1 to the Host (Master) default.
kubefedctl join edge1 --cluster-context edge1 --host-cluster-context default --v=2
```


## Verify
```
root@kubefed-master:~# kubectl -n kube-federation-system get kubefedclusters
NAME    AGE   READY
edge2   4s    True
edge1   15m   True
```
