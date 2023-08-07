# Addon-kyverno-v1.7.5

This Cleanup script is used to cleanup Kyverno and its related resouces from the Kubernetes Cluster

<ins>**Usage:**</ins>
- Make sure you have `kubectl clinet`, `curl` and `jq` installed on the machine where you are running this script
- Make sure you have kubectl access to the cluster with kubeconfig file
- The script takes two arguments as inputs : `./cleanup-kyverno.sh kubeconfig name`
	- `kubeconfig` : Absolute path of kubeconfig file for the cluster, example /home/user/.kube/config
	- `name` : Name of the resource to be cleand up, in this case 'kyverno'


# Installing kyverno as Add-on

This README documents the kyverno integration as Nirmata add-on on Kubernetes clusters.

### What is Kyverno?
Kyverno is a policy engine designed for Kubernetes. It can validate, mutate, and generate configurations using admission controls and background scans. Kyverno policies are Kubernetes resources and do not require learning a new language. Kyverno is designed to work nicely with tools you already use like kubectl, kustomize, and Git.

### How do I get set up?
1. Create a Nirmata catalog application(YAML Based)
2. Edit the catalog application and select an add-on category (e.g. Security). This is required to select the application as a add-on.
3. Update a Cluster Type, or create a new one, and select the kyverno add-on application in the "Add-Ons" section. Ensure that the namespace you use is "**kyverno**" and environment is "kyverno-< cluster-name >"
4. Create clusters using the cluster type.
5. If addon is to be added to a running cluster, create a environemnt with namespace "**kyverno**" and choose this environment while deploying the application
6. Verify that the application is running.

