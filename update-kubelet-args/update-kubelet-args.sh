#!/usr/bin/bash

## function to check and install jq based on the ostype

installjq() {

        # Check the operating system
        if [[ "$(uname)" == "Darwin" ]]; then
                # Mac OS X
                brew install jq
        elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
                # Linux
                if [[ -n "$(command -v yum)" ]]; then
                        # CentOS, RHEL, Fedora
                        sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                        sudo yum install -y jq
                elif [[ -n "$(command -v apt-get)" ]]; then
                        # Debian, Ubuntu, Mint
                        sudo apt-get update
                        sudo apt-get install -y jq
                elif [[ -n "$(command -v zypper)" ]]; then
                        # OpenSUSE
                        sudo zypper install -y jq
                elif [[ -n "$(command -v pacman)" ]]; then
                        # Arch Linux
                        sudo pacman -S --noconfirm jq
                else
                        echo "Error: Unsupported Linux distribution."
                        exit 1
                fi
        else
                echo "Error: Unsupported operating system."
                exit 1
        fi

        # Print the version of jq installed
        jq --version

}

## main

if [[ -n "$(command -v jq)" ]]; then
    echo "jq is installed."
    jq --version
else
    echo -e "\njq is not installed. Installing jq ...\n"
    installjq
fi

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
