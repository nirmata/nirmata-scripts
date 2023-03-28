#!/usr/bin/bash

if [[ $# != 3 ]]; then
        echo -e "\nUsage: \t$0 <cluster-name> <Nirmata URL> <Kubelet-arg-to-add>\n"
        echo -e "Example: $0 demo-cluster https://nirmata.io --cgroup-driver=systemd"
        exit 1
fi

CLUSTERNAME=$1

NIRMATAURL=$2

KUBELETARGS=$3

echo -e "\nEnter the Nirmata API token: \n"
read -s TOKEN

CLUSTERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=id,name" 2>&1 | jq ".[] | select( .name == \"$CLUSTERNAME\" ).id" | sed "s/\"//g")

#echo "CLUSTERID: $CLUSTERID"

CLUSTERENV=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID/clusterEnvironment" | jq -r .clusterEnvironment.id)

#echo "CLUSTERENV: $CLUSTERENV"


CLUSTERENV_VAR=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/config/api/environment/$CLUSTERENV/environmentVariables" 2>&1 | jq ".[] | select( .key == \"KUBELET_ARGS\" ).id" | sed "s/\"//g")

VALUE_TEMP=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/config/api/environment/$CLUSTERENV/environmentVariables?fields=value,id,key" 2>&1 | jq ".[] | select( .key == \"KUBELET_ARGS\" ).value" | sed "s/\"//g")

VALUE="$VALUE_TEMP $KUBELETARGS"

curl -s -o /dev/null -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/config/api/txn" -d "

{
  \"create\": [],
  \"update\": [
    {
      \"services\": [
        \"kubelet:v1.24.9\"
      ],
      \"key\": \"KUBELET_ARGS\",
      \"value\": \"$VALUE\",
      \"id\": \"$CLUSTERENV_VAR\",
      \"modelIndex\": \"EnvironmentVariable\",
      \"parent\": {
        \"id\": \"$CLUSTERENV\",
        \"service\": \"Config\",
        \"modelIndex\": \"Environment\",
        \"childRelation\": \"environmentVariables\"
      }
    }
  ],
  \"delete\": []
}"
if [[ $? = 0 ]]; then
        echo "Kubelet arguments updated successfully"
else
        echo "Something went wrong. Failed to update the kubelet arguments in Nirmata"
fi
