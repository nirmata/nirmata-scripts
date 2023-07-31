# Script to collect nirmata services logs

# Prerequisites 
It uses kubeconfig from /root/.kube/config and switch context to base cluster

<ins>**Usage:**</ins>

```sh
- './collect-nirmata-services-logs.sh <NirmataURL> <Nirmata-service> <Namespace>'
- Eg: collect-nirmata-services-logs.sh https://www.nirmata.io <Nirmata-service> <Namespace>
- Eg: collect-nirmata-services-logs.sh https://www.nirmata.io config nirmata
- Nirmata Services: activity,catalog,cluster,config,environments,users

Make sure to replace <NirmataURL>,<Nirmata-service> and <Namespace> with appropriate values 
```
