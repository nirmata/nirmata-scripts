# Kyverno Cleanup Technical Documentation

## Usage

### Prerequisites
- kubectl installed and configured
- Access to the target Kubernetes cluster
- Sufficient permissions to delete resources (cluster-admin or equivalent)

### Basic Usage
```bash
./cleanup-kyverno.sh <k8s-context> <operator-namespace> <kyverno-namespace>
```

### Example
```bash
# For Nirmata operator
./cleanup-kyverno.sh my-cluster nirmata-system kyverno

# For standard Kyverno installation
./cleanup-kyverno.sh my-cluster nirmata kyverno
```

### Parameters
- `<k8s-context>`: The Kubernetes context to use
- `<operator-namespace>`: The namespace where the operator is installed
- `<kyverno-namespace>`: The namespace where Kyverno is installed

### Output
- The script generates a log file named `kyverno-cleanup-YYYYMMDD-HHMMSS.log`
- All operations are logged with timestamps
- Progress and errors are displayed in real-time

## Resource Types Cleaned Up

### Namespace Resources
The script cleans up the following resources in both the operator and Kyverno namespaces:

1. **Workload Resources**
   - Deployments
   - StatefulSets
   - DaemonSets
   - Jobs
   - CronJobs
   - Pods

2. **Service Resources**
   - Services
   - Endpoints
   - Ingress
   - NetworkPolicies

3. **Configuration Resources**
   - ConfigMaps
   - Secrets
   - ServiceAccounts
   - Roles
   - RoleBindings

4. **Storage Resources**
   - PersistentVolumeClaims
   - PersistentVolumes

5. **Policy Resources**
   - PodDisruptionBudgets
   - HorizontalPodAutoscalers

### Cluster-wide Resources

1. **Custom Resource Definitions (CRDs)**
   The script uses a simplified approach to delete CRDs:
   ```bash
   kubectl get crd | egrep -i 'kyverno|nirmata|wgp' | awk '{ print $1 }' | xargs kubectl delete crd --force
   ```
   This command:
   - Gets all CRDs
   - Filters for ones containing 'kyverno', 'nirmata', or 'wgp' (case insensitive)
   - Extracts just the CRD names
   - Force deletes them all at once

2. **Webhook Configurations**
   ```yaml
   # Validating Webhook Configurations
   - kyverno-cleanup-validating-webhook-cfg
   - kyverno-exception-validating-webhook-cfg
   - kyverno-global-context-validating-webhook-cfg
   - kyverno-operator-validating-webhook-configuration
   - kyverno-policy-validating-webhook-cfg
   - kyverno-resource-validating-webhook-cfg
   - kyverno-ttl-validating-webhook-cfg

   # Mutating Webhook Configurations
   - kyverno-policy-mutating-webhook-cfg
   - kyverno-resource-mutating-webhook-cfg
   - kyverno-verify-mutating-webhook-cfg
   ```

3. **Cluster Roles**
   ```yaml
   - nirmata-kyverno-operator
   - kyverno-operator
   - kyverno:webhook
   - kyverno:cleanup-controller
   - kyverno:background-controller
   - kyverno:reports-controller
   - kyverno:leaderelection
   - kyverno:userinfo
   - kyverno:admin
   - kyverno:view
   - kyverno:admission-controller
   - kyverno:admission-controller:core
   - kyverno:background-controller:core
   - kyverno:cleanup-controller:core
   - kyverno:rbac:admin:policies
   - kyverno:rbac:admin:policyreports
   - kyverno:rbac:admin:reports
   - kyverno:rbac:admin:updaterequests
   - kyverno:rbac:view:policies
   - kyverno:rbac:view:policyreports
   - kyverno:rbac:view:reports
   - kyverno:rbac:view:updaterequests
   - kyverno:reports-controller:core
   ```

4. **Cluster Role Bindings**
   ```yaml
   - nirmata-kyverno-operator
   - kyverno-operator
   - kyverno:webhook
   - kyverno:cleanup-controller
   - kyverno:background-controller
   - kyverno:reports-controller
   - kyverno:leaderelection
   - kyverno:userinfo
   - kyverno:admin
   - kyverno:view
   - kyverno:admission-controller
   - kyverno:admission-controller:view
   - kyverno:background-controller:view
   - kyverno:reports-controller:view
   ```

## Cleanup Process Details

### 1. Pre-cleanup Validation
- Validates Kubernetes context existence
- Verifies cluster access
- Validates namespace names format
- Checks for required permissions

### 2. Deployment Scaling
- Scales all deployments to 0 replicas
- Waits for pods to terminate (60s timeout)
- Additional 10-second wait to ensure complete termination
- Verifies no pods are still running
- Logs warning if pods are still present

### 3. Finalizer Removal
- Implements retry mechanism (3 attempts) for finalizer removal
- Verifies finalizer removal success after each attempt
- 5-second wait between attempts
- Handles both namespace and cluster-wide resources
- Uses `kubectl patch` with `--type=merge`
- Logs all finalizer removal attempts and results

### 4. Resource Deletion Order
1. Namespace resources (pods, services, etc.)
2. Webhook configurations
3. RBAC resources (roles, rolebindings)
4. CRDs with verification between steps

### 5. Error Handling
- Uses `--ignore-not-found=true` for all deletions
- Logs all errors with timestamps
- Continues execution on non-critical errors
- Implements retry logic for finalizer removal
- Provides detailed logging of operation status

## Log File Format

The script generates a log file with the following format:
```
[YYYY-MM-DD HH:MM:SS] Message
```

Example:
```
[2024-03-21 14:30:22] Starting Nirmata Kyverno Operator cleanup...
[2024-03-21 14:30:22] Kubernetes Context: my-cluster
[2024-03-21 14:30:23] Cleaning up resources in namespace nirmata-system...
[2024-03-21 14:30:23] Scaling down all deployments in namespace nirmata-system...
[2024-03-21 14:30:24] Attempt 1: Removing finalizers from CRD: kyvernoconfigs.security.nirmata.io
[2024-03-21 14:30:29] Successfully removed finalizers from CRD kyvernoconfigs.security.nirmata.io
```

## Common Issues and Solutions

### 1. Stuck Resources
If resources are stuck in terminating state:
- Check for remaining finalizers using retry mechanism
- Verify no controllers are running
- Ensure proper permissions
- Use the enhanced finalizer removal process

### 2. Finalizer Re-addition
If finalizers are being re-added:
- Ensure all deployments are scaled to 0
- Wait for pods to terminate (60s timeout + 10s additional wait)
- Verify no pods are running
- Use retry mechanism for finalizer removal
- Check for running controllers

### 3. Permission Issues
If encountering permission errors:
- Verify cluster-admin or equivalent permissions
- Check namespace-level permissions
- Ensure proper RBAC access

## Performance Considerations

- Script uses parallel deletion where possible
- Implements timeouts for long-running operations
- Includes sleep periods to allow for resource cleanup
- Logs all operations for performance analysis
- Retry mechanism with appropriate wait times
- Verification steps between major operations

## Security Considerations

- No sensitive data in logs
- Uses `--ignore-not-found=true` to prevent errors
- Validates input to prevent command injection
- Requires explicit context selection
- Implements proper error handling and logging
- Verifies operation success before proceeding 
