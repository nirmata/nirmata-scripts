#!/bin/bash

# Set error handling
set -e

# Setup logging
LOG_FILE="kyverno-cleanup-$(date +%Y%m%d-%H%M%S).log"
log() {
    local message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Function to display usage
usage() {
    echo "Usage: $0 <k8s-context> <operator-namespace> <kyverno-namespace>"
    echo "Example: $0 my-cluster nirmata-system kyverno"
    echo "         $0 my-cluster nirmata kyverno"
    exit 1
}

# Check if correct number of arguments are provided
if [ $# -ne 3 ]; then
    echo "Error: Incorrect number of arguments"
    usage
fi

# Store arguments
K8S_CONTEXT=$1
OPERATOR_NAMESPACE=$2
KYVERNO_NAMESPACE=$3

# Validate namespace names
if [[ ! $OPERATOR_NAMESPACE =~ ^[a-z0-9-]+$ ]] || [[ ! $KYVERNO_NAMESPACE =~ ^[a-z0-9-]+$ ]]; then
    echo "Error: Namespace names can only contain lowercase letters, numbers, and hyphens"
    usage
fi

# Validate and switch to the specified context
log "Validating Kubernetes context..."
if ! kubectl config get-contexts $K8S_CONTEXT &>/dev/null; then
    log "Error: Context '$K8S_CONTEXT' not found in kubeconfig"
    log "Available contexts:"
    kubectl config get-contexts -o name
    exit 1
fi

# Switch to the specified context
log "Switching to context: $K8S_CONTEXT"
kubectl config use-context $K8S_CONTEXT

# Verify cluster access
if ! kubectl cluster-info &>/dev/null; then
    log "Error: Unable to connect to cluster. Please check your credentials and network connection."
    exit 1
fi

log "Starting Nirmata Kyverno Operator cleanup..."
log "Kubernetes Context: $K8S_CONTEXT"
log "Operator namespace: $OPERATOR_NAMESPACE"
log "Kyverno namespace: $KYVERNO_NAMESPACE"

# Function to remove finalizers from resources
remove_finalizers() {
    local resource_type=$1
    local namespace=$2
    local resources=$(kubectl get $resource_type -n $namespace -o name 2>/dev/null || true)
    
    if [ ! -z "$resources" ]; then
        log "Removing finalizers from $resource_type in namespace $namespace..."
        for resource in $resources; do
            log "Removing finalizers from $resource"
            kubectl patch $resource -n $namespace -p '{"metadata":{"finalizers":[]}}' --type=merge || true
        done
    fi
}

# Function to remove finalizers from CRDs
remove_crd_finalizers() {
    local crd_name=$1
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log "Attempt $attempt: Removing finalizers from CRD $crd_name..."
        
        # Get the current finalizers
        local finalizers=$(kubectl get crd $crd_name -o jsonpath='{.metadata.finalizers}' 2>/dev/null || echo "")
        
        if [ -z "$finalizers" ]; then
            log "No finalizers found on CRD $crd_name"
            return 0
        fi
        
        # Remove finalizers
        kubectl patch crd $crd_name -p '{"metadata":{"finalizers":[]}}' --type=merge || true
        
        # Wait a moment to allow the change to take effect
        sleep 5
        
        # Verify finalizers were removed
        finalizers=$(kubectl get crd $crd_name -o jsonpath='{.metadata.finalizers}' 2>/dev/null || echo "")
        if [ -z "$finalizers" ]; then
            log "Successfully removed finalizers from CRD $crd_name"
            return 0
        fi
        
        log "Finalizers still present on CRD $crd_name, attempt $attempt of $max_attempts"
        attempt=$((attempt + 1))
    done
    
    log "Warning: Failed to remove finalizers from CRD $crd_name after $max_attempts attempts"
    return 1
}

# Function to delete a CRD
delete_crd() {
    local crd_name=$1
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log "Attempt $attempt: Deleting CRD $crd_name..."
        
        # First remove finalizers
        remove_crd_finalizers "$crd_name"
        
        # Wait a moment before attempting deletion
        sleep 5
        
        # Attempt to delete the CRD
        if kubectl delete crd $crd_name --ignore-not-found=true; then
            log "Successfully deleted CRD $crd_name"
            return 0
        fi
        
        # Check if CRD still exists
        if ! kubectl get crd $crd_name &>/dev/null; then
            log "CRD $crd_name no longer exists"
            return 0
        fi
        
        log "CRD $crd_name still exists, attempt $attempt of $max_attempts"
        attempt=$((attempt + 1))
        sleep 5
    done
    
    log "Warning: Failed to delete CRD $crd_name after $max_attempts attempts"
    return 1
}

# Function to delete resources in a namespace
delete_namespace_resources() {
    local namespace=$1
    log "Cleaning up resources in namespace $namespace..."
    
    # First, scale down all deployments to 0 replicas
    log "Scaling down all deployments in namespace $namespace..."
    kubectl get deployment -n $namespace -o name | xargs -r kubectl scale -n $namespace --replicas=0

    # Wait for pods to terminate
    log "Waiting for pods to terminate..."
    kubectl wait --for=delete pod -l app.kubernetes.io/name=kyverno -n $namespace --timeout=60s || true
    kubectl wait --for=delete pod -l app.kubernetes.io/name=kyverno-operator -n $namespace --timeout=60s || true
    
    # Additional wait to ensure all pods are terminated
    log "Additional wait to ensure all pods are terminated..."
    sleep 10
    
    # Verify no pods are running
    if kubectl get pods -n $namespace 2>/dev/null | grep -v "No resources found" > /dev/null; then
        log "Warning: Some pods are still running in namespace $namespace"
        kubectl get pods -n $namespace
    fi

    # Remove finalizers from all resources
    log "Removing finalizers from resources in namespace $namespace..."
    for resource_type in all configmap secret serviceaccount role rolebinding networkpolicy pvc pdb hpa service ingress endpoints events; do
        log "Removing finalizers from $resource_type resources..."
        kubectl get $resource_type -n $namespace -o name 2>/dev/null | while read resource; do
            if [ ! -z "$resource" ]; then
                log "Removing finalizers from $resource"
                kubectl patch $resource -n $namespace -p '{"metadata":{"finalizers":[]}}' --type=merge || true
            fi
        done
    done
    
    # Delete all resources in the namespace
    log "Deleting all resources in namespace $namespace..."
    for resource_type in all configmap secret serviceaccount role rolebinding networkpolicy pvc pdb hpa service ingress endpoints events; do
        log "Deleting all $resource_type resources..."
        kubectl delete $resource_type --all -n $namespace --ignore-not-found=true
    done
}

# Clean up operator namespace
if kubectl get namespace $OPERATOR_NAMESPACE &>/dev/null; then
    log "Cleaning up $OPERATOR_NAMESPACE namespace..."
    delete_namespace_resources "$OPERATOR_NAMESPACE"
fi

# Clean up kyverno namespace
if kubectl get namespace $KYVERNO_NAMESPACE &>/dev/null; then
    log "Cleaning up $KYVERNO_NAMESPACE namespace..."
    delete_namespace_resources "$KYVERNO_NAMESPACE"
fi

# Delete cluster-wide resources
log "Cleaning up cluster-wide resources..."

# Delete webhook configurations
log "Deleting webhook configurations..."
for webhook in \
    "kyverno-cleanup-validating-webhook-cfg" \
    "kyverno-exception-validating-webhook-cfg" \
    "kyverno-global-context-validating-webhook-cfg" \
    "kyverno-operator-validating-webhook-configuration" \
    "kyverno-policy-validating-webhook-cfg" \
    "kyverno-resource-validating-webhook-cfg" \
    "kyverno-ttl-validating-webhook-cfg" \
    "kyverno-policy-mutating-webhook-cfg" \
    "kyverno-resource-mutating-webhook-cfg" \
    "kyverno-verify-mutating-webhook-cfg"; do
    log "Deleting webhook configuration: $webhook"
    kubectl delete validatingwebhookconfiguration $webhook --ignore-not-found=true || \
    kubectl delete mutatingwebhookconfiguration $webhook --ignore-not-found=true
done

# Delete RBAC resources
log "Deleting RBAC resources..."
# Delete all Kyverno cluster roles
for role in \
    "nirmata-kyverno-operator" \
    "kyverno-operator" \
    "kyverno:webhook" \
    "kyverno:cleanup-controller" \
    "kyverno:background-controller" \
    "kyverno:reports-controller" \
    "kyverno:leaderelection" \
    "kyverno:userinfo" \
    "kyverno:admin" \
    "kyverno:view" \
    "kyverno:admission-controller" \
    "kyverno:admission-controller:core" \
    "kyverno:background-controller:core" \
    "kyverno:cleanup-controller:core" \
    "kyverno:rbac:admin:policies" \
    "kyverno:rbac:admin:policyreports" \
    "kyverno:rbac:admin:reports" \
    "kyverno:rbac:admin:updaterequests" \
    "kyverno:rbac:view:policies" \
    "kyverno:rbac:view:policyreports" \
    "kyverno:rbac:view:reports" \
    "kyverno:rbac:view:updaterequests" \
    "kyverno:reports-controller:core"; do
    log "Deleting cluster role: $role"
    kubectl delete clusterrole $role --ignore-not-found=true
done

# Delete all Kyverno cluster role bindings
for binding in \
    "nirmata-kyverno-operator" \
    "kyverno-operator" \
    "kyverno:webhook" \
    "kyverno:cleanup-controller" \
    "kyverno:background-controller" \
    "kyverno:reports-controller" \
    "kyverno:leaderelection" \
    "kyverno:userinfo" \
    "kyverno:admin" \
    "kyverno:view" \
    "kyverno:admission-controller" \
    "kyverno:admission-controller:view" \
    "kyverno:background-controller:view" \
    "kyverno:reports-controller:view"; do
    log "Deleting cluster role binding: $binding"
    kubectl delete clusterrolebinding $binding --ignore-not-found=true
done

# Delete CRDs
log "Deleting CRDs..."
for crd in \
    "kyvernoconfigs.security.nirmata.io" \
    "policysets.security.nirmata.io" \
    "kyvernoadapters.security.nirmata.io" \
    "clusterpolicies.kyverno.io" \
    "policies.kyverno.io" \
    "policyexceptions.kyverno.io" \
    "admissionreports.kyverno.io" \
    "backgroundscanreports.kyverno.io" \
    "cleanuppolicies.kyverno.io" \
    "clusteradmissionreports.kyverno.io" \
    "clusterbackgroundscanreports.kyverno.io" \
    "clustercleanuppolicies.kyverno.io" \
    "globalcontextentries.kyverno.io" \
    "updaterequests.kyverno.io" \
    "clusterephemeralreports.reports.kyverno.io" \
    "ephemeralreports.reports.kyverno.io" \
    "policyreports.wgpolicyk8s.io" \
    "clusterpolicyreports.wgpolicyk8s.io"; do
    
    # Delete the CRD with retries
    delete_crd "$crd"
    
    # Wait a moment after deletion
    sleep 5
done

log "Cleanup completed! Log file: $LOG_FILE" 
