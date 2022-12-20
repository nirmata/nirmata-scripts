$ cat install-addon.sh
#!/usr/bin/bash

#set -x

if [[ $# != 3 ]]; then
        echo -e "\nUsage: $0 <Nirmata-URL> <cluster-name> <addon>\n\nAvailable addons:\n- Kyverno\n- Velero\n- Openebs\n- Metallb\n- Prometheus\n"
        exit 1;
fi

NIRMATA_URL=$1
CLUSTER_NAME=$2
ADDON_NAME=$3

echo -e "\nEnter the Nirmata API token: "
read -s TOKEN

CLUSTER_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATA_URL/cluster/api/KubernetesCluster?fields=id,name" | jq -r ".[] | select( .name == \"$CLUSTER_NAME\" ).id")

PARENT_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATA_URL/cluster/api/KubernetesCluster/$CLUSTER_ID?fields=id,parent" | jq -r '.parent.id')

curl -s -o /dev/null -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/cluster/api/txn" -d "
{
  \"create\": [],
  \"update\": [
    {
      \"kyvernoConfigSelector\": \"default-developer\",
      \"id\": \"$CLUSTER_ID\",
      \"modelIndex\": \"KubernetesCluster\",
      \"parent\": {
        \"id\": \"$PARENT_ID\",
        \"service\": \"Cluster\",
        \"modelIndex\": \"Root\",
        \"childRelation\": \"clusters\"
      }
    }
  ],
  \"delete\": []
}"

curl -s -o /dev/null -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTER_ID/kyverno-addon"
if [[ $? = 0 ]]; then
        echo "$3 addon deployed successfully!"
else
        echo "$3 addon deployed failed!"
fi
