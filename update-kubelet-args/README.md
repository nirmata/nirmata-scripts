

This script is used to update the kubelet arguments of Nirmata managed cluster in Nirmata

<ins>**Prerequisites:**</ins>

- Make sure `curl` and `jq` are installed on the machine where you are running this script

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