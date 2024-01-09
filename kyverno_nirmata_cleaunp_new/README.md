Certainly! Here's a simple README for the given script:

---

# Kubernetes Namespace Cleanup Script

This script is designed to clean up Kubernetes namespaces. It requires at least two arguments:

### Usage

```bash
./namespace_cleanup.sh kubeconfig namespace1 [namespace2 ...]
```

#### Script Arguments

- `kubeconfig`: Absolute path of the kubeconfig file for the cluster.
- `namespace1`: Name of the first namespace to be cleaned up (e.g., 'kyverno').
- `namespace2...`: Names of additional namespaces to be cleaned up.

### Example

```bash
./namespace_cleanup.sh /home/user/.kube/config  nirmata-system niramta-kyverno-operator kyverno
```

### Warning

If the number of arguments is less than 2, the script will display a usage message.
