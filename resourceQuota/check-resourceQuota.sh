#!/usr/bin/bash

NIRMATAURL=$1

echo -e "\nEnter the Nirmata API token: "
read -s TOKEN


# Get resourceQuota id's

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus?fields=id" | jq -r '.[].id' > resourcequotaids.txt

echo
python -c 'print "-" * 120'
printf '%-40s %-30s %-10s %-10s %-15s %-15s\n' ENV_NAME CLUSTER_NAME CPU_LIMIT CPU_USED MEMORY_LIMIT MEMORY_USED
python -c 'print "-" * 120'

for rqid in $(cat resourcequotaids.txt)
do
        #set -x
        #echo $rqid
        ENVIRONMENTID=""
        ENVIRONMENTNAME=""
        ENVIRONMENTID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus/$rqid?fields=id,ancestors" | jq -r ".ancestors[] | select( .modelIndex == \"Environment\" ).id" 2> /dev/null)
        #echo $ENVIRONMENTID
        if [[ ! -z $ENVIRONMENTID ]]; then
                ENVIRONMENTNAME=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/Environment/$ENVIRONMENTID?fields=name" | jq -r '.name' 2> /dev/null)
                HARDCPU=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus/$rqid?fields=hard,used" | jq -r '.hard.cpu')
                HARDMEMORY=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus/$rqid?fields=hard,used" | jq -r '.hard.memory')
                USEDCPU=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus/$rqid?fields=hard,used" | jq -r '.used.cpu')
                USEDMEMORY=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/ResourceQuotaStatus/$rqid?fields=hard,used" | jq -r '.used.memory')
                CLUSTERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/Environment/$ENVIRONMENTID?fields=id,hostCluster" | jq -r '.hostCluster.id')
                CLUSTERNAME=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID?fields=name" | jq -r '.name')
                printf '%-40s %-30s %-10s %-10s %-15s %-15s\n' $ENVIRONMENTNAME $CLUSTERNAME $HARDCPU $USEDCPU $HARDMEMORY $USEDMEMORY
        fi
        #echo $ENVIRONMENTNAME
done

python -c 'print "-" * 120'
echo
