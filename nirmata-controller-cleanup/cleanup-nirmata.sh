#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 kubeconfig name"
    echo ""
    echo "* kubeconfig: Absolute path of kubeconfig file for the cluster"
    echo "* name: Name of the resource to be cleand up, in this case 'nirmata'"
    echo ""
    echo "Eg: $0 /home/user/.kube/config nirmata"
else
	echo "Cleaning up Nirmata from the cluster"
	echo ""
	kubeconfig=$1
	name=$2
    kubectl get deployment -n $name | grep -iv 'Name' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete deployment -n $name
    kubectl get svc -n $name | grep -iv 'Name' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete svc -n $name
    kubectl get ClusterRoleBinding -A | grep -i '^nirmata-' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete ClusterRoleBinding
    getns=$(kubectl get ns nirmata 2>&1)
    delns=$(echo $getns | grep NotFound)
    echo $getns | grep NotFound
    if echo $getns | grep NotFound &>null ; then
		echo "Nirmata and related resources are deleted from the cluster"
    else
        kubectl delete ns $2
        nsdel=$(echo $?)
        if [ $nsdel -eq 0 ]
        then
            echo "Nirmata and related resources are deleted from the cluster"
        else 
            echo "Issue in deleting Nirmata name space, retrying..."
            kubectl get namespace $name -o json | jq '.spec = {"finalizers":[]}' > tmp.json
            kubectl proxy &
            sleep 5
            curl -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://localhost:8001/api/v1/namespaces/$name/finalize
            pkill -9 -f "kubectl proxy"
            rm tmp.json
            timeout 5 kubectl delete ns $name
            echo "Deleted nirmata namespace successfully"
            kubectl get ns -A
        fi
    fi
fi
