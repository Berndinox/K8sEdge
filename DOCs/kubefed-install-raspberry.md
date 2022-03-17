# Raspberry Pi4 Install

```
# Update & Prerequisites
apt-get update && apt-get upgrade -y
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --disable-cloud-controller" sh -s -
# Fix weired config location of k3s
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
#Tweak Cgroup
nano /boot/cmdline.txt
## ADD
  cgroup_enable=memory
#
init 6
```

## Kubeconfig
```
cat /etc/rancher/k3s/k3s.yaml
# Replace IP with DynDNS
server: https://127.0.0.1:6443
# Also Cert check needs to be removed (Optional Cert recreatin)
insecure-skip-tls-verify: true
# Remove certificate-authority-data:
```
