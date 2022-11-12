#!/usr/bin/bash


if [[ $# != 2 ]]; then
        echo -e "\nUsage: $0 <Nirmata URL> <CSV FILENAME>\n"
        exit 1
fi

STRING="ea1qa"
NIRMATAURL=$1
FILENAME=$2

echo -e "\nEnter the Nirmata API token: \n"
read -s TOKEN

TENANT_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/tenant?fields=id" | jq '.[].id' | sed "s/\"//g")

cat $FILENAME | grep -v Name | cut -d "," -f 2- > $FILENAME.tmp2



for user in $(cat $FILENAME.tmp2 | sort | uniq)
do
        #set -x
        USER_EXISTS=""
        EMAIL=""
        USER=""
        USER=$(echo $user | cut -d "," -f 1)
        EMAIL=$(echo $user | cut -d "," -f 2)
        USER_EXISTS=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/user?fields=id,name" | jq ".[] | select( .name == \"$USER\" ).id" | sed "s/\"//g")
        if [[ -z $USER_EXISTS ]]; then
                curl -s -o /dev/null -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/users/api/txn" -d "
                {
                  \"create\": [
                    {
                      \"role\": \"devops\",
                      \"name\": \"$USER\",
                      \"email\": \"$EMAIL\",
                      \"identityProvider\": \"SAML\",
                      \"teams\": [],
                      \"mfaEnabled\": false,
                      \"modelIndex\": \"User\",
                      \"parent\": \"$TENANT_ID\"
                    }
                  ],
                  \"update\": [],
                  \"delete\": []
                }"
                if [[ $? = 0 ]]; then
                        echo "User \"$USER\" created successfully"
                else
                        echo "Something went wrong when creating user \"$USER\""
                fi
        else
                echo "User \"$USER\" already exists"
        fi
done
