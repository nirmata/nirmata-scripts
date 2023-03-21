This script is used to cleanup Kyverno,Nirmata and its related resouces from the Kubernetes Cluster

<ins>**Usage:**</ins>
- Make sure you have `kubectl client`, `curl` and `jq` installed on the machine where you are running this script
- Make sure you have kubectl access to the cluster with kubeconfig file
- The script takes two arguments as inputs : `./cleanup-kyverno-nirmata.sh kubeconfig namespace1 namespace2 namespace3`
	- `kubeconfig` : Absolute path of kubeconfig file for the cluster, example /home/user/.kube/config
	- `name` : Name of the resource to be cleand up, in this case 'kyverno','nirmata-kyverno-operator' and 'nirmata'
        - `Example`: `./cleanup-kyverno-nirmata.sh kubeconfig  kyverno nirmata-kyverno-operator nirmata`

