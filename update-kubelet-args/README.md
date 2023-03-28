

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

<ins>**Note:**</ins> 

The resources in Nirmata are created by appending a string "ea1qa" to the namespace. This can be updated in the script if needed. 

```sh

  ./update-cgroupfs.sh cluster-containerd-rhel https://nirmata.io

Enter the Nirmata API token:

Kubelet arguments updated successfully



```
