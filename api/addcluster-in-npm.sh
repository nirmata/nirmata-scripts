#!/usr/bin/bash

CLUSTERNAME=$1
TOKEN="<api-token>"
NIRMATAURL="https://www.nirmata.io"

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/cluster/api/txn" -d "
{
  \"create\": [
    {
      \"mode\": \"discovered\",
      \"name\": \"$CLUSTERNAME\",
      \"typeSelector\": \"default-manual-install-policy-manager-type\",
      \"isKyvernoAutoInstall\": false,
      \"isKyvernoExist\": true,
      \"modelIndex\": \"KubernetesCluster\",
      \"config\": [
        {
          \"endpoint\": \"\",
          \"cloudProvider\": \"Other\",
          \"modelIndex\": \"ClusterConfig\",
          \"overrideValues\": null
        }
      ],
      \"accessControlList\": [
        {
          \"modelIndex\": \"AccessControlList\"
        }
      ]
    }
  ],
  \"update\": [],
  \"delete\": []
}" | jq . > register-cluster.json

CLUSTERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=id,name" 2>&1 | jq ".[] | select( .name == \"$CLUSTERNAME\" ).id" | sed "s/\"//g")

sed "s/tokenvariable/$CLUSTERID/g" nirmata-kube-controller-template.yaml > nirmata-kube-controller-$CLUSTERNAME.yaml

kubectl apply -f nirmata-kube-controller-$CLUSTERNAME.yaml 1> /dev/null
kubectl apply -f nirmata-kube-controller-$CLUSTERNAME.yaml 1> /dev/null
