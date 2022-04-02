# Curl
##measure repsonse time

curl-output.txt
```
     time_namelookup:  %{time_namelookup}s\n
        time_connect:  %{time_connect}s\n
     time_appconnect:  %{time_appconnect}s\n
    time_pretransfer:  %{time_pretransfer}s\n
       time_redirect:  %{time_redirect}s\n
  time_starttransfer:  %{time_starttransfer}s\n
                     ----------\n
          time_total:  %{time_total}s\n
```

Command used:
```
curl -w "@curl-output.txt" -o /dev/null -s CLUSTERIP:8000
```

Example Output:
```
     time_namelookup:  0.000070s
        time_connect:  0.000245s
     time_appconnect:  0.000000s
    time_pretransfer:  0.000316s
       time_redirect:  0.000000s
  time_starttransfer:  0.338320s
                     ----------
          time_total:  0.338480
```