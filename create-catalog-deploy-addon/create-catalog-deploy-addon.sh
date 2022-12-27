#!/usr/bin/bash

#Nirmata Token
TOKEN="xxx"

#Nirmata URL
NIRMATAURL="https://nirmata.io"

#Catalog where app gets created
catalogName="xxxx"

#Namespace where addon should be deployed
namespace="xxxx"

#Name of git credentail setup in Nirmata
gitCred="xxx"

#Name of newly created catalog App
catalogAppName="xxxx"

#Name of cluster where addon should be deployed
clusterName="xxxx"

#Reposiory URL
repositoryURL="xxx"

#Kustomize Overlay File
overlayFile="xxx"

#get catalogID
catalogId=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/catalog/api/catalogs?fields=name,id" | jq -r ".[] | select( .name == \"$catalogName\" ).id")
echo Catalog ID is $catalogId

#get Git Credential 
gitCredId=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/environments/api/gitcredentials?fields=id,name" | jq ".[] | select( .name == \"$gitCred\" ).id" | sed "s/\"//g")
echo Git Cred ID is $gitCredId

catalogAppID=""
catalogAppID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/catalog/api/Application?fields=name,id" | jq -r ".[] | select( .name == \"$catalogAppName\" ).id")
echo catalog app id is $catalogAppID

if [ -z "$catalogAppID" ]
then
      echo "Catalog Application Not created yet. Creating..."
      curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/catalog/api/txn" -d "
{
  \"create\": [
    {
      \"name\": \"$catalogAppName\",
      \"upstreamType\": \"git\",
      \"parent\": \"$catalogId\",
      \"namespace\": \"$namespace\",
      \"modelIndex\": \"Application\",
      \"gitUpstream\": {
        \"name\": \"$catalogAppName\",
        \"branch\": \"main\",
       \"repository\": \"$repositoryURL\",
        \"directoryList\": [
          \"/\"
        ],
        \"includeList\": [
          \"*.yaml\",
          \"*.yml\"
        ],
        \"modelIndex\": \"GitUpstream\",
        \"gitCredential\": [
          {
            \"service\": \"environments\",
            \"modelIndex\": \"GitCredential\",
            \"id\": \"$gitCredId\"
          }
        ]
      },
      \"kustomizeConfig\": {
        \"overlayFile\": \"/$overlayFile\"
      },
      \"labels\": {
        \"nirmata.io/application.type\": \"cluster-addon\",
        \"nirmata.io/application.addon.type\": \"Other\"
      }
    }
  ],
  \"update\": [],
  \"delete\": []
}"
else
      echo "Catalog Application alreadty created"
fi

#get cluster ID
clusterId=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster?fields=id,name" 2>&1 | jq ".[] | select( .name == \"$clusterName\" ).id" | sed "s/\"//g")

#get Addon ID
ADDON_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/cluster/api/KubernetesCluster/$clusterId?fields=id,addOns" | jq -r '.addOns[].id')

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/cluster/api/txn" -d "
{
  \"create\": [
    {
      \"parent\": \"$ADDON_ID\",
      \"application\": \"$catalogAppName\",
      \"channel\": \"Rapid\",
      \"name\": \"$catalogAppName\",
      \"namespace\": \"ingress-haproxy\",
      \"type\": \"required\",
      \"environment\": \"ingress-haproxy\",
      \"labels\": {},
      \"catalog\": \"$catalogName\",
      \"modelIndex\": \"ClusterAddOn\"
    }
  ],
  \"update\": [],
  \"delete\": []
}"
