#!/usr/bin/bash

#set -x

# This script is used to delete nirmata users who do not belong to any teams. Before you run this script, please make sure you have curl and jq installed. Make sure to update the <api-key> value in the script. NOTE: <api-key> can be found under your nirmata profile.

TOKEN=<api-key>
URL=www.nirmata.io
COUNT=0

curl --location --request GET "https://$URL/users/api/User?fields=name,id,email,role,teams" --header "Accept: application/json" --header "Authorization: NIRMATA-API $TOKEN" --header 'Content-Type: application/json' | jq '.[] | select( .teams == [] ).id' > noteams.txt

for nuser in $(cat noteams.txt)
do
		
		curl --location --request DELETE "https://$URL/users/api/users/$nuser" \
                --header 'Accept: application/json' \
                --header 'Content-Type: application/json' \
                --header "Authorization: NIRMATA-API $TOKEN"
		COUNT=$((COUNT+1))
done

echo -e "\n$COUNT users have been deleted from nirmata who were not part of any teams"
