

This script is used to add the new arguments to kubelet in a Nirmata managed cluster in Nirmata. The script cannot be used to update the existing the kubelet arguments. 

<ins>**Prerequisites:**</ins>

- Make sure `curl` is installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

Required Arguments:
```sh
$1 - cluster name
$2 - Nirmata URL
$3 - Kubelet argument to add
```

```sh

 $ ./update-kubelet-args.sh cluster-containerd-rhel https://nirmata.io --cgroup-driver=systemd

Enter the Nirmata API token:

Kubelet arguments updated successfully


```
