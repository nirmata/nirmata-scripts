This script is used to cleanup Kyverno,Nirmata,Nirmata Cluster and its related resouces from the Kubernetes Cluster

<ins>**Usage:**</ins>
- Make sure you have `kubectl client`, `curl` and `jq` installed on the machine where you are running this script
- Make sure you have kubectl access to the cluster with kubeconfig file
- The script takes two arguments as inputs : `/kyverno_nirmata_cluster_cleanup.sh clustername Nirmata-API-Token Nirmata-URL namespace1 [namespace2 ...]`
	- `kubeconfig` : Absolute path of kubeconfig file for the cluster, example /home/user/.kube/config
	- clustername: Cluster name in Nirmata UI
	- Nirmata-API-Token: Token for accessing the Nirmata API
	- Nirmata-URL: URL of the Nirmata API
	- namespace1: Name of the first namespace to be cleaned up (e.g., 'kyverno')
	- namespace2...: Names of the additional namespaces to be cleaned up
        - `Example`: `./kyverno_nirmata_cluster_cleanup.sh kubeconfig_path test-cluster <Nirmata-API-Token> https://www.nirmata.io  nirmata-kyverno-operator kyverno nirmata`

