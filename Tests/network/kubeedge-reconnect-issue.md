# KubeEdge broken
Afer connection restoring of edge-1 - remains NotReady

## Master:
kubectl get nodes
```
NAME              STATUS                        ROLES                  AGE    VERSION
edge-2            NotReady,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
edge-1            NotReady                      agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
raspberrypi       NotReady,SchedulingDisabled   agent,edge             3d5h   v1.22.6-kubeedge-v1.10.0
kubeedge-master   Ready                         control-plane,master   3d5h   v1.21.4+k3s1
```
Node not becoming ready!


## Edge-1 Node:

EdgeMesh Agent Docker logs:
```
W0402 17:33:41.546694       1 tunnel.go:34] Connect to server err: dial backoff
W0402 17:33:53.547971       1 tunnel.go:28] Connection between agent and server [/ip4/49.12.197.172/tcp/20004 /ip4/127.0.0.1/tcp/20004] is not established, try connect
I0402 17:33:53.548028       1 tunnel.go:31] Tunnel agent connecting to tunnel server
I0402 17:33:53.932483       1 tunnel.go:50] agent success connected to server [/ip4/49.12.197.172/tcp/20004 /ip4/127.0.0.1/tcp/20004
```
EdgeMesh seemd to be fine.

journalctl -u edgecore -b
```
Apr 02 17:37:17 edge-1 edgecore[583]: I0402 17:37:17.176567     583 communicate.go:82] Disconnected with cloud, not send msg to cloud
Apr 02 17:37:18 edge-1 edgecore[583]: E0402 17:37:18.566626     583 ws.go:77] dial websocket error(dial tcp 49.12.197.172:10000: connect: connection refused), response message:
Apr 02 17:37:18 edge-1 edgecore[583]: E0402 17:37:18.566671     583 websocket.go:90] Init websocket connection failed dial tcp 49.12.197.172:10000: connect: connection refused
Apr 02 17:37:20 edge-1 edgecore[583]: W0402 17:37:20.670742     583 context_channel.go:180] The module websocket message channel is full, message: {Header:{ID:183c3a0f-3c6f-40f7-ade9-2ec0b9f0e8dd ParentID: Timestamp:1648921040658 ResourceVersion: Sync:true MessageType:} Router:{Source:>
Apr 02 17:37:23 edge-1 edgecore[583]: E0402 17:37:23.660699     583 ws.go:77] dial websocket error(dial tcp 49.12.197.172:10000: connect: connection refused), response message:
Apr 02 17:37:23 edge-1 edgecore[583]: E0402 17:37:23.660738     583 websocket.go:90] Init websocket connection failed dial tcp 49.12.197.172:10000: connect: connection refused
```
This error is related to: https://github.com/kubeedge/beehive/blob/master/pkg/core/context/context_channel.go#L174

`systemctl restart edgecore` - does not change anything
ping to master and vice versa is possible. (Firewall removed successfully)

## Master:
cloudcore.log:
```
goroutine 290033 [IO wait, 2 minutes]:
internal/poll.runtime_pollWait(0x7f0cd18df910, 0x72, 0xffffffffffffffff)
        /usr/local/go/src/runtime/netpoll.go:227 +0x55
internal/poll.(*pollDesc).wait(0xc000524b18, 0x72, 0x7500, 0x75b6, 0xffffffffffffffff)
        /usr/local/go/src/internal/poll/fd_poll_runtime.go:87 +0x45
internal/poll.(*pollDesc).waitRead(...)
        /usr/local/go/src/internal/poll/fd_poll_runtime.go:92
internal/poll.(*FD).Read(0xc000524b00, 0xc000af8000, 0x75b6, 0x75b6, 0x0, 0x0, 0x0)
        /usr/local/go/src/internal/poll/fd_unix.go:166 +0x1d5
net.(*netFD).Read(0xc000524b00, 0xc000af8000, 0x75b6, 0x75b6, 0x52d6, 0x0, 0x0)
        /usr/local/go/src/net/fd_posix.go:55 +0x4f
net.(*conn).Read(0xc00032e148, 0xc000af8000, 0x75b6, 0x75b6, 0x0, 0x0, 0x0)
        /usr/local/go/src/net/net.go:183 +0x91
```
Even the ability to write clean logs is broken.

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



