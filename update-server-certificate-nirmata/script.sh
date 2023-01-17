SECRET=$1
NAMESPACE=$2
SERVER_CRT=$3
SERVER_KEY=$4

#Check certificates are present
if [[ -f "$SERVER_CRT" && -f "$SERVER_KEY" ]]; 
then
  echo "cert files are present"
else
  echo "cert files not present"
  exit 1
fi

#Check Namespace is present
namespaceStatus=$(kubectl get ns $NAMESPACE -o json | jq .status.phase -r)
if [ "$namespaceStatus" == "Active" ]
then
    echo "namespace is present"
else
   echo "namespace is not present"
   exit 1
fi

#check secret is present
kubectl get secret $SECRET -n $NAMESPACE
if [ "$?" -ne "0" ]; then
  echo "secret $SECRET not found in $NAMESPACE. Exiting.."
  exit 1
else
  echo "secret $SECRET found in $NAMESPACE"
fi

#Backup Secret
kubectl get secret $SECRET -n $NAMESPACE -o yaml > $SECRET-backup-$(date +%F_%T)
if [ "$?" -ne "0" ]; then
  echo "Backup Failed! Exiting.."
  exit 1
else
  echo "Backup Completed"
fi

#sleep for 5 seconds
sleep 5

#Delete Secret
kubectl delete secret $SECRET -n $NAMESPACE
if [ "$?" -ne "0" ]; then
  echo "Delete Failed! Exiting.."
  exit 1
else
  echo "Old secret Deleted"
fi

#Create New secret
kubectl create secret generic $SECRET --from-file=server.crt=$SERVER_CRT --from-file=server.key=$SERVER_KEY -n $NAMESPACE
if [ "$?" -ne "0" ]; then
  echo "New secret creation Failed"
  exit 1
else
  echo "New secret created Successfully"
fi
