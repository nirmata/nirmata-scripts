#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 kubeconfig name"
    echo ""
    echo "* kubeconfig: Absolute path of kubeconfig file for the cluster"
    echo "* name: Name of the resource to be cleand up, in this case 'kyverno'"
    echo ""
    echo "Eg: $0 /home/user/.kube/config kyverno"
else
	echo "Cleaning up Kyverno from the cluster"
	echo ""
	kubeconfig=$1
	name=$2
	kubectl --kubeconfig=$kubeconfig get crd | grep -i $2 | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete crd
	kubectl --kubeconfig=$kubeconfig get crd | grep -i wgpolicy | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete crd
	kubectl --kubeconfig=$kubeconfig get clusterrole | grep -i $2 | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete clusterrole
	kubectl --kubeconfig=$kubeconfig get clusterrolebinding | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete clusterrolebinding
	kubectl --kubeconfig=$kubeconfig get mutatingwebhookconfigurations | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete mutatingwebhookconfigurations
	kubectl --kubeconfig=$kubeconfig get validatingwebhookconfigurations | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete validatingwebhookconfigurations
	kubectl delete ns $2
	nsdel=$(echo $?)
	if [ $nsdel -eq 0 ]
	then
		echo "Kyverno and related resources are deleted from the cluster"
	else 
		echo "Issue in deleting kyverno name space, retrying..."
		kubectl get namespace $name -o json | jq '.spec = {"finalizers":[]}' > tmp.json
		kubectl proxy &
		sleep 5
		curl -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://localhost:8001/api/v1/namespaces/$name/finalize
		pkill -9 -f "kubectl proxy"
		rm tmp.json
		timeout 5 kubectl delete ns $name
		echo "Deleted kyverno namespace successfully"
		kubectl get ns -A
	fi
fi
