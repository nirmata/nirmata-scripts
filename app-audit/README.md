This script is used to perform application(pod) audit on all namespaces in a cluster. This gives details on below items 
- pod request limit
- pod current usage
- namespace resource usage
- check namespace resourcequota 
- check namespace limitrange


<ins>**Usage:**</ins>

Run the script from where we have kubectl access to the cluster.The The script only checks the pod with a `Running` status. The ouput gets added to the `appdetails.txt` file. The file gets created automatically by the script in the same directory where the script is present.

<ins>**Sample Output:**</ins>
```sh
devns Namespace Analytics
App #1
NAME      REQUEST_CPU   REQUEST_MEMORY   LIMIT_CPU   LIMIT_MEMORY
busybox   100m          64Mi             <none>      <none>
NAME      CPU(cores)   MEMORY(bytes)
busybox   0m           3Mi
+++++++++
App #2
NAME    REQUEST_CPU   REQUEST_MEMORY   LIMIT_CPU   LIMIT_MEMORY
nginx   250m          125Mi            <none>      <none>
NAME    CPU(cores)   MEMORY(bytes)
nginx   0m           3Mi
+++++++++
Current NS CPU Usage: 0
Current NS MEM Usage: 6
Resource quota Enabled for devns
NAME   AGE   REQUEST                            LIMIT
c1m5   23m   cpu: 350m/1, memory: 189Mi/500Mi
Limit Range Enabled for devns
NAME   CREATED AT
c1m5   2023-01-06T11:06:30Z
```

The output give details on the basis of each namespace where we have pod details with a number `App #` and other dwetails of pod and namespace.


