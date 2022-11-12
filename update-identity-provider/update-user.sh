#!/usr/bin/bash


if [[ $# != 2 ]]; then
        echo -e "\nUsage: $0 <Nirmata URL> <CSV FILE>\n"
        exit 1
fi

NIRMATAURL=$1
FILENAME=$2

echo -e "\nEnter the Nirmata API token: \n"
read -s TOKEN

TENANT_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "https://www.nirmata.io/users/api/tenant?fields=id" | jq '.[].id' | sed "s/\"//g")

for line in $(cat $FILENAME | grep -v Name)
do
        USERNAME=$(echo $line | cut -d "," -f 2)
        USEREMAIL=$(echo $line | cut -d "," -f 3)
        USERID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/user?fields=id,name" | jq ".[] | select( .name == \"$USERNAME\" ).id" | sed "s/\"//g")

        curl -s -o /dev/null -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/users/api/txn" -d "
                {
                  \"create\": [],
                  \"update\": [
                    {
                      \"name\": \"$USERNAME\",
                      \"email\": \"$USEREMAIL\",
                      \"identityProvider\": \"SAML\",
                      \"id\": \"$USERID\",
                      \"modelIndex\": \"User\",
                      \"parent\": {
                        \"id\": \"$TENANT_ID\",
                        \"service\": \"Users\",
                        \"modelIndex\": \"Tenant\",
                        \"childRelation\": \"users\"
                      },
                      \"mfaEnabled\": false
                    }
                  ],
                  \"delete\": []
                }"
                if [[ $? = 0 ]]; then
                        echo "User \"$USERNAME\" updated"
                else
                        echo "Something went wrong while updating the user \"$USERNAME\""
                fi
done
