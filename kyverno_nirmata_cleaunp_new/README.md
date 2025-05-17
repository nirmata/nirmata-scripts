# Kyverno Cleanup Technical Documentation

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
   ```yaml
   - kyvernoconfigs.security.nirmata.io
   - policysets.security.nirmata.io
   - kyvernoadapters.security.nirmata.io
   - clusterpolicies.kyverno.io
   - policies.kyverno.io
   - policyexceptions.kyverno.io
   - admissionreports.kyverno.io
   - backgroundscanreports.kyverno.io
   - cleanuppolicies.kyverno.io
   - clusteradmissionreports.kyverno.io
   - clusterbackgroundscanreports.kyverno.io
   - clustercleanuppolicies.kyverno.io
   - globalcontextentries.kyverno.io
   - updaterequests.kyverno.io
   - clusterephemeralreports.reports.kyverno.io
   - ephemeralreports.reports.kyverno.io
   - policyreports.wgpolicyk8s.io
   - clusterpolicyreports.wgpolicyk8s.io
   ```

2. **Webhook Configurations**
   ```yaml
   - kyverno-operator-validating-webhook-configuration
   - kyverno-resource-validating-webhook-configuration
   - kyverno-policy-validating-webhook-configuration
   - kyverno-resource-mutating-webhook-configuration
   - kyverno-policy-mutating-webhook-configuration
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
- Ensures no active controllers are running

### 3. Finalizer Removal
- Removes finalizers from all resources
- Handles both namespace and cluster-wide resources
- Uses `kubectl patch` with `--type=merge`

### 4. Resource Deletion Order
1. Namespace resources (pods, services, etc.)
2. Webhook configurations
3. RBAC resources (roles, rolebindings)
4. CRDs

### 5. Error Handling
- Uses `--ignore-not-found=true` for all deletions
- Logs all errors with timestamps
- Continues execution on non-critical errors

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
[2024-03-21 14:30:24] Removing finalizers from CRD: kyvernoconfigs.security.nirmata.io
```

## Common Issues and Solutions

### 1. Stuck Resources
If resources are stuck in terminating state:
- Check for remaining finalizers
- Verify no controllers are running
- Ensure proper permissions

### 2. Finalizer Re-addition
If finalizers are being re-added:
- Ensure all deployments are scaled to 0
- Wait for pods to terminate
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

## Security Considerations

- No sensitive data in logs
- Uses `--ignore-not-found=true` to prevent errors
- Validates input to prevent command injection
- Requires explicit context selection 
