# Raspberry Pi4 Install

```
# Update & Prerequisites
apt-get update && apt-get upgrade -y
apt install apt-transport-https ca-certificates curl software-properties-common -y
# Get Keadm
wget https://github.com/kubeedge/kubeedge/releases/download/v1.9.1/keadm-v1.9.1-linux-arm.tar.gz
tar xvf keadm-v1.9.1-linux-arm.tar.gz
# Install Docker
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo systemctl enable docker
#Tweak Cgroup
nano /boot/cmdline.txt
## ADD
  cgroup_enable=memory
#
init 6
```

## Initialize KubeEdge
```
keadm join --cloudcore-ipport=49.12.197.172:10000 --token=SUPERLONGTOKEN
# Verfiy
journalctl -u edgecore.service -b
```
