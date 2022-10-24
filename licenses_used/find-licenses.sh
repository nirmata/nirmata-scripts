#!/usr/bin/bash

NIRMATAURL="https://nirmata.io"
TOTAL_LICENSES=0
JQ_COUNT=$(which jq | wc -l)
CURL_COUNT=$(which curl | wc -l)


if [[ $JQ_COUNT = 0 ]]; then
        echo -e "Please install jq before running this script"
        exit 1
fi

if [[ $CURL_COUNT = 0 ]]; then
        echo -e "Please install curl before running this script"
        exit 1
fi

echo
echo -e "Enter the Nirmata API token: \n"
read -s TOKEN

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=name" | jq .[].name | sed "s/\"//g" > clusters.txt

echo
python -c 'print "-" * 120'
printf '%-40s %-15s %-15s %-15s %-15s %-15s\n' CLUSTERNAME MEMORY_LIMIT MEMORY_REQUEST MEMORY_CAPACITY MEMORY_USAGE LICENSES_USED
python -c 'print "-" * 120'

for CLUSTERNAME in $(cat clusters.txt)
do
        CLUSTERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=id,name" 2>&1 | jq ".[] | select( .name == \"$CLUSTERNAME\" ).id" | sed "s/\"//g")
        #echo -e "$CLUSTERNAME:\t$CLUSTERID"
        MEMCAP=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID/ClusterStats?fields=memoryCapacity" | jq .[].memoryCapacity)
        MEMLIMIT=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID/ClusterStats?fields=memoryLimit" | jq .[].memoryLimit)
        MEMREQUEST=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID/ClusterStats?fields=memoryRequest" | jq .[].memoryRequest)
        MEMUSAGE=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$CLUSTERID/ClusterStats?fields=memoryUsage" | jq .[].memoryUsage)
        MEMCAP_GiB=$(jq -n $MEMCAP/1073741824)
        MEMLIMIT_GiB=$(jq -n $MEMLIMIT/1073741824)
        MEMREQUEST_GiB=$(jq -n $MEMREQUEST/1073741824)
        MEMUSAGE_GiB=$(jq -n $MEMUSAGE/1073741824)
        MEMCAP_ROUND=$(echo $MEMCAP_GiB | awk '{print int($1+0.5)}')
        (( LICENSES_USED=($MEMCAP_ROUND+32-1)/32 ));
        let TOTAL_LICENSES=$((TOTAL_LICENSES + LICENSES_USED))
        printf '%-40s %-15.2f %-15.2f %-15s %-15.2f %-15s\n' $CLUSTERNAME $MEMLIMIT_GiB $MEMREQUEST_GiB $MEMCAP_ROUND $MEMUSAGE_GiB $LICENSES_USED

done

python -c 'print "-" * 120'
printf '%104s %-15s\n' TOTAL_LICENSES: $TOTAL_LICENSES
echo -e "\nNOTE: All the memory values defined in the table above are in GiB\n"
