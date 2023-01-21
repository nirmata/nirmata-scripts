SECRET=$1
NAMESPACE=$2
SERVER_CRT=$3
SERVER_KEY=$4
URL=$5

#Check certificates are present
if [[ -f "$SERVER_CRT" && -f "$SERVER_KEY" ]]; 
then
  echo "cert files are present"
else
  echo "cert files not present"
  exit 1
fi

#Check Domain name in cert
CERT_DOMAIN_NAME=$(openssl x509 -noout -subject -in  $SERVER_CRT | sed -e 's/^subject.*CN=\([a-zA-Z0-9\.\-]*\).*$/\1/')
if [ $URL = $CERT_DOMAIN_NAME ]
then
    echo "domain name is correct on certificate"
    sleep 2
else
    echo "domain name mismatch. Exiting"
    exit 1
fi

# Check certificate expiry days
if openssl x509 -checkend 5184000 -noout -in $SERVER_CRT
then
  echo "Certificate is good for next 60 day!"
  sleep 2
else
  echo "Certificate has expired or will do so within 60 days!"
  exit 1
fi

#check secret is present
kubectl get secret $SECRET -n $NAMESPACE
if [ "$?" -ne "0" ]; then
  echo "secret $SECRET not found in $NAMESPACE. Exiting.."
  exit 1
else
  echo "secret $SECRET found in $NAMESPACE"
  sleep 2
fi

#Backup Secret
kubectl get secret $SECRET -n $NAMESPACE -o yaml > $SECRET-backup-$(date +%F_%T)
if [ "$?" -ne "0" ]; then
  echo "Backup Failed! Exiting.."
  exit 1
else
  echo "Backup Completed"
  sleep 2
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
  sleep 2
fi

#Restart haproxy pods
HAPROXY_PODS=$(kubectl get pods -n $NAMESPACE | grep haproxy | awk '{print $1}')
for POD_NAME in $HAPROXY_PODS
do
    kubectl delete pod $POD_NAME -n $NAMESPACE
    if [ "$?" -ne "0" ]; then
        echo "pod deletion failed"
        exit 1
    else
        sleep 10
    fi
done

echo "pod restart completed"
