# Install
Install KubeEdge: https://kubeedge.io

## Master
```
# Update
apt-get update && apt-get upgrade -y
# Install K3s (Lighweiht K8s)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik --disable-cloud-controller" sh -s -
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
kubectl get nodes
# Install KubeEdge
wget https://github.com/kubeedge/kubeedge/releases/download/v1.9.1/keadm-v1.9.1-linux-amd64.tar.gz
tar xvf keadm-v1.9.1-linux-amd64.tar.gz
keadm init --advertise-address=49.12.197.172
netstat -tulpn
# Output
tcp6       0      0 :::10000                :::*                    LISTEN      19947/cloudcore
tcp6       0      0 :::10002                :::*                    LISTEN      19947/cloudcore
# Get Token to join
keadm gettoken
```
## Edge
```
# Get KudeEdge
wget https://github.com/kubeedge/kubeedge/releases/download/v1.9.1/keadm-v1.9.1-linux-amd64.tar.gz
tar xvf keadm-v1.9.1-linux-amd64.tar.gz
#Install Requirements: Docker
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update && apt-get install docker-ce
# Join Edge Node
keadm join --cloudcore-ipport=49.12.197.172:10000 --token=SUPERLONGTOKEN
# Verfiy
journalctl -u edgecore.service -b
```
## Master
```
kubectl get nodes
# Output
NAME              STATUS   ROLES                  AGE    VERSION
kubeedge-master   Ready    control-plane,master   114m   v1.21.7+k3s1
edge-1            Ready    agent,edge             2m9s   v1.19.3-kubeedge-v1.8.2
# Enable Logging
export CLOUDCOREIPS=49.12.197.172
cd /etc/kubeedge && wget https://raw.githubusercontent.com/kubeedge/kubeedge/master/build/tools/certgen.sh && chmod +x certgen.sh
mkdir /etc/kubernetes && mkdir /etc/kubernetes/pki/
cp /var/lib/rancher/k3s/server/tls/client-ca.crt /etc/kubernetes/pki/ca.crt
cp /var/lib/rancher/k3s/server/tls/client-ca.key /etc/kubernetes/pki/ca.key
certgen.sh stream
kubectl get cm tunnelport -nkubeedge -oyaml
# Port from above Output
iptables -t nat -A OUTPUT -p tcp --dport 10351 -j DNAT --to 49.12.197.172:10003
#Enable Log Stream
sudo nano /etc/kubeedge/config/cloudcore.yaml
# Modify to true
cloudStream:
  enable: true
#
pkill cloudcore
nohup cloudcore > cloudcore.log 2>&1 &
```

## Edge
```
# Enable Loging on Ede node
sudo nano /etc/kubeedge/config/edgecore.yaml
# Modify to true
  edgeStream:
    enable: true
#Restart
systemctl restart edgecore.service
```
# Connect (Admin)
on Master Node
```
cat /etc/rancher/k3s/k3s.yaml
```
Modify Server IP to the public facing IP
Add Skip-Verify: true (not recommend for production)

One nice Client is: Lens
![LENS-K8s-Client](https://raw.githubusercontent.com/Berndinox/K8sEdge/main/PICs/LensK8sClient.png)
