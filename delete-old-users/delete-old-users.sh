#!/usr/bin/bash

if [[ $# != 1 ]]; then
        echo -e "\nUsage: $0 <Nirmata URL>\n"
        exit 1
fi

NIRMATAURL=$1
NOOFDAYS=365

echo -e "Enter the Nirmata API token: \n"
read -s TOKEN

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/User?fields=id,name,lastLogin" | jq -r ".[].id" > userids.txt

for user in $(cat userids.txt);
do
    #set -x
    LASTLOGIN=""
    USERNAME=""
    LASTLOGIN=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/User/${user%$'\r'}"  | jq -r ".lastLogin" | sed 's/,//g')
    USERNAME=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X GET "$NIRMATAURL/users/api/User/${user%$'\r'}"  | jq -r ".name")
    #echo
    #echo -e "$USERNAME:\t$LASTLOGIN"
    if [[ $LASTLOGIN = null ]]; then
        continue
    else
            echo
            echo -e "Username: $USERNAME\nLast login: $LASTLOGIN"
            target_timestamp=$(date -d "$LASTLOGIN" +%s)
            #echo "target_timestamp: $target_timestamp"
            current_timestamp=$(date +%s)

            time_diff=$(expr $current_timestamp - $target_timestamp)
            #echo "time_diff: $time_diff"
            No_of_days_since_last_login=$(expr $time_diff / 86400)
            echo "No of days since last login: $No_of_days_since_last_login"
            if [[ $No_of_days_since_last_login -gt $NOOFDAYS ]]; then

                echo -e "\nDeleting user $USERNAME from Nirmata..." | tee -a deleted-users.txt
                curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "Authorization: NIRMATA-API $TOKEN" -X POST "$NIRMATAURL/users/api/txn" -d "
                {
                \"create\": [],
                \"update\": [],
                \"delete\": [
                {
                        \"id\": \"$user\",
                        \"modelIndex\": \"User\"
                }
  ]
}"
            fi

    fi
done

echo
echo "Deleted Users list: "
echo "--------------------"
cat deleted-users.txt
echo
