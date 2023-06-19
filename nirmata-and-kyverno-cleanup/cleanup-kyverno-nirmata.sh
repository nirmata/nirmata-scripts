#!/bin/bash

if [ $# -lt 4 ]; then
    echo "Usage: $0 kubeconfig namespace1 namespace2 namespace3"
    echo ""
    echo "* kubeconfig: Absolute path of kubeconfig file for the cluster"
    echo "* name: name of the resource to be cleaned up, in this case 'kyverno','nirmata-kyverno-operator' and 'nirmata'"
    echo ""
    echo "Eg: $0 /home/user/.kube/config kyverno nirmata-kyverno-operator nirmata"
else
	echo "Cleaning up Kyverno from the cluster"
	echo ""
	kubeconfig=$1
	namespace1=$2
	namespace2=$3
	namespace3=$4
	kubectl --kubeconfig=$kubeconfig delete cpol --all
	kubectl --kubeconfig=$kubeconfig get crd | grep -i $2 | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete crd
	kubectl --kubeconfig=$kubeconfig get crd | grep -i wgpolicy | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete crd
	kubectl --kubeconfig=$kubeconfig get clusterrole | grep -i $2 | awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete clusterrole
	kubectl --kubeconfig=$kubeconfig get clusterrolebinding | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete clusterrolebinding
	kubectl --kubeconfig=$kubeconfig get mutatingwebhookconfigurations | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete mutatingwebhookconfigurations
	kubectl --kubeconfig=$kubeconfig get validatingwebhookconfigurations | grep -i $2 |  awk {'print $1'} | xargs kubectl --kubeconfig=$kubeconfig delete validatingwebhookconfigurations
	nsdel=$(echo $?)
	kubectl delete ns $2 $3
	kubectl get deployment -n $namespace3 | grep -iv 'Name' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete deployment -n $namespace3
    kubectl get svc -n $namespace3 | grep -iv 'Name' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete svc -n $namespace3
    kubectl get ClusterRoleBinding -A | grep -i '^nirmata-' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete ClusterRoleBinding
	kubectl get ClusterRoleBinding -A | grep -i '^nirmata:' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete ClusterRoleBinding
	kubectl get ClusterRole -A | grep -i '^nirmata-' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete ClusterRole
	kubectl get ClusterRole -A | grep -i '^nirmata:' | awk '{print $1}' | xargs kubectl --kubeconfig=$kubeconfig delete ClusterRole
    getns=$(kubectl get ns nirmata 2>&1)
    delns=$(echo $getns | grep NotFound)
    echo $getns | grep NotFound
    kubectl delete ns $4 
	kubectl get secret -A | grep helm |  awk {'print $2'} | xargs kubectl  delete secret
	nsdl=$(echo $?)
	if [ $nsdel -eq 0 ]
	then
		echo "Kyverno and nirmata related resources are deleted from the cluster"
	else 
		echo "Issue in deleting kyverno namespace space, retrying..."
		kubectl get namespace $namespace -o json | jq '.spec = {"finalizers":[]}' > tmp.json
		kubectl proxy &
		sleep 5
		curl -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://localhost:8001/api/v1/namespaces/$namespace/finalize
		pkill -9 -f "kubectl proxy"
		rm tmp.json
		timeout 5 kubectl delete ns $namespace 
		echo "Deleted kyverno namespace successfully"
		kubectl get namespace $namespace2 -o json | jq '.spec = {"finalizers":[]}' > tmp.json
		kubectl proxy &
		sleep 5
		curl -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://localhost:8001/api/v1/namespaces/$namespace2/finalize
		pkill -9 -f "kubectl proxy"
		rm tmp.json
		timeout 5 kubectl delete ns $namespace2
		echo "Deleted nirmata-kyverno-controller namespace successfully"
		echo "Issue in deleting Nirmata name space, retrying..."
        kubectl get namespace $namespace3 -o json | jq '.spec = {"finalizers":[]}' > tmp.json
        kubectl proxy &
        sleep 5
        curl -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://localhost:8001/api/v1/namespaces/$name/finalize
        pkill -9 -f "kubectl proxy"
        rm tmp.json
        timeout 5 kubectl delete ns $namespace3
        echo "Deleted nirmata namespace successfully"
        kubectl get ns -A
	
    fi
fi


