
netstat -tulpn
```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:10350         0.0.0.0:*               LISTEN      583/edgecore
tcp        0      0 127.0.0.1:34547         0.0.0.0:*               LISTEN      583/edgecore
tcp        0      0 169.254.96.16:53        0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      537/systemd-resolve
tcp        0      0 127.0.0.1:10550         0.0.0.0:*               LISTEN      583/edgecore
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      635/sshd: /usr/sbin
tcp        0      0 169.254.96.16:36057     0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 169.254.96.16:46043     0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 0.0.0.0:1883            0.0.0.0:*               LISTEN      589/mosquitto
tcp        0      0 169.254.96.16:33311     0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 169.254.96.16:45381     0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 0.0.0.0:20006           0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp        0      0 169.254.96.16:39049     0.0.0.0:*               LISTEN      1281/edgemesh-agent
tcp6       0      0 :::22                   :::*                    LISTEN      635/sshd: /usr/sbin
tcp6       0      0 :::1883                 :::*                    LISTEN      589/mosquitto
udp        0      0 169.254.96.16:55222     0.0.0.0:*                           1281/edgemesh-agent
udp        0      0 169.254.96.16:53        0.0.0.0:*                           1281/edgemesh-agent
udp        0      0 127.0.0.53:53           0.0.0.0:*                           537/systemd-resolve
udp        0      0 5.161.41.112:68         0.0.0.0:*                           535/systemd-network
```