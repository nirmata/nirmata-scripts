

This script is used to update the kubelet arguments that are needed for docker to container migration. 

<ins>**Prerequisites:**</ins>

- Make sure `curl` is installed on the machine where you are running this script

<ins>**Usage:**</ins>

Execute the script with the required arguments and provide the Nirmata API token for your tenant. 

Required Arguments:
```sh
$1 - cluster name
$2 - Nirmata URL
```

```sh

 $ ./update-kubelet-args.sh cluster-containerd-rhel https://nirmata.io

Enter the Nirmata API token:

Kubelet arguments updated successfully


```
