This script is used to get resourceQuota (Used and limit) information for all environments in a tenant that have resourceQuota defined. 

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

Required Arguments:
```sh
$1 - Nirmata URL
```

```sh

root@ip-172-31-81-194:~# ./script.sh https://nirmata.io

Enter the Nirmata API token:

------------------------------------------------------------------------------------------------------------------------
ENV_NAME                                 CLUSTER_NAME                   CPU_LIMIT  CPU_USED   MEMORY_LIMIT    MEMORY_USED
------------------------------------------------------------------------------------------------------------------------
demo-env-new                             demo-cluster                   4          500m       8Gi             512Mi
sada                                     demo-cluster                   4          0          8Gi             0
helm-demo                                demo-cluster                   4          0          8Gi             0
environment-1                            demo-cluster                   8          750m       16Gi            768Mi
------------------------------------------------------------------------------------------------------------------------


```
