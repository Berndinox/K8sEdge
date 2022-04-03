# KubeFed scale 100

`watch -n 2 'echo $(echo -n $(kubectl get pods -n=test1 | grep "Pending" | wc -l) && echo -n "/" && echo $( kubectl get pods -n=test1 | grep "Running" | wc -l)) | ts >> running.log'`

### Results
Month Day Hour:Minute:Second Pending-Pods/Running-Pods

Edge-1
```
Apr 03 15:19:55 0/0
Apr 03 15:19:58 30/0
Apr 03 15:20:01 30/0
Apr 03 15:20:04 27/0
Apr 03 15:20:06 21/0
Apr 03 15:20:09 18/6
Apr 03 15:20:11 14/12
Apr 03 15:20:14 12/18
Apr 03 15:20:16 7/25
Apr 03 15:20:19 3/31
Apr 03 15:20:21 0/33
```

Edge-2
```
Apr 03 15:19:54 0/0
Apr 03 15:19:58 8/0
Apr 03 15:20:14 32/0
Apr 03 15:20:18 29/0
Apr 03 15:20:22 17/1
Apr 03 15:20:25 9/1
Apr 03 15:20:29 2/1
Apr 03 15:20:32 0/9
Apr 03 15:20:36 0/19
Apr 03 15:20:40 0/28
Apr 03 15:20:44 0/34
```

Edge-3 (RPI)
```
Apr 03 17:19:56 0/0
Apr 03 17:20:07 31/0
Apr 03 17:20:16 28/0
Apr 03 17:20:21 10/0
Apr 03 17:20:26 4/11
Apr 03 17:20:32 2/25
Apr 03 17:20:37 0/33
```
