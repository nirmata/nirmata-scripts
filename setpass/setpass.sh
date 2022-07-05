#!/usr/bin/bash

urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

#set -x

echo -e "\nEnter the sysadmin email id: "
read sysemailid

echo -e "\nEnter the sysadmin password: "
read -s syspass

echo -e "\nEnter the https Nirmata URL: "
read url

echo -e "\nEnter the tenant name: "
read tenantname

NIRMATA_URL="$url"
TENANT_NAME="$tenantname"
ADMIN_USER_NAME="$sysemailid"
ADMIN_PASS="$syspass"
ADMIN_ID="ecc0ed90-3fd4-484e-ad21-f13b84646d62"
echo -e "\nFetching tenant id"

ENCODE_STRING="{\"name\":\"$TENANT_NAME\"}"

TENANT_ID_ENCODED=$(urlencode $ENCODE_STRING)

#echo "$TENANT_ID_ENCODED"

# https://stackoverflow.com/questions/35018899/using-curl-in-a-bash-script-and-getting-curl-3-illegal-characters-found-in-ur
# Refer the link above on why we need below command

TENANT_ID_ENCODED=${TENANT_ID_ENCODED%$'\r'}


TENANT_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "nirmata-user-id:$ADMIN_ID" -u "$ADMIN_USER_NAME:$ADMIN_PASS" -X GET "$url/users/api/Tenant?query=$TENANT_ID_ENCODED" | jq -r '.[0].id')

if [[ $? != 0 ]]; then
        echo -e "\nThe superadmin password or the ADMIN_ID provided to the script are not correct. Please try again!"
        exit 1
fi

echo $TENANT_ID

echo -e "\nFetching user ID's"
echo -e "--------------------"


USER_ID=$(curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "nirmata-user-id:$ADMIN_ID" -u "$ADMIN_USER_NAME:$ADMIN_PASS" -X GET $url/users/api/Tenant/$TENANT_ID/users urlencode | jq -r '.[ ] | .name, .id')

echo "$USER_ID"

echo -e "\nEnter the user id for whom you want to set the password: "
read userid

echo -e "\nEnter the password for the userid you just entered:"
read -s userpassword

echo "Updating password"

curl -s -H "Accept: application/json, text/javascript, */*; q=0.01" -H "nirmata-user-id:$ADMIN_ID" -u "$ADMIN_USER_NAME:$ADMIN_PASS" -X PUT $url/users/api/User/$userid -d '
{
 "password":'$userpassword'
}'
