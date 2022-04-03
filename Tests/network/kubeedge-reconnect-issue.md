# KubeEdge broken
Afer connection restoring of edge-1 (30 Minutes offline)
all Nodes remain NotReady

## Master:
kubectl get nodes
```
NAME              STATUS                        ROLES                  AGE    VERSION
edge-2            NotReady,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
edge-1            NotReady                      agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
raspberrypi       NotReady,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
kubeedge-master   Ready                         control-plane,master   3d5h   v1.21.4+k3s1
```


## Edge-1 Node:

EdgeMesh Agent Docker logs:
```
W0402 17:33:41.546694       1 tunnel.go:34] Connect to server err: dial backoff
W0402 17:33:53.547971       1 tunnel.go:28] Connection between agent and server [/ip4/49.12.197.172/tcp/20004 /ip4/127.0.0.1/tcp/20004] is not established, try connect
I0402 17:33:53.548028       1 tunnel.go:31] Tunnel agent connecting to tunnel server
I0402 17:33:53.932483       1 tunnel.go:50] agent success connected to server [/ip4/49.12.197.172/tcp/20004 /ip4/127.0.0.1/tcp/20004
```
EdgeMesh seems to be fine.

journalctl -u edgecore -b
```
Apr 02 17:37:17 edge-1 edgecore[583]: I0402 17:37:17.176567     583 communicate.go:82] Disconnected with cloud, not send msg to cloud
Apr 02 17:37:18 edge-1 edgecore[583]: E0402 17:37:18.566626     583 ws.go:77] dial websocket error(dial tcp 49.12.197.172:10000: connect: connection refused), response message:
Apr 02 17:37:18 edge-1 edgecore[583]: E0402 17:37:18.566671     583 websocket.go:90] Init websocket connection failed dial tcp 49.12.197.172:10000: connect: connection refused
Apr 02 17:37:20 edge-1 edgecore[583]: W0402 17:37:20.670742     583 context_channel.go:180] The module websocket message channel is full, message: {Header:{ID:183c3a0f-3c6f-40f7-ade9-2ec0b9f0e8dd ParentID: Timestamp:1648921040658 ResourceVersion: Sync:true MessageType:} Router:{Source:>
Apr 02 17:37:23 edge-1 edgecore[583]: E0402 17:37:23.660699     583 ws.go:77] dial websocket error(dial tcp 49.12.197.172:10000: connect: connection refused), response message:
Apr 02 17:37:23 edge-1 edgecore[583]: E0402 17:37:23.660738     583 websocket.go:90] Init websocket connection failed dial tcp 49.12.197.172:10000: connect: connection refused
```
This error is related to:

https://github.com/kubeedge/beehive/blob/master/pkg/core/context/context_channel.go#L174
https://github.com/kubeedge/kubeedge/commit/6f212c9bd227c0335b54051d587fc3c73aabfb92#diff-55957eb2fde5f07479933dfb3485861b6e5f655c25efd502e95d1cd79f3efa10


`systemctl restart edgecore` - does not change anything
ping to master and vice versa is possible. (Firewall removed successfully)

## Master:
cloudcore.log
```
I0403 07:06:20.842982    3200 application.go:413] [metaserver/ApplicationCenter] get a Application (NodeName=edge-1;Key=/networking.istio.io/v1alpha3/destinationrules/null/null;Verb=watch;Status=InApplying;Reason=)
I0403 07:06:20.843130    3200 application.go:422] [metaserver/applicationCenter]successfully to process Application((NodeName=edge-1;Key=/networking.istio.io/v1alpha3/destinationrules/null/null;Verb=watch;Status=Approved;Reason=))
W0403 07:06:42.353806    3200 messagehandler.go:216] Timeout to receive heart beat from edge node edge-1 for project e632aba927ea4ac2b575ec1603d56f10
E0403 07:06:42.354037    3200 ws.go:122] failed to read message, error: read tcp 49.12.197.172:10000->5.161.41.112:35528: use of closed network connection
I0403 07:06:42.858667    3200 application.go:413] [metaserver/ApplicationCenter] get a Application (NodeName=edge-2;Key=/core/v1/secrets/null/null;Verb=watch;Status=InApplying;Reason=)
I0403 07:06:42.859306    3200 application.go:422] [metaserver/applicationCenter]successfully to process Application((NodeName=edge-2;Key=/core/v1/secrets/null/null;Verb=watch;Status=Approved;Reason=))
E0403 07:06:44.261679    3200 messagehandler.go:471] Failed to send event to node: edge-1, affected event: id: f78fb2da-74c4-45e9-b47f-a661fb18e94e, parent_id: , group: resource, source: dynamiccontroller, resource: kube-system/endpoints/rancher.io-local-path, operation: update, err: use of closed network connection
```

Restart the KubeEdge core component:

`pkill cloudcore & nohup cloudcore > cloudcore.log 2>&1 &`

kubectl get nodes
```
NAME              STATUS                     ROLES                  AGE    VERSION
kubeedge-master   Ready                      control-plane,master   3d5h   v1.21.4+k3s1
edge-2            Ready,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
edge-1            Ready                      agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
raspberrypi       Ready,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
```

The problem was already reported in Jan:
https://github.com/kubeedge/kubeedge/issues/3567



