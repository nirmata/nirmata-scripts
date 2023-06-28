 #!/bin/bash

if [ $# -lt 5 ]; then
    echo "Usage: $0 kubeconfig clustername Nirmata-API-Token Nirmata-URL namespace1 [namespace2 ...]"
    echo ""
    echo "* kubeconfig: Absolute path of kubeconfig file for the cluster"
    echo "* clustername: Cluster name in Nirmata UI"
    echo "* Nirmata-API-Token: Token for accessing the Nirmata API"
    echo "* Nirmata-URL: URL of the Nirmata API"
    echo "* namespace1: Name of the first namespace to be cleaned up (e.g., 'kyverno')"
    echo "* namespace2...: Names of the additional namespaces to be cleaned up"
    echo ""
    echo "Eg: $0 /home/user/.kube/config test-cluster <Nirmata-API-Token> https://www.nirmata.io  nirmata-kyverno-operator kyverno nirmata"
    echo "Warning"
else
    kubeconfig=$1
    clustername=$2
    token=$3
    NIRMATAURL=$4
    shift 4
    namespaces=("$@")

    echo "Cleaning up Kyverno from the cluster"
    echo "==================================================="

    for namespace in "${namespaces[@]}"; do
        echo "Deleting resources in namespace: $namespace"

    echo "==================================================="
        # Delete cpol resources
        echo "Deleting cpol resources"
        if kubectl --kubeconfig="$kubeconfig" get clusterpolicy -n "$namespace" >/dev/null 2>&1; then
            kubectl --kubeconfig="$kubeconfig" delete clusterpolicy --all -n "$namespace"
            echo "Deleted cpol resources in namespace '$namespace'"
        else
            echo "Skipping cpol deletion. No cpol resources found in namespace '$namespace'."
        fi
        echo "Remaining cpol resources:"
        kubectl --kubeconfig="$kubeconfig" get clusterpolicy -n "$namespace" -o name || echo "No resources found."
    echo "==================================================="


        # Delete CustomResourceDefinitions 
        echo "Deleting CustomResourceDefinitions"
        crds=$(kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "$namespace")
        echo "$crds" | xargs -I {} kubectl --kubeconfig="$kubeconfig" patch  {} -p '{"metadata":{"finalizers":[]}}' --type=merge
        retries=0
        while [[ -n $crds && $retries -lt 3 ]]; do

            echo "$crds" | xargs kubectl --kubeconfig="$kubeconfig" delete
            sleep 5
            crds=$(kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "$namespace")
            ((retries++))
        done
        if [[ -n $crds ]]; then
            echo "Failed to delete CustomResourceDefinitions in namespace '$namespace'."
            exit 1
        fi
        echo "Remaining CustomResourceDefinitions:"
        kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "$namespace" || echo "No resources found."

    echo "==================================================="

        # Delete wgpolicy CustomResourceDefinitions 
        echo "Deleting wgpolicy CustomResourceDefinitions"
        crds=$(kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "wgpolicy")
        echo "$crds" | xargs -I {} kubectl --kubeconfig="$kubeconfig" patch {} -p '{"metadata":{"finalizers":[]}}' --type=merge
        retries=0
        while [[ -n $crds && $retries -lt 3 ]]; do

            echo "$crds" | xargs kubectl --kubeconfig="$kubeconfig" delete
            sleep 5
            crds=$(kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "wgpolicy")
            ((retries++))
        done
        if [[ -n $crds ]]; then
            echo "Failed to delete CustomResourceDefinitions in namespace 'wgpolicy'."
            exit 1
        fi
        echo "Remaining CustomResourceDefinitions:"
        kubectl --kubeconfig="$kubeconfig" get customresourcedefinition -o name | grep -i "wgpolicy" || echo "No resources found."

    echo "==================================================="


        # Delete ClusterRoles
        echo "Deleting ClusterRoles"
        cluster_roles=$(kubectl --kubeconfig="$kubeconfig" get clusterrole -o name | grep -i "$namespace")
        if [[ -n $cluster_roles ]]; then
            echo "ClusterRoles found. Deleting..."
            echo "$cluster_roles" | xargs kubectl --kubeconfig="$kubeconfig" delete
        else
            echo "Skipping ClusterRole deletion. No ClusterRoles found in namespace '$namespace'."
        fi
        echo "Remaining ClusterRoles:"
        kubectl --kubeconfig="$kubeconfig" get clusterrole -o name | grep -i "$namespace" || echo "No resources found."

    echo "==================================================="

        # Delete ClusterRoleBindings
        echo "Deleting ClusterRoleBindings"
        cluster_role_bindings=$(kubectl --kubeconfig="$kubeconfig" get clusterrolebinding -o name | grep -i "$namespace")
        if [[ -n $cluster_role_bindings ]]; then
            echo "ClusterRoleBindings found. Deleting..."
            echo "$cluster_role_bindings" | xargs kubectl --kubeconfig="$kubeconfig" delete
        else
            echo "Skipping ClusterRoleBinding deletion. No ClusterRoleBindings found in namespace '$namespace'."
        fi
        echo "Remaining ClusterRoleBindings:"
        kubectl --kubeconfig="$kubeconfig" get clusterrolebinding -o name | grep -i "$namespace" || echo "No resources found."

    echo "==================================================="

        # Delete MutatingWebhookConfigurations
        echo "Deleting MutatingWebhookConfigurations"
        mutating_webhook_configs=$(kubectl --kubeconfig="$kubeconfig" get mutatingwebhookconfiguration -o name | grep -i "$namespace")
        if [[ -n $mutating_webhook_configs ]]; then
            echo "MutatingWebhookConfigurations found. Deleting..."
            echo "$mutating_webhook_configs" | xargs kubectl --kubeconfig="$kubeconfig" delete
        else
            echo "Skipping MutatingWebhookConfiguration deletion. No MutatingWebhookConfigurations found in namespace '$namespace'."
        fi
        echo "Remaining MutatingWebhookConfigurations:"
        kubectl --kubeconfig="$kubeconfig" get mutatingwebhookconfiguration -o name | grep -i "$namespace" || echo "No resources found."

    echo "==================================================="

        # Delete ValidatingWebhookConfigurations
        echo "Deleting ValidatingWebhookConfigurations"
        validating_webhook_configs=$(kubectl --kubeconfig="$kubeconfig" get validatingwebhookconfiguration -o name | grep -i "$namespace")
        if [[ -n $validating_webhook_configs ]]; then
            echo "ValidatingWebhookConfigurations found. Deleting..."
            echo "$validating_webhook_configs" | xargs kubectl --kubeconfig="$kubeconfig" delete
        else
            echo "Skipping ValidatingWebhookConfiguration deletion. No ValidatingWebhookConfigurations found in namespace '$namespace'."
        fi
        echo "Remaining ValidatingWebhookConfigurations:"
        kubectl --kubeconfig="$kubeconfig" get validatingwebhookconfiguration -o name | grep -i "$namespace" || echo "No resources found."

    echo "==================================================="

        # Delete StatefulSets
        echo "Deleting StatefulSets"
        statefulsets=$(kubectl --kubeconfig="$kubeconfig" get statefulset -n "$namespace" -o name)
        if [[ -n $statefulsets ]]; then
            echo "$statefulsets" | xargs kubectl --kubeconfig="$kubeconfig" delete -n "$namespace"
            echo "Deleted StatefulSets in namespace '$namespace'"
        else
            echo "Skipping StatefulSet deletion. No StatefulSets found in namespace '$namespace'."
        fi
        echo "Remaining StatefulSets:"
        kubectl --kubeconfig="$kubeconfig" get statefulset -n "$namespace" -o name || echo "No resources found."

    echo "==================================================="

        # Delete DaemonSets
        echo "Deleting DaemonSets"
        daemonsets=$(kubectl --kubeconfig="$kubeconfig" get daemonset -n "$namespace" -o name)
        if [[ -n $daemonsets ]]; then
            echo "$daemonsets" | xargs kubectl --kubeconfig="$kubeconfig" delete -n "$namespace"
            echo "Deleted DaemonSets in namespace '$namespace'"
        else
            echo "Skipping DaemonSet deletion. No DaemonSets found in namespace '$namespace'."
        fi
        echo "Remaining DaemonSets:"
        kubectl --kubeconfig="$kubeconfig" get daemonset -n "$namespace" -o name || echo "No resources found."

    echo "==================================================="

        # Delete Deployments
        echo "Deleting Deployments"
        deployments=$(kubectl --kubeconfig="$kubeconfig" get deployment -n "$namespace" -o name)
        if [[ -n $deployments ]]; then
            echo "$deployments" | xargs kubectl --kubeconfig="$kubeconfig" delete -n "$namespace"
            echo "Deleted Deployments in namespace '$namespace'"
        else
            echo "Skipping Deployment deletion. No Deployments found in namespace '$namespace'."
        fi
        echo "Remaining Deployments:"
        kubectl --kubeconfig="$kubeconfig" get deployment -n "$namespace" -o name || echo "No resources found."

    echo "==================================================="

        # Delete Services
        echo "Deleting Services"
        services=$(kubectl --kubeconfig="$kubeconfig" get service -n "$namespace" -o name)
        if [[ -n $services ]]; then
            echo "$services" | xargs kubectl --kubeconfig="$kubeconfig" delete -n "$namespace"
            echo "Deleted Services in namespace '$namespace'"
        else
            echo "Skipping Service deletion. No Services found in namespace '$namespace'."
        fi
        echo "Remaining Services:"
        kubectl --kubeconfig="$kubeconfig" get service -n "$namespace" -o name || echo "No resources found."

    echo "==================================================="

        # Delete Pods
        echo "Deleting Pods"
        pods=$(kubectl --kubeconfig="$kubeconfig" get pod -n "$namespace" -o name)
        if [[ -n $pods ]]; then
            echo "$pods" | xargs kubectl --kubeconfig="$kubeconfig" delete -n "$namespace"
            echo "Deleted Pods in namespace '$namespace'"
        else
            echo "Skipping Pod deletion. No Pods found in namespace '$namespace'."
        fi
        echo "Remaining Pods:"
        kubectl --kubeconfig="$kubeconfig" get pod -n "$namespace" -o name || echo "No resources found."

    echo "==================================================="


        # Wait for resources to be deleted
        while kubectl --kubeconfig="$kubeconfig" get pod -n "$namespace" 2>&1 | grep Terminating; do
            sleep 5
        done

    echo "==================================================="


        # Delete the namespace
        echo "Deleting namespace: $namespace"

    echo "==================================================="


        # Check if namespace exists
        namespace_exists=$(kubectl --kubeconfig="$kubeconfig" get namespace "$namespace" -o name 2>/dev/null)
        echo $namespace_exists
        if [[ -z $namespace_exists ]]; then
            echo "Namespace '$namespace' does not exist on the cluster. Skipping deletion."
        else

    echo "==================================================="

            # Remove finalizers from the namespace
            # kubectl --kubeconfig="$kubeconfig" delete ns "$namespace" --wait=true 2>/dev/null
            kubectl --kubeconfig="$kubeconfig" patch namespace "$namespace" -p '{"spec":{"finalizers": []}}' --type=merge

            # Retry deletion if namespace still exists
            retries=3
            while [[ $retries -gt 0 ]]; do
                # Delete the namespace
                kubectl --kubeconfig="$kubeconfig" delete ns "$namespace" --wait=true 2>/dev/null

                # Check if namespace still exists
                namespace_status=$(kubectl --kubeconfig="$kubeconfig" get namespace "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null)
                if [[ -z $namespace_status ]]; then
                    echo "Namespace '$namespace' deleted successfully"
                    break
                fi

                retries=$((retries-1))
                echo "Failed to delete namespace '$namespace'. Retrying..."
                sleep 5
            done

            # Check deletion status
            if [[ $retries -eq 0 ]]; then
                echo "Failed to delete namespace '$namespace' after multiple attempts. Please check manually."
                exit 1
            fi
        fi

        echo "Namespace '$namespace' deleted successfully"
    done

    echo "==================================================="

    # Delete secrets
    kubectl --kubeconfig="$kubeconfig" get secret -A | grep helm | awk '{print $2}' | xargs kubectl --kubeconfig="$kubeconfig" delete secret

    echo "Kyverno and Nirmata-related resources are deleted from the cluster"



    echo "-------------Cleaning up the Cluster from Nirmata---------------"
    if [ $# -lt 2 ]; then
        echo "Usage: $0 kubeconfig clustername Nirmata-API-Token Nirmata-URL namespace1 [namespace2 ...]"
        echo ""
        echo "* kubeconfig: Absolute path of kubeconfig file for the cluster"
        echo "* clustername: Cluster name in Nirmata UI"
        echo "* Nirmata-API-Token: Token for accessing the Nirmata API"
        echo "* Nirmata-URL: URL of the Nirmata API"
        echo "* namespace1: Name of the first namespace to be cleaned up (e.g., 'kyverno')"
        echo "* namespace2...: Names of the additional namespaces to be cleaned up"
        echo ""
        echo "Eg: $0 /home/user/.kube/config test-cluster <Nirmata-API-Token> https://www.nirmata.io  nirmata-kyverno-operator kyverno nirmata"
    else
        TOKEN=$3
        NIRMATAURL=$4
        CLUSTERNAME=$2
        CLUSTERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=id,name" | jq -r ".[] | select(.name == \"$CLUSTERNAME\").id")
        echo $CLUSTERID > clusterid_$CLUSTERNAME

        for clusterid in $(cat clusterid_$CLUSTERNAME); do
            echo "Deleting cluster $CLUSTERNAME from Nirmata..."
            delete_response=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X DELETE "$NIRMATAURL/cluster/api/KubernetesCluster/$clusterid?action=remove")

            if [[ $? -eq 0 ]]; then
                echo "$delete_response"
                echo "$CLUSTERNAME deletion request sent successfully"
            fi

            # Wait until the cluster is completely removed
            while true; do
                cluster_exists=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$clusterid")

                if [[ -z "$cluster_exists" ]]; then
                    echo "Cluster $CLUSTERNAME has been successfully deleted from Nirmata"
                    break
                elif [[ "$cluster_exists" == *"KubernetesCluster:$clusterid not found"* ]]; then
                    echo "Cluster $CLUSTERNAME not found. Assuming deletion is complete."
                    break
                else
                    echo "Cluster $CLUSTERNAME is still being deleted. Waiting for completion..."
                    sleep 10
                fi
            done
        done
    fi
fi 


    echo "==================================================="



