#!/usr/bin/bash

printgreen() {

        echo -e "${GREEN}$1 ${NC}"

}

printred() {

        echo -e "${RED}$1 ${NC}"

}

printyellow() {

        echo -e "${YELLOW}$1 ${NC}"

}


RED='\033[0;31m'
NC='\033[0m' # No Color
YELLOW='\033[1;33m'
GREEN='\033[1;32m'


if [[ $# != 1 ]]; then
        printred "\nUsage: $0 <cluster-name>"
        exit 1
fi

AWS_ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_ID=$(aws eks describe-cluster --name $1 --query "cluster.identity.oidc.issuer" --output text 2> /dev/null | awk -F/ '{ print $NF }')


if [[ ! -z "$OIDC_ID" ]]; then
        sed "s/111122223333/$AWS_ACCOUNT/g" aws-ebs-csi-driver-trust-policy.json > aws-ebs-csi-driver-trust-policy_temp.json
        sed -i "s/region-code/us-west-1/g" aws-ebs-csi-driver-trust-policy_temp.json
        sed -i "s/EXAMPLED539D4633E53DE1B71EXAMPLE/$OIDC_ID/g" aws-ebs-csi-driver-trust-policy_temp.json

        CHECK_ROLE=$(aws iam list-roles | jq .Roles[].RoleName | sed "s;\";;g" | grep -w AmazonEKS_EBS_CSI_DriverRole_$1)

        if [[ -z $CHECK_ROLE ]]; then

                printgreen "\nCreating EBS CSI driver IAM role for service account!"
                aws iam create-role --role-name AmazonEKS_EBS_CSI_DriverRole_$1 --assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy_temp.json" 1> /dev/null
                aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --role-name AmazonEKS_EBS_CSI_DriverRole_$1 1> /dev/null
        else
                printred "\nRole AmazonEKS_EBS_CSI_DriverRole_$1 already exists. Please try with a different cluster name"
                exit 1
        fi
else
        printred "\nCould not find a cluster with a name $1"
        exit 1
fi

printgreen "Deploying EBS CSI add-on!"

aws eks create-addon --cluster-name $1 --addon-name aws-ebs-csi-driver --service-account-role-arn arn:aws:iam::$AWS_ACCOUNT:role/AmazonEKS_EBS_CSI_DriverRole_$1 1> /dev/null

sleep 2m

STATUS=$(aws eks describe-addon --cluster-name $1 --addon-name aws-ebs-csi-driver | grep ACTIVE)

if [[ ! -z $STATUS ]]; then
        printgreen "Add-on deployed successfully!"
else
        printred "Add-on deploying is taking time. Please check the status of pods for any errors!"
fi
