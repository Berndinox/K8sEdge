#Install EdgeMesh

# Master
```
git clone https://github.com/kubeedge/edgemesh.git
cd edgemesh
kubectl apply -f build/crds/istio/
nano /etc/kubeedge/config/cloudcore.yaml
```
enable the controller
```
  dynamicController:
    enable: true
```
Restart the Service.
`pkill cloudcore ; nohup /usr/local/bin/cloudcore > /var/log/kubeedge/cloudcore.log 2>&1 &`

# On The Edge
enable edgeMesh and metaManager, also set DNS
`nano /etc/kubeedge/config/edgecore.yaml`
```
  ..
  edgeMesh:
    enable: false
  ..
  metaManager:
    metaServer:
      enable: true
  ..
  edged:
    clusterDNS: 169.254.96.16
    clusterDomain: cluster.local
```
Restart: `systemctl restart edgecore`
Verify: `curl 127.0.0.1:10550/api/v1/services`

## Master
deploy the agents
```
kubectl apply -f build/server/edgemesh/
kubectl apply -f build/agent/kubernetes/edgemesh-agent/
```
Verify: `kubectl get all -n kubeedge -o wide`